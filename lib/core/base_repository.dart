import 'package:dartz/dartz.dart';
import 'package:seagull/core/network/models/api_error.dart';

/// Base repository to provide safe API call handling and error mapping.
mixin class BaseRepository {
  // final DioClient dioClient;
  //
  // BaseRepository(this.dioClient);

  /// Wraps an API call and returns Either<ApiError, T> for functional error handling.
  Future<Either<ApiError, T>> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      final result = await apiCall();
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  ApiError _handleError(dynamic error) {
    if (error is ApiError) {
      return error;
    }
    // Handle DioException and other errors
    return ApiError(message: error.toString(), type: ApiErrorType.unknown, originalError: error);
  }
}
