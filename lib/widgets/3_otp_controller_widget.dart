import 'package:firebase_multi_factor_auth/provider/otp_provider.dart';
import 'package:firebase_multi_factor_auth/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../utils/logger.dart';

/// This widget is used to control the flow of the One-Time-Passcode (OTP) flow.
/// [phoneInputWidget] is the widget that is shown when the user may enter their phone number.
/// [firstLoginWidget] is the widget that is shown when the user is logging in for the first time.
/// [otpSentWidget] is the widget that is shown when the OTP is sent to the user's phone.
///
/// The [OTPProvider] is a [ChangeNotifier] that is used to notify the [OTPControllerWidget]
class OTPControllerWidget extends StatelessWidget {
  const OTPControllerWidget(
      {super.key,
      required this.otpSentWidget,
      required this.firstLoginWidget,
      required this.phoneInputWidget});

  final Widget otpSentWidget, firstLoginWidget, phoneInputWidget;

  @override
  Widget build(BuildContext context) {
    return Consumer<OTPProvider>(
        builder: (context, value, child) => buildOnStateChange(context, value));
  }

  Widget buildOnStateChange(BuildContext context, OTPProvider otpProvider) {
    if (otpProvider.otpState == OTPState.OTP_SENT) {
      return otpSentWidget;
    } else if (otpProvider.otpState == OTPState.FIRST_LOGIN) {
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      if (userProvider.userFetched != null) {
        if (userProvider.userFetched!.firstLogin) {
          return firstLoginWidget;
        } else {
          logger.d("2 Factor Authenticated!!! TWO FACTOR 2fa");
          Provider.of<AuthProvider>(context, listen: false)
              .is2FactorAuthenticated = true;
        }
      }
    }

    return phoneInputWidget;
  }
}
