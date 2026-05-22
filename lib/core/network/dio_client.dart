import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';
import '../errors/failures.dart';
import 'token_storage.dart';

/// Singleton Dio client with:
///   • Auth-token injection
///   • Optional 401 → silent token refresh + retry
///   • Friendly AppException mapping
class DioClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;
  final String baseUrl;
  Future<void>? _refreshFuture;

  DioClient({
    required TokenStorage tokenStorage,
    required this.baseUrl,
  }) : _tokenStorage = tokenStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.addAll([
      _authInterceptor(),
      _errorInterceptor(),
      if (kDebugMode) _logInterceptor(),
    ]);
  }

  Dio get client => _dio;

  InterceptorsWrapper _authInterceptor() => InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode != 401) {
            handler.next(error);
            return;
          }

          final refreshToken = await _tokenStorage.getRefreshToken();
          if (refreshToken == null || refreshToken.isEmpty) {
            handler.next(error);
            return;
          }

          try {
            await (_refreshFuture ??= _refreshToken().whenComplete(() {
              _refreshFuture = null;
            }));

            final newToken = await _tokenStorage.getAccessToken();
            if (newToken == null || newToken.isEmpty) {
              handler.next(error);
              return;
            }

            final retryOptions = error.requestOptions.copyWith(
              headers: {
                ...error.requestOptions.headers,
                'Authorization': 'Bearer $newToken',
              },
            );

            final response = await _dio.fetch(retryOptions);
            handler.resolve(response);
          } on Object {
            await _tokenStorage.clearTokens();
            handler.next(error);
          }
        },
      );

  Future<void> _refreshToken() async {
    final refresh = await _tokenStorage.getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      throw Exception('No refresh token');
    }

    final response = await _dio.post(
      ApiConstants.refreshToken,
      data: {'refreshToken': refresh},
      options: Options(headers: {'Authorization': null}),
    );

    final data = response.data as Map<String, dynamic>;
    await _tokenStorage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String? ?? refresh,
    );
  }

  InterceptorsWrapper _errorInterceptor() => InterceptorsWrapper(
        onError: (error, handler) {
          throw _mapDioError(error);
        },
      );

  AppException _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown) {
      return const NoInternetException(
        message:
            'Unable to reach the server. Check the Server URL and your network connection.',
      );
    }

    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const AppException(
        message: 'The server took too long to respond. Please try again.',
      );
    }

    if (e.type == DioExceptionType.cancel) {
      return const AppException(message: 'The request was cancelled.');
    }

    final status = e.response?.statusCode;
    final message = _extractMessage(e.response?.data) ?? e.message ?? 'Error';

    return switch (status) {
      400 => AppException(
          message: message,
          statusCode: 400,
          data: _extractMap(e.response?.data),
        ),
      401 => AppException(
          message: message,
          statusCode: 401,
          data: _extractMap(e.response?.data),
        ),
      403 => AppException(
          message: message,
          statusCode: 403,
          data: _extractMap(e.response?.data),
        ),
      404 => AppException(
          message: message,
          statusCode: 404,
          data: _extractMap(e.response?.data),
        ),
      422 => AppException(
          message: message,
          statusCode: 422,
          data: _extractMap(e.response?.data),
        ),
      500 => AppException(
          message: message,
          statusCode: 500,
          data: _extractMap(e.response?.data),
        ),
      _ => AppException(
          message: message,
          statusCode: status,
          data: _extractMap(e.response?.data),
        ),
    };
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String?;
    }
    return null;
  }

  Map<String, dynamic>? _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }

    return null;
  }

  Interceptor _logInterceptor() => PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      );
}
