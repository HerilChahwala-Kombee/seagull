enum Environment { uat, prod }

class EnvConfig {
  static const Map<Environment, String> baseUrls = {
    Environment.uat: 'http://103.206.139.106:8090/MCSCAApi',
    Environment.prod: 'http://103.206.139.106:8090/MCSCAApi',
  };

  static Environment currentEnv = Environment.uat;

  static String get baseUrl => baseUrls[currentEnv]!;
}
