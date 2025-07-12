

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureSharedPreInstance{
  FlutterSecureStorage secureStorage = const FlutterSecureStorage(aOptions:  AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding),);
}