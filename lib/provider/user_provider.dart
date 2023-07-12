import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_multi_factor_auth/models/user_data.dart';
import 'package:firebase_multi_factor_auth/utils/fields/firestore_collections.dart';
import 'package:firebase_multi_factor_auth/utils/fields/firestore_fields.dart';
import 'package:firebase_multi_factor_auth/utils/logger.dart';
import 'package:flutter/cupertino.dart';

/// User data parsed by or to the Firestore database.
class UserProvider with ChangeNotifier {
  UserData userLocal = UserData.empty();
  UserData? userFetched;

  bool _disposed = false;

  /// Sign this provider out and erase its data with this function
  void reset() {
    _disposed = true;
    userLocal = UserData.empty();
    userFetched = null;
    _disposed = false;

    logger.i("[UserProvider] Should be signed out!");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchFromFirestore() async {
    try {
      var resultPrivate = await FirestoreCollections.private_users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      var resultPublic = await FirestoreCollections.public_users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userFetched = null;
      var user = UserData.empty();
      if (resultPrivate.exists) {
        user = UserData.empty();
        user.uidProviderFirst =
            resultPrivate.data()![FirestoreFields.uidProviderFirst] ?? "";
        user.phoneNumber = resultPrivate.data()![FirestoreFields.phone];
        user.firstLogin =
            resultPrivate.data()![FirestoreFields.firstLogin] ?? true;
      }

      if (resultPublic.exists) {
        user.username = resultPublic.data()![FirestoreFields.username];
        userFetched = user;
        return resultPublic;
      } else {
        // no network or no data?
        userFetched = UserData.empty();
      }
    } catch (exception) {
      logger.e("Failed to fetch user data", exception);
    }

    return null;
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
