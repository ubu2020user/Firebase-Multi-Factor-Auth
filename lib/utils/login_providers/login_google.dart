import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_multi_factor_auth/provider/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../logger.dart';

/// Auth flow for Google
/// 1. Do not to forget to add SHA1 and SHA256 to firebase after creating your android studio debug signing key
/// 2. Then flutterfire configure -> Downloads new google-services.json
/// 3. flutter clean ;)
class GoogleLogin {
  Future<UserCredential?> signIn(AuthProvider authProvider) async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        userCredential =
            await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
        logger.i("Logged in via google on web");
        authProvider.notifyListeners();
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        userCredential =
            await FirebaseAuth.instance.signInWithCredential(authCredential);
        logger.i("Logged in via google on mobile");
        authProvider.notifyListeners();
      }
      // FirebaseAuth.instance.signInWithCredential(authCredential); // important!
      return userCredential;
    } catch (error) {
      logger.e("Error while singing in with google", error);
    }
    return null;
  }
}
