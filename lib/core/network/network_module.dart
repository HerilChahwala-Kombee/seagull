// import 'package:get_it/get_it.dart';
// import 'package:mcs_accounting_flutter_web/core/api_config.dart';
// import 'package:mcs_accounting_flutter_web/core/env_config.dart';
// import 'package:mcs_accounting_flutter_web/feature/data/data_source/remote/dashboard/dashboard_data_source.dart';
// import 'package:mcs_accounting_flutter_web/feature/data/data_source/remote/dashboard/dashboard_data_source_impl.dart';
// import 'package:mcs_accounting_flutter_web/feature/data/data_source/remote/transaction/transaction_data_source.dart';
// import 'package:mcs_accounting_flutter_web/feature/data/data_source/remote/transaction/transaction_data_source_impl.dart';
// import 'dio_client.dart';
//
// final getIt = GetIt.instance;
//
// /// Sets up the network module and registers dependencies for DI.
// /// Note: This is now async and must be awaited.
// Future<void> setupNetworkModule({
//   ApiConfig? config,
//   DioClient? dioClient,
// }) async {
//   final apiConfig = config ?? ApiConfig(baseUrl: EnvConfig.baseUrl);
//   getIt.registerLazySingleton<ApiConfig>(() => apiConfig);
//   final dio = dioClient ?? await DioClient.create(apiConfig);
//   getIt
//     ..registerLazySingleton<DioClient>(() => dio)
//     ..registerLazySingleton<TransactionDataSource>(() => TransactionDataSourceImpl())
//     ..registerLazySingleton<DashboardDataSource>(() => DashboardDataSourceImpl());
// }
