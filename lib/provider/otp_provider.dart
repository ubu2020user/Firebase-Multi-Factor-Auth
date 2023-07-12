import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../utils/logger.dart';

/// Missing field check is for checking username, phone and etc.
/// First asking for phone number
/// Then asking for otp code
/// Then missing field check.
enum OTPState { PHONE_INPUT, OTP_SENT, FIRST_LOGIN }

class OTPProvider extends ChangeNotifier {
  OTPState _otpState = OTPState.PHONE_INPUT;

  /* Changes recognized */
  String? phoneNumber;
  ConfirmationResult? confirmationResult;

  bool _disposed = false;

  // mobile
  String? verificationID;

  OTPState get otpState => _otpState;

  set otpState(OTPState state) {
    if (state == _otpState) return;
    _otpState = state;
    notifyListeners();
  }

  /// Sign this provider out and erase its data with this function
  void reset() {
    _disposed = true;

    phoneNumber = null;
    verificationID = null;
    confirmationResult = null;
    otpState = OTPState.PHONE_INPUT;

    _disposed = false;
    logger.i("[OTPProvider] Should be signed out!");
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
