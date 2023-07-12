import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_multi_factor_auth/provider/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/otp_provider.dart';
import '../utils/fields/firestore_collections.dart';
import '../utils/fields/firestore_fields.dart';
import '../utils/logger.dart';
import 'firestore_post.dart';

Future<bool> functionCheckOTPPhone(BuildContext context, String smsCode) async {
  var otpProvider = Provider.of<OTPProvider>(context, listen: false);
  var userProvider = Provider.of<UserProvider>(context, listen: false);

  try {
    if (kIsWeb) {
      await otpProvider.confirmationResult!.confirm(smsCode);
    } else {
      /* Mobile */
      await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: otpProvider.verificationID!, smsCode: smsCode));
    }

    // fetch has to be here. Else no phone number => no results
    await userProvider.fetchFromFirestore();

    if (userProvider.userLocal.uidProviderFirst.isEmpty ||
        userProvider.userFetched == null) {
      logger.d(
          "userProvider.userFetched == null ${userProvider.userFetched == null}");
      return false;
    }

    if (userProvider.userFetched!.isEmpty() ||
        userProvider.userFetched!.uidProviderFirst.isEmpty) {
      logger.d("First login uid saved");

      await firestorePost(FirestoreCollections.private_users,
          FirebaseAuth.instance.currentUser?.uid ?? "", {
        FirestoreFields.uidProviderFirst:
            userProvider.userLocal.uidProviderFirst,
        FirestoreFields.phone: userProvider.userLocal.phoneNumber,
        FirestoreFields.firstLogin: true,
      });
    } else if (userProvider.userLocal.uidProviderFirst !=
        userProvider.userFetched!.uidProviderFirst) {
      /* Wrong UID */
      logger.e("Wrong Provider UID");
      return false;
    }

    logger.d("Changing to MissingFieldCheck");
    otpProvider.otpState = OTPState.FIRST_LOGIN;
    return true;
  } catch (error) {
    // todo on first login otp screen twice????? + launcher icon ;)
    logger.e("Phone auth failed!", error);
    if (error.toString().contains("firebase_auth/invalid-verification-code")) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid verification code")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Phone auth failed! Please try again or contact the support.")));
      otpProvider.otpState = OTPState.PHONE_INPUT;
    }
    return false;
  }
}
