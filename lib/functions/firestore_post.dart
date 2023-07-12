import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/logger.dart';

/// This is a simple helper function for firestore posting requests.
/// It returns a bool value if the request was successful or not.
/// It takes the collection reference, the document name and the data to be saved.
/// The merge parameter is optional and defaults to true.
/// If merge is true, the data will be merged with the existing data.
Future<bool> firestorePost(
    CollectionReference<Map<String, dynamic>> collectionReference,
    String doc,
    Map<String, dynamic> data,
    {bool merge = true}) async {
  bool result = false;
  try {
    await collectionReference
        .doc(doc)
        .set(data, merge ? SetOptions(merge: true) : SetOptions(merge: false))
        .then((value) {
      result = true;
      logger.d("Firestore request successful.");
    }).catchError((error) {
      logger.d("Error at saving data to firestore $error");
    });
  } catch (exception) {
    logger.d("[Caught] Error at saving data to firestore $exception");
  }
  return result;
}
