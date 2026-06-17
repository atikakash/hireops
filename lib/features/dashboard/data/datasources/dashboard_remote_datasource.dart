import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hireops/core/constants/api_constants.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/core/network/app_config_storage.dart';
import 'package:hireops/core/network/dio_client.dart';
import 'package:hireops/features/dashboard/data/models/dashboard_model.dart';

abstract interface class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getStats();
  Future<List<RecentActivityModel>> getRecentActivity();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  static const _dashboardTimeout = Duration(seconds: 90);

  final DioClient _dioClient;
  final AppConfigStorage _cache;

  const DashboardRemoteDataSourceImpl(this._dioClient, this._cache);

  Dio get _dio => _dioClient.client;

  @override
  Future<DashboardStatsModel> getStats() async {
    try {
      final response = await _dio
          .get(
            ApiConstants.dashboardStats,
            options: Options(
              connectTimeout: _dashboardTimeout,
              receiveTimeout: _dashboardTimeout,
            ),
          )
          .timeout(_dashboardTimeout, onTimeout: _dashboardTimeoutError);
      final stats = _extractStatsMap(response.data);
      await _cache.saveDashboardStats(jsonEncode(stats));
      return DashboardStatsModel.fromJson(stats);
    } on Object catch (err) {
      if (_isAuthFailure(err)) {
        rethrow;
      }

      final cached = await _cachedStats();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<List<RecentActivityModel>> getRecentActivity() async {
    try {
      final response = await _dio
          .get(
            ApiConstants.recentActivity,
            options: Options(
              connectTimeout: _dashboardTimeout,
              receiveTimeout: _dashboardTimeout,
            ),
          )
          .timeout(_dashboardTimeout, onTimeout: _dashboardTimeoutError);
      final activities = _extractActivityList(response.data);
      await _cache.saveDashboardActivity(jsonEncode(activities));
      return activities.map(RecentActivityModel.fromJson).toList();
    } on Object catch (err) {
      if (_isAuthFailure(err)) {
        rethrow;
      }

      final cached = await _cachedActivity();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  Never _dashboardTimeoutError() {
    throw const AppException(
      message: 'The dashboard took too long to load. Please try again.',
    );
  }

  Map<String, dynamic> _extractStatsMap(dynamic response) {
    final payload = _asMap(response);
    final data = payload['data'];

    if (data is Map<String, dynamic>) {
      final stats = data['stats'];
      if (stats is Map<String, dynamic>) {
        return _normalizeStats(stats);
      }
      return _normalizeStats(data);
    }

    if (payload['stats'] is Map<String, dynamic>) {
      return _normalizeStats(payload['stats'] as Map<String, dynamic>);
    }

    return _normalizeStats(payload);
  }

  List<Map<String, dynamic>> _extractActivityList(dynamic response) {
    final payload = _asMap(response);
    final data = payload['data'];

    if (data is List) {
      return data.map(_asMap).toList();
    }

    if (data is Map<String, dynamic>) {
      final activities = data['activities'] ?? data['recentActivity'];
      if (activities is List) {
        return activities.map(_asMap).toList();
      }
    }

    if (payload['recentActivity'] is List) {
      return (payload['recentActivity'] as List).map(_asMap).toList();
    }

    if (response is List) {
      return response.map(_asMap).toList();
    }

    return const [];
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

  Map<String, dynamic> _normalizeStats(Map<String, dynamic> stats) {
    final normalized = Map<String, dynamic>.from(stats);

    for (final key in [
      'totalCandidates',
      'activeJobs',
      'totalHired',
      'totalRejected',
    ]) {
      normalized[key] = _asInt(normalized[key]);
    }

    final candidatesPerStage = normalized['candidatesPerStage'];
    if (candidatesPerStage is Map) {
      normalized['candidatesPerStage'] = candidatesPerStage.map(
        (key, value) => MapEntry(key.toString(), _asInt(value)),
      );
    }

    return normalized;
  }

  int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Future<DashboardStatsModel?> _cachedStats() async {
    try {
      final raw = await _cache.getDashboardStats();
      if (raw == null || raw.isEmpty) {
        return null;
      }

      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return DashboardStatsModel.fromJson(_normalizeStats(decoded));
      }
      if (decoded is Map) {
        return DashboardStatsModel.fromJson(
          _normalizeStats(decoded.map((key, value) => MapEntry('$key', value))),
        );
      }
    } on Object {
      return null;
    }

    return null;
  }

  Future<List<RecentActivityModel>?> _cachedActivity() async {
    try {
      final raw = await _cache.getDashboardActivity();
      if (raw == null || raw.isEmpty) {
        return null;
      }

      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map(_asMap).map(RecentActivityModel.fromJson).toList();
      }
    } on Object {
      return null;
    }

    return null;
  }

  bool _isAuthFailure(Object err) {
    if (err is AppException) {
      return err.statusCode == 401 || err.statusCode == 403;
    }

    if (err is DioException) {
      final status = err.response?.statusCode;
      if (status == 401 || status == 403) {
        return true;
      }

      final mapped = err.error;
      return mapped is AppException &&
          (mapped.statusCode == 401 || mapped.statusCode == 403);
    }

    return false;
  }
}
