import 'package:firebase_multi_factor_auth/firebase_multi_factor_auth.dart';
import 'package:firebase_multi_factor_auth/functions/firestore_post.dart';
import 'package:firebase_multi_factor_auth/provider/auth_provider.dart';
import 'package:firebase_multi_factor_auth/provider/otp_provider.dart';
import 'package:firebase_multi_factor_auth/provider/user_provider.dart';
import 'package:firebase_multi_factor_auth/utils/fields/firestore_collections.dart';
import 'package:firebase_multi_factor_auth/utils/fields/firestore_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsernameInputWidget extends StatefulWidget {
  const UsernameInputWidget({Key? key}) : super(key: key);

  @override
  _UsernameInputWidgetState createState() => _UsernameInputWidgetState();
}

class _UsernameInputWidgetState extends State<UsernameInputWidget> {
  var isLoading = false;
  final usernameController = TextEditingController();

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future<Function?> verifyUsername() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    setLoading(true);

    if (usernameController.text.toString().contains("\"") ||
        usernameController.text.toString().contains("'") ||
        usernameController.text.toString().contains("%") ||
        usernameController.text.toString().contains("`") ||
        usernameController.text.toString().contains("´") ||
        usernameController.text.toString().contains("{") ||
        usernameController.text.toString().contains("}") ||
        usernameController.text.toString().contains(";") ||
        usernameController.text.toString().contains("\$") ||
        usernameController.text.toString().length > 16 ||
        usernameController.text.toString().length < 4 ||
        usernameController.text.toString().isEmpty) {
      /* What about hebreic chars? */
      setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Special characters like \" ' % ´ ` \$ ; are not allowed and the name must be shorter than 17 chars and longer than 4.")));
      return null;
    }

    userProvider.userLocal.username = usernameController.text.toString();
    var isSaved = await firestorePost(FirestoreCollections.public_users,
        authProvider.auth.currentUser?.uid ?? "", {
      FirestoreFields.username: usernameController.text.toString(),
      /* FirestoreFields.firstLogin: false, */
    });

    await FirebaseMultiFactorAuth.setFirstLogin(
        context: context, isFirstLogin: false);

    if (isSaved) {
      await userProvider.fetchFromFirestore();
      // trigger the listener ;)
      userProvider.notifyListeners();
      authProvider.notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Please retry. The internet connection was interupted.")));
    }
    setLoading(false);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var otpProvider = Provider.of<OTPProvider>(context, listen: false);
    // Provider.of<OTPProvider>(context, listen: false).otpState = state;
    // After state change => rebuild

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: usernameController,
            onSubmitted: (value) => verifyUsername(),
            enabled: !isLoading,
            cursorColor: Theme.of(context).colorScheme.primary,
            maxLength: 16,
            decoration: const InputDecoration(
              helperText: "Choose a funky Username ;)",
              hintText: "BossDaniel",
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextButton(
            child: const Text("SEND"),
            onPressed: isLoading ? null : verifyUsername,
          ),
          isLoading ? CircularProgressIndicator() : Container(),
        ],
      ),
    );
  }
}
