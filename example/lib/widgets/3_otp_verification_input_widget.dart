import 'package:firebase_multi_factor_auth/firebase_multi_factor_auth.dart';
import 'package:firebase_multi_factor_auth/provider/auth_provider.dart';
import 'package:firebase_multi_factor_auth/provider/user_provider.dart';
import 'package:firebase_multi_factor_auth/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OTPVerificationWidget extends StatefulWidget {
  const OTPVerificationWidget({Key? key}) : super(key: key);

  @override
  _OTPVerificationWidgetState createState() => _OTPVerificationWidgetState();
}

class _OTPVerificationWidgetState extends State<OTPVerificationWidget> {
  final _otpController = TextEditingController();
  var isLoading = false;

  Future<Function?> verifyOtpInput() async {
    setLoading(true);
    if (_otpController.text.length > 6 ||
        _otpController.text.isEmpty ||
        !_otpController.text.contains(RegExp("[0-9]"))) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid OTP")));
      setLoading(false);
      return null;
    }
    _otpController.text = _otpController.text.replaceAll(" ", "").trim();
    await FirebaseMultiFactorAuth.inputPhoneOTP(
            context: this.context, otpCode: _otpController.text)
        .then(
      (isSuccessful) {
        if (!isSuccessful) {
          setLoading(false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (FirebaseMultiFactorAuth.isPhoneNumberInputed(context: context)) {
      if (userProvider.userFetched != null &&
          (userProvider.userFetched!.uidProviderFirst !=
                  userProvider.userLocal.uidProviderFirst ||
              userProvider.userLocal.phoneNumber !=
                  userProvider.userFetched!.phoneNumber)) {
        logger.d(
            "Not match ${userProvider.userFetched!.uidProviderFirst} != ${userProvider.userLocal.uidProviderFirst}");
        logger.d(
            "Not match ${userProvider.userFetched!.phoneNumber} != ${userProvider.userLocal.phoneNumber}");
        return Scaffold(
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please contact the support. Your login method and your phone number did not match.",
                  textAlign: TextAlign.center,
                ),
                OutlinedButton(
                    onPressed: () async =>
                        FirebaseMultiFactorAuth.signOut(context: context),
                    child: Text("Change Provider")),
              ],
            ),
          ),
        );
      }
    }
    //}

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Spacer(),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _otpController,
            autofocus: true,
            cursorColor: Theme.of(context).colorScheme.primary,
            maxLength: 6,
            onFieldSubmitted: (value) async {
              await verifyOtpInput();
            },
            // inputFormatters: [],
            decoration: const InputDecoration(
              icon: Icon(Icons.sms),
              labelText: "Enter OTP",
              //labelStyle: TextStyle(color: Color(0xFF6200EE))
              helperText:
                  "OTP has been send per sms.", // TOdo translation & better text
              enabledBorder: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextButton(
            onPressed: () async {
              await verifyOtpInput();
            },
            child: const Text("VERIFY"),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
