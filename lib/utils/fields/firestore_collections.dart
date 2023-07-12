import 'package:cloud_firestore/cloud_firestore.dart';

/// c = collection
/// d = document
/// f = field
class FirestoreCollections {
  static var private_users = FirebaseFirestore.instance.collection("private");
  static var public_users = FirebaseFirestore.instance.collection("public");
}
