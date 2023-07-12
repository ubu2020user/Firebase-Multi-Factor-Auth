import 'dart:html';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FirebaseMultiFactorAuthWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'com.ubu2020user.firebase_multi_factor_auth',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = FirebaseMultiFactorAuthWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls from the Flutter code.
  ///
  /// If the method call is 'restartApp', it calls the `restart` method with the given `webOrigin`.
  /// Otherwise, it returns 'false' to signify that the method call was not recognized.
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'reloadPage':
        window.location.reload();
        return 'true';
      default:
        return 'false';
    }
  }
}
