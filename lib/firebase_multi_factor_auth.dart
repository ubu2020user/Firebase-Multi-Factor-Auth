import 'package:firebase_multi_factor_auth/models/multi_factor_auth_type.dart';
import 'package:firebase_multi_factor_auth/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'functions/check_otp_phone.dart';
import 'functions/firestore_set_first_login.dart';
import 'functions/login_first_provider.dart';
import 'functions/login_second_provider.dart';
import 'functions/sign_out.dart';

class FirebaseMultiFactorAuth {
  /// Login with google
  static void loginFirstProvider({
    required BuildContext context,
    MultiFactorAuthType authType = MultiFactorAuthType.GOOGLE,
  }) =>
      functionLoginFirstProvider(context: context, authType: authType);

  /// Check otp code and login
  static Future<bool> inputPhoneOTP(
          {required BuildContext context, required String otpCode}) =>
      functionCheckOTPPhone(context, otpCode);

  /// Input phone number and send otp
  static Future<void> inputPhoneNumberSendOTP(
          {required BuildContext context, required String phoneNumber}) =>
      functionLoginSecondProvider(context: context, phoneNumber: phoneNumber);

  /// Change First Login to false
  static Future<void> setFirstLogin(
          {required BuildContext context, required bool isFirstLogin}) =>
      functionSetFirstLogin(context: context, isFirstLogin: isFirstLogin);

  static bool isPhoneNumberInputed({required BuildContext context}) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    return !(userProvider.userLocal.uidProviderFirst.isEmpty &&
        userProvider.userLocal.phoneNumber == null);
  }

  /// Sign out
  static Future<void> signOut({required BuildContext context}) async =>
      functionSignOut(context: context);

  /// Check if the local user trying to log in has the same phoneNumber and google uid provider as the fetched user under his uid of the second provider.
  /// The second provider uid is used as identifier in the firestore documents.
  static bool isLocalUserMatchingOnlineUser({required BuildContext context}) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    return (userProvider.userFetched != null &&
        (userProvider.userFetched!.uidProviderFirst !=
                userProvider.userLocal.uidProviderFirst ||
            userProvider.userFetched!.phoneNumber !=
                userProvider.userLocal.phoneNumber));
  }
}
