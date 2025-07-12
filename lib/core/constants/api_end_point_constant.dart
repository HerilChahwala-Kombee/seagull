class APIEndPoint {
  APIEndPoint._();

  static const int timeOut = 30000;

  // static String baseURL = 'https://mcsfa.mcssurat.com:8090/MCSCAMobile';
  static String baseURL = 'http://103.206.139.106:8090/MCSCAApi';

  // static String deviceTokenUrl = '${baseURL}api/User/DeviceToken';
  static String refreshTokenUrl = '${baseURL}api/User/Refresh';

  /// TODO: Change This Url
  static String getApiCloudSignIn = 'http://portal-api.mcssurat.com/api/mcsfa-cloud-validate';
  static String getApiAccountSignIn = '$baseURL/rest/web/login';
  static String getTransaction = '$baseURL/account-book/closing-balance/:companyCode/:companyYear';
}
