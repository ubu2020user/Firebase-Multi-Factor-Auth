import 'package:firebase_multi_factor_auth/firebase_multi_factor_auth.dart';
import 'package:firebase_multi_factor_auth/models/multi_factor_auth_type.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        direction: Axis.vertical,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(height: 64),
          ElevatedButton.icon(
            label: Text("Login Google"),
            icon: Icon(Icons.g_mobiledata_outlined),
            onPressed: () {
              FirebaseMultiFactorAuth.loginFirstProvider(
                  context: context, authType: MultiFactorAuthType.GOOGLE);
            },
          ),
          SizedBox(height: 8),
          ElevatedButton.icon(
            label: Text("Login Apple"),
            icon: Icon(Icons.apple_outlined),
            onPressed: null,
          ),
          ElevatedButton.icon(
            label: Text("Login GitHub"),
            icon: Icon(Icons.cloud_circle_rounded),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
