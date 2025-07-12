import 'package:seagull/src/data/data_sources/local_data_sources/shared_prefrence_keys.dart';

import '../../../../core/service_locator.dart';
import 'flutter_secure_storege_instance.dart';

class AppSecureSharedPreferences {
  static String keyIsSalesLoggedIn = 'keyIsSalesLoggedIn';

  static final storage = getIt<SecureSharedPreInstance>().secureStorage;

  //<---------------------------- Clear Data -------------------------------------//

  static Future<void> clear() async => await storage.deleteAll();

  //<---------------------------- String -------------------------------------//

  static Future<String> getStringData(String key) async => await storage.read(key: key) ?? '';

  static Future<void> setStringData(String key, String value) async => await storage.write(key: key, value: value);

  //<---------------------------- Bool -------------------------------------//

  static Future<bool> getBoolData(String key) async => bool.parse(await storage.read(key: key) ?? 'false');

  static Future<void> setBoolData(String key, bool value) async =>
      await storage.write(key: key, value: value.toString());

  //<---------------------------- Double -------------------------------------//

  static Future<double> getDoubleData(String key) async => double.parse(await storage.read(key: key) ?? '0.0');

  static Future<void> setDoubleData(String key, double value) async =>
      await storage.write(key: key, value: value.toString());

  //<---------------------------- Int -------------------------------------//
  static Future<int> getIntegerData(String key) async => int.parse(await storage.read(key: key) ?? '0');

  static Future<void> setIntegerData(String key, int value) async =>
      await storage.write(key: key, value: value.toString());

  static Future<String> getUserAuthKey() async => await storage.read(key: SharedPreferencesKeys.authorization) ?? '';

  static Future<void> setUserAuthKey(String authkey) async =>
      await storage.write(key: SharedPreferencesKeys.authorization, value: authkey);

  static Future<String> getUserAccessToken() async =>
      await storage.read(key: SharedPreferencesKeys.authorizationToken) ?? '';

  static Future<void> setUserAccessToken(String authkey) async =>
      await storage.write(key: SharedPreferencesKeys.authorizationToken, value: authkey);

  static Future<String> getRefreshAuthKey() async => await storage.read(key: SharedPreferencesKeys.refreshToken) ?? '';

  static Future<void> setRefreshAuthKey(String authkey) async =>
      await storage.write(key: SharedPreferencesKeys.refreshToken, value: authkey);
}
