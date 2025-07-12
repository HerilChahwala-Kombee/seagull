import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:seagull/core/api_config.dart';

/// Interceptor for adding cache support to Dio using the dio_cache_interceptor plugin.
/// Caches GET requests and uses Hive for storage.
class ApiCacheInterceptor extends Interceptor {
  /// Creates and returns a DioCacheInterceptor with default caching options.

  /// [config] - Contains API-related configuration, like cacheMaxAge.
  static DioCacheInterceptor create(ApiConfig config) => DioCacheInterceptor(
    options: CacheOptions(
      // Use Hive as the local cache storage.
      store: MemCacheStore(),

      // Return cache on network errors, except for these status codes.
      hitCacheOnErrorExcept: [401, 403],

      // Maximum duration to keep a cached response.
      maxStale: config.cacheMaxAge,
    ),
  );
}
