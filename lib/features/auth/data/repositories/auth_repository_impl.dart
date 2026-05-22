import 'package:dio/dio.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/core/network/token_storage.dart';
import 'package:hireops/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hireops/features/auth/data/models/auth_model.dart';
import 'package:hireops/features/auth/domain/entities/auth_entity.dart';
import 'package:hireops/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final TokenStorage _tokenStorage;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource dataSource,
    required TokenStorage tokenStorage,
  })  : _dataSource = dataSource,
        _tokenStorage = tokenStorage;

  @override
  Future<(AuthEntity?, Failure?)> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _dataSource.login(email: email, password: password);
      await _tokenStorage.saveTokens(
        accessToken: model.accessToken,
        refreshToken: model.refreshToken,
      );
      return (model.toEntity(), null);
    } on AppException catch (e) {
      return (null, _mapException(e));
    } on Object catch (e) {
      return (null, _mapUnexpectedError(e));
    }
  }

  @override
  Future<(AuthRegistrationResult?, Failure?)> register({
    required String name,
    required String email,
    required String password,
    required String companyName,
    String? companyEmail,
  }) async {
    try {
      final response = await _dataSource.register(
        name: name,
        email: email,
        password: password,
        companyName: companyName,
        companyEmail: companyEmail ?? email,
      );

      final data = _asMap(response['data']);
      final requiresVerification = data['requiresEmailVerification'] == true;
      if (requiresVerification) {
        return (
          AuthRegistrationResult(
            requiresEmailVerification: true,
            verificationEmail: data['email']?.toString() ?? email,
            debugOtp: response['debug_otp']?.toString(),
          ),
          null,
        );
      }

      final model = AuthModel.fromApiJson(response);
      await _tokenStorage.saveTokens(
        accessToken: model.accessToken,
        refreshToken: model.refreshToken,
      );
      return (AuthRegistrationResult(auth: model.toEntity()), null);
    } on AppException catch (e) {
      return (null, _mapException(e));
    } on Object catch (e) {
      return (null, _mapUnexpectedError(e));
    }
  }

  @override
  Future<(AuthEntity?, Failure?)> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final model = await _dataSource.verifyEmail(email: email, otp: otp);
      await _tokenStorage.saveTokens(
        accessToken: model.accessToken,
        refreshToken: model.refreshToken,
      );
      return (model.toEntity(), null);
    } on AppException catch (e) {
      return (null, _mapException(e));
    } on Object catch (e) {
      return (null, _mapUnexpectedError(e));
    }
  }

  @override
  Future<(String?, Failure?)> resendVerification(
      {required String email}) async {
    try {
      final response = await _dataSource.resendVerification(email: email);
      final message =
          response['message']?.toString() ?? 'Verification code sent.';
      final debugOtp = response['debug_otp']?.toString();
      return (
        debugOtp == null || debugOtp.isEmpty
            ? message
            : '$message Demo OTP: $debugOtp',
        null,
      );
    } on AppException catch (e) {
      return (null, _mapException(e));
    } on Object catch (e) {
      return (null, _mapUnexpectedError(e));
    }
  }

  @override
  Future<(String?, Failure?)> forgotPassword({required String email}) async {
    try {
      final response = await _dataSource.forgotPassword(email: email);
      return (_buildForgotPasswordMessage(response), null);
    } on AppException catch (e) {
      return (null, _mapException(e));
    } on Object catch (e) {
      return (null, _mapUnexpectedError(e));
    }
  }

  @override
  Future<(String?, Failure?)> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _dataSource.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );

      return (
        response['message'] as String? ?? 'Password reset successfully.',
        null,
      );
    } on AppException catch (e) {
      return (null, _mapException(e));
    } on Object catch (e) {
      return (null, _mapUnexpectedError(e));
    }
  }

  @override
  Future<(bool, Failure?)> logout() async {
    try {
      await _dataSource.logout();
      await _tokenStorage.clearTokens();
      return (true, null);
    } on AppException catch (e) {
      await _tokenStorage.clearTokens();
      return (false, _mapException(e));
    } on Object {
      await _tokenStorage.clearTokens();
      return (true, null);
    }
  }

  Failure _mapException(AppException e) {
    return switch (e.statusCode) {
      400 => Failure.validation(message: e.message),
      401 => Failure.unauthorized(message: e.message),
      403 => Failure.forbidden(message: e.message),
      404 => Failure.notFound(message: e.message),
      422 => Failure.validation(
          message: e.message,
          fieldErrors: _extractFieldErrors(e.data),
        ),
      500 => const Failure.server(),
      _ => e is NoInternetException
          ? Failure.noInternet(message: e.message)
          : Failure.network(message: e.message, statusCode: e.statusCode),
    };
  }

  Failure _mapUnexpectedError(Object error) {
    final appException = _extractAppException(error);
    if (appException != null) {
      return _mapException(appException);
    }

    return Failure.unknown(message: error.toString());
  }

  AppException? _extractAppException(Object error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException && error.error is AppException) {
      return error.error as AppException;
    }

    return null;
  }

  Map<String, List<String>>? _extractFieldErrors(Map<String, dynamic>? data) {
    final rawErrors = data?['errors'];
    if (rawErrors is! Map) {
      return null;
    }

    final parsed = <String, List<String>>{};
    for (final entry in rawErrors.entries) {
      final key = entry.key.toString();
      final value = entry.value;

      if (value is List) {
        parsed[key] = value.map((item) => item.toString()).toList();
      } else if (value != null) {
        parsed[key] = [value.toString()];
      }
    }

    return parsed.isEmpty ? null : parsed;
  }

  String _buildForgotPasswordMessage(Map<String, dynamic> response) {
    final baseMessage = response['message'] as String? ??
        'If that email exists, a reset OTP has been sent.';
    final debugOtp = response['debug_otp']?.toString();

    if (debugOtp == null || debugOtp.isEmpty) {
      return baseMessage;
    }

    return '$baseMessage Demo OTP: $debugOtp';
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }

  return const <String, dynamic>{};
}
