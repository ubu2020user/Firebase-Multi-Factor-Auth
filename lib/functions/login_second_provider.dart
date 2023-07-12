import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_multi_factor_auth/provider/user_provider.dart';
import 'package:firebase_multi_factor_auth/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/otp_provider.dart';

/// The second provider is currently always the phone number login.
Future<void> functionLoginSecondProvider(
    {required BuildContext context, required String phoneNumber}) async {
  var otpProvider = Provider.of<OTPProvider>(context, listen: false);
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  var authProvider = Provider.of<AuthProvider>(context, listen: false);
  otpProvider.phoneNumber = phoneNumber
      .replaceAll(" ", "")
      .replaceAll("00", "+")
      .replaceAll("\"", "")
      .replaceAll("\$", "")
      .trim();

  if (!kIsWeb) {
    await authProvider.auth.verifyPhoneNumber(
      phoneNumber: otpProvider.phoneNumber,
      verificationCompleted: (phoneAuthCredential) async {
        otpProvider.otpState = OTPState.OTP_SENT;
      },
      verificationFailed: (verificationFailed) async {
        toastOtpError(context, verificationFailed.message.toString());
      },
      codeSent: (verificationId, resendingToken) async {
        toastOtpSuccess(context);
        otpProvider.verificationID = verificationId;
        userProvider.userLocal.phoneNumber = otpProvider.phoneNumber!;

        otpProvider.otpState = OTPState.OTP_SENT;
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        if (verificationId != otpProvider.verificationID) {
          logger.d("CodeAutoRetrieval different verificationID");
        }
        logger.d("Code auto retrieval timeout");
      },
    );
  } else {
    /* Not mobile */
    try {
      otpProvider.confirmationResult = await FirebaseAuth.instance
          .signInWithPhoneNumber(otpProvider.phoneNumber!);
      otpProvider.verificationID =
          otpProvider.confirmationResult!.verificationId;
      toastOtpSuccess(context);
      userProvider.userLocal.phoneNumber = otpProvider.phoneNumber!;
      otpProvider.otpState = OTPState.OTP_SENT;
      // UserCredential userCredential = await confirmationResult.confirm('123456');
    } catch (error) {
      toastOtpError(context, error.toString());
    }
  }
}

void toastOtpSuccess(BuildContext context, {String message = ""}) {
  logger.i("Otp has been sent $message");
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("OTP has been sent $message")));
}

void toastOtpError(BuildContext context, String message) {
  logger.e("Phone Verification failed");
  logger.d("Failed Phone Verification $message");

  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Phone Verification failed $message")));
}
