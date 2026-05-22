import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Domain-level failures returned from repositories.
@freezed
class Failure with _$Failure {
  const factory Failure.network({
    required String message,
    int? statusCode,
  }) = NetworkFailure;

  const factory Failure.unauthorized({
    @Default('Session expired. Please log in again.') String message,
  }) = UnauthorizedFailure;

  const factory Failure.forbidden({
    @Default('You do not have permission to perform this action.')
    String message,
  }) = ForbiddenFailure;

  const factory Failure.notFound({
    @Default('The requested resource was not found.') String message,
  }) = NotFoundFailure;

  const factory Failure.validation({
    required String message,
    Map<String, List<String>>? fieldErrors,
  }) = ValidationFailure;

  const factory Failure.server({
    @Default('An unexpected server error occurred.') String message,
  }) = ServerFailure;

  const factory Failure.cache({
    @Default('Local cache error.') String message,
  }) = CacheFailure;

  const factory Failure.fileValidation({
    required String message,
  }) = FileValidationFailure;

  const factory Failure.noInternet({
    @Default('No internet connection. Please check your network.')
    String message,
  }) = NoInternetFailure;

  const factory Failure.unknown({
    @Default('An unknown error occurred.') String message,
  }) = UnknownFailure;
}

/// Exceptions thrown in the data layer (converted to Failures by repos).
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? data;

  const AppException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'AppException($statusCode): $message';
}

class UnauthorizedException extends AppException {
  const UnauthorizedException()
      : super(message: 'Unauthorized', statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException() : super(message: 'Forbidden', statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException() : super(message: 'Not Found', statusCode: 404);
}

class ServerException extends AppException {
  const ServerException({super.message = 'Internal Server Error'})
      : super(statusCode: 500);
}

class NoInternetException extends AppException {
  const NoInternetException({
    super.message = 'No internet connection',
  });
}

class FileValidationException extends AppException {
  const FileValidationException({required super.message});
}
