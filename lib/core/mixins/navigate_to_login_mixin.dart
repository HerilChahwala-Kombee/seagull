import 'package:seagull/src/core/routers/routes.dart';
import 'package:seagull/src/data/data_sources/local_data_sources/app_shared_preference.dart';
import 'package:seagull/src/data/data_sources/local_data_sources/shared_prefrence_keys.dart';

mixin ReDirectToLogin {
  Future<void> navigateToLogin() async {
    AppSecureSharedPreferences.clear();
    AppSecureSharedPreferences.setBoolData(SharedPreferencesKeys.appIntroShown, true);

    /// TODO: Check This whether redirect to Cloud Sign In or Account SIGN In
  }
}
