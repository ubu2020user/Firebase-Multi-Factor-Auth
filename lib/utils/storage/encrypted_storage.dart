import 'package:firebase_multi_factor_auth/utils/storage/storage_keys.dart';

import 'encryption_utils.dart';

class EncryptedStorage {
  Future<void> reset() async {
    await EncryptionUtils().deleteAll();
    await update2FactorAuthenticated(false);
  }

  Future<void> update2FactorAuthenticated(bool isVisible) async {
    await secureStorage.write(
        key: SecureStorageKeys.is2FactorAuthenticated,
        value: isVisible.toString());
  }

  Future<bool> is2FactorAuthenticated() async {
    String? isAuthenticated =
        await secureStorage.read(key: SecureStorageKeys.is2FactorAuthenticated);
    if (isAuthenticated != null && isAuthenticated == "true") {
      return true;
    }
    return false;
  }
}
