import 'package:equatable/equatable.dart';
import 'package:seagull/core/env_config.dart';
import 'package:seagull/core/network_constants.dart';

class ApiConfig extends Equatable {
  final String baseUrl;
  final Environment environment;
  final Duration connectTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;
  final Map<String, String> defaultHeaders;
  final bool enableLogging;
  final bool enableCaching;
  final Duration cacheMaxAge;

  const ApiConfig({
    required this.baseUrl,
    this.environment = Environment.uat,
    this.connectTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 60),
    this.defaultHeaders = const {
      NetworkConstants.contentTypeHeader: NetworkConstants.jsonContentType,
      NetworkConstants.acceptHeader: NetworkConstants.jsonContentType,
      //add as per your requirement
      // 'Device-Identifier': uniqueKey,
      // 'User-Agent': _ua,
      // 'X-localization': _appLanguage.isEmpty ? 'en' : _appLanguage,
    },
    this.enableLogging = true,
    this.enableCaching = true,
    this.cacheMaxAge = const Duration(minutes: 5),
  });

  @override
  List<Object?> get props => [
    baseUrl,
    environment,
    connectTimeout,
    sendTimeout,
    receiveTimeout,
    defaultHeaders,
    enableLogging,
    enableCaching,
    cacheMaxAge,
  ];
}
