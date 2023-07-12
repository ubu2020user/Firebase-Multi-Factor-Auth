class UserData {
  String? username, phoneNumber;

  /// The first provider is the google uid which will be later overwritten by the second login
  /// The second provider is probably the phone login which will be later used as Unique IDentifier for firestore documents.
  /// The second provider can be always retrieved via (FirebaseAuth.instance.) currentUser.uid
  String uidProviderFirst = "";

  bool firstLogin = true;

  UserData.empty();

  bool isEmpty() {
    return username == null && phoneNumber == null && uidProviderFirst.isEmpty;
  }
}
