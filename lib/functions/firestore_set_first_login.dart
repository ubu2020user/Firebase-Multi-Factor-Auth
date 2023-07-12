import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_multi_factor_auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/otp_provider.dart';
import '../utils/fields/firestore_collections.dart';
import '../utils/fields/firestore_fields.dart';
import 'firestore_post.dart';

Future<bool> functionSetFirstLogin(
    {required BuildContext context, required bool isFirstLogin}) async {
  var res = await firestorePost(FirestoreCollections.private_users,
      FirebaseAuth.instance.currentUser?.uid ?? "", {
    FirestoreFields.firstLogin: isFirstLogin,
  });

  Provider.of<OTPProvider>(context, listen: false).notifyListeners();
  Provider.of<AuthProvider>(context, listen: false).notifyListeners();

  return res;
}
