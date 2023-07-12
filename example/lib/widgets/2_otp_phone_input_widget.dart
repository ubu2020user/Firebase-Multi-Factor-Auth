import 'package:firebase_multi_factor_auth/firebase_multi_factor_auth.dart';
import 'package:flutter/material.dart';

class OTPPhoneWidget extends StatefulWidget {
  const OTPPhoneWidget({Key? key}) : super(key: key);

  @override
  _OTPPhoneWidgetState createState() => _OTPPhoneWidgetState();
}

class _OTPPhoneWidgetState extends State<OTPPhoneWidget> {
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              autofocus: true,
              onFieldSubmitted: (value) {
                if (formKey.currentState!.validate()) {
                  FirebaseMultiFactorAuth.inputPhoneNumberSendOTP(
                      context: context, phoneNumber: phoneController.text);
                }
              },
              decoration: const InputDecoration(
                helperText: "Use the format +49 123 456789 or 0049 123 456789",
                hintText: "+49 123 1234567",
              ),
              validator: (value) => (value != null && value.isNotEmpty)
                  ? null
                  : "Number can't be empty.",
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              child: const Text("SEND"),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  FirebaseMultiFactorAuth.inputPhoneNumberSendOTP(
                      context: context, phoneNumber: phoneController.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
