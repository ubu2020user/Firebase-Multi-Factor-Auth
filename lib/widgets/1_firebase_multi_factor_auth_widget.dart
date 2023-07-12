import 'package:firebase_multi_factor_auth/provider/auth_provider.dart';
import 'package:firebase_multi_factor_auth/provider/otp_provider.dart';
import 'package:firebase_multi_factor_auth/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '2_auth_controller_widget.dart';

class FirebaseMultiFactorAuthWidget extends StatelessWidget {
  const FirebaseMultiFactorAuthWidget({
    Key? key,
    required this.loginWidget,
    required this.otpControllerWidget,
    required this.mainWidget,
  }) : super(key: key);

  final Widget loginWidget, otpControllerWidget, mainWidget;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => OTPProvider()),
      ],
      builder: (context, child) => AuthControllerWidget(
        loginWidget: loginWidget,
        otpControllerWidget: otpControllerWidget,
        mainWidget: mainWidget,
      ),
    );
  }
}
