import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_multi_factor_auth/provider/otp_provider.dart';
import 'package:firebase_multi_factor_auth/utils/logger.dart';
import 'package:firebase_multi_factor_auth/utils/storage/encrypted_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  late FirebaseAuth auth;

  bool _disposed = false;

  AuthProvider() {
    logger.d("Initialized Firebase Multi Factor Auth.");
    auth = FirebaseAuth.instance;
    EncryptedStorage().is2FactorAuthenticated().then((isAuthenticated) {
      _is2FactorAuthenticated = isAuthenticated;
      notifyListeners();
    });
  }

  bool? _is2FactorAuthenticated;
  bool? get is2FactorAuthenticated => _is2FactorAuthenticated;

  set is2FactorAuthenticated(bool? isAuthenticated) {
    if (isAuthenticated == null || isAuthenticated == _is2FactorAuthenticated) {
      return;
    }

    _is2FactorAuthenticated = isAuthenticated;
    EncryptedStorage()
        .update2FactorAuthenticated(isAuthenticated)
        .then((value) {
      notifyListeners();
    });
  }

  /// Sign this provider out and erase its data with this function
  Future<void> reset() async {
    _disposed = true;

    _is2FactorAuthenticated = false;
    await EncryptedStorage().reset();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();

    _disposed = false;

    logger.i("[AuthProvider] Should be signed out!");
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
