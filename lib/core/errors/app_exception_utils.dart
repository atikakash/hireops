import 'package:dio/dio.dart';

import 'failures.dart';

AppException? extractAppException(Object error) {
  if (error is AppException) {
    return error;
  }

  if (error is DioException && error.error is AppException) {
    return error.error as AppException;
  }

  return null;
}
