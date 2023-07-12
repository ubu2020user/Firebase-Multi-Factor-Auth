import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// This allows us to be able to fetch secure values while the app is backgrounded, by specifying first_unlock or first_unlock_this_device. The default if not specified is unlocked.
// Read documentation!

FlutterSecureStorage? _secureStorage;

FlutterSecureStorage get secureStorage {
  if (_secureStorage == null) {
    _secureStorage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }
  return _secureStorage!!;
}

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
      encryptedSharedPreferences: true,
    );

class EncryptionUtils {
  /// Warning!!! Deletes all fucking saved things!
  Future<void> deleteAll() async {
    await secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }
}
