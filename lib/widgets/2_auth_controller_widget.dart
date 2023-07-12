import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_multi_factor_auth/provider/auth_provider.dart';
import 'package:firebase_multi_factor_auth/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthControllerWidget extends StatelessWidget {
  const AuthControllerWidget({
    Key? key,
    required this.loginWidget,
    required this.otpControllerWidget,
    required this.mainWidget,
  }) : super(key: key);

  final Widget loginWidget, mainWidget, otpControllerWidget;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, data, child) => buildOnStateChange(data, context),
    );
  }

  @override
  Widget buildOnStateChange(AuthProvider authProvider, BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    if (user == null) {
      return loginWidget;
    } else {
      if (userProvider.userLocal.uidProviderFirst!.isEmpty) {
        // google is the first provider and its uuid to be cached for later usage and review
        userProvider.userLocal.uidProviderFirst = user.uid;
      }

      if (authProvider.is2FactorAuthenticated == null) {
        return Material(
            child: Scaffold(body: Center(child: CircularProgressIndicator())));
      } else if (!authProvider.is2FactorAuthenticated!) {
        // Start routing through otp and 2fa screens
        return otpControllerWidget;
      } else {
        // TODO Provider.of<SettingsProvider>(context, listen: false).loadAllSettings();
        return mainWidget;
      }
    }
  }
}
