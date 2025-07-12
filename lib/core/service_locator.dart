import 'package:get_it/get_it.dart';
import 'package:seagull/core/api_config.dart';
import 'package:seagull/core/env_config.dart';
import 'package:seagull/core/network/dio_client.dart';
import 'package:seagull/src/data/data_sources/local_data_sources/flutter_secure_storege_instance.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator({ApiConfig? config, DioClient? dioClient}) async {
  // await setupNetworkModule();

  final apiConfig = config ?? ApiConfig(baseUrl: EnvConfig.baseUrl);
  getIt.registerLazySingleton<ApiConfig>(() => apiConfig);
  final dio = dioClient ?? await DioClient.create(apiConfig);
  getIt
    ..registerLazySingleton<DioClient>(() => dio)
    // ..registerLazySingleton<NavigationService>(() => NavigationService())
    ..registerLazySingleton<SecureSharedPreInstance>(() => SecureSharedPreInstance());
  // ..registerLazySingleton<TransactionDataSource>(() => TransactionDataSourceImpl())
  // ..registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(getIt()))
  // ..registerLazySingleton(() => TransactionUseCase(getIt()));
}
