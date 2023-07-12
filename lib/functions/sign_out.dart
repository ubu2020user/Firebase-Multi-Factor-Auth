import 'package:firebase_multi_factor_auth/provider/otp_provider.dart';
import 'package:firebase_multi_factor_auth/provider/user_provider.dart';
import 'package:firebase_multi_factor_auth/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

Future<void> functionSignOut({required BuildContext context}) async {
  try {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.reset();

    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.reset();

    var otpProvider = Provider.of<OTPProvider>(context, listen: false);
    otpProvider.reset();

    authProvider.notifyListeners();
    otpProvider.notifyListeners();
    userProvider.notifyListeners();

    // reload the page via method call
    if (kIsWeb) {
      MethodChannel channel =
          const MethodChannel('com.ubu2020user.firebase_multi_factor_auth');
      channel.invokeMethod("reloadPage");
    } else {
      // navigate to top route to try to dismiss the sign out button screen
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    logger.i("Should be signed out. :)");
  } catch (ex) {
    logger.e("Error while signing out", ex);
  }
}
