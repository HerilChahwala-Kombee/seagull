import 'package:dartz/dartz.dart';

import '../network/models/api_error.dart';

abstract class UseCase<T, P> {
  Future<Either<ApiError, T>> call(P reqParams);
}
