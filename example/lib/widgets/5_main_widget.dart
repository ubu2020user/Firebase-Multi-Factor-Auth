import 'package:firebase_multi_factor_auth/firebase_multi_factor_auth.dart';
import 'package:flutter/material.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Logged in! :D'),
          SizedBox(height: 8),
          ElevatedButton.icon(
            label: Text("Logout"),
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseMultiFactorAuth.signOut(context: context);
            },
          ),
        ],
      ),
    );
  }
}
