import 'package:firebase_multi_factor_auth/widgets/1_firebase_multi_factor_auth_widget.dart';
import 'package:firebase_multi_factor_auth/widgets/3_otp_controller_widget.dart';
import 'package:firebase_multi_factor_auth_example/widgets/1_login_widget.dart';
import 'package:firebase_multi_factor_auth_example/widgets/2_otp_phone_input_widget.dart';
import 'package:firebase_multi_factor_auth_example/widgets/3_otp_verification_input_widget.dart';
import 'package:firebase_multi_factor_auth_example/widgets/4_username_input_widget.dart';
import 'package:firebase_multi_factor_auth_example/widgets/5_main_widget.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Multi Factor Auth Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text('MFA Plugin example app')),
        body: const FirebaseMultiFactorAuthWidget(
          otpControllerWidget: OTPControllerWidget(
            phoneInputWidget: OTPPhoneWidget(),
            firstLoginWidget: UsernameInputWidget(),
            otpSentWidget: OTPVerificationWidget(),
          ),
          mainWidget: MainWidget(),
          loginWidget: LoginWidget(),
        ),
      ),
    );
  }
}
