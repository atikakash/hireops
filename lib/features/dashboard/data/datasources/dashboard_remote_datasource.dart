import 'package:dio/dio.dart';
import 'package:hireops/core/constants/api_constants.dart';
import 'package:hireops/core/network/dio_client.dart';
import 'package:hireops/features/dashboard/data/models/dashboard_model.dart';

abstract interface class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getStats();
  Future<List<RecentActivityModel>> getRecentActivity();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DioClient _dioClient;

  const DashboardRemoteDataSourceImpl(this._dioClient);

  Dio get _dio => _dioClient.client;

  @override
  Future<DashboardStatsModel> getStats() async {
    final response = await _dio.get(ApiConstants.dashboardStats);
    return DashboardStatsModel.fromJson(_extractStatsMap(response.data));
  }

  @override
  Future<List<RecentActivityModel>> getRecentActivity() async {
    final response = await _dio.get(ApiConstants.recentActivity);
    return _extractActivityList(response.data)
        .map(RecentActivityModel.fromJson)
        .toList();
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
}
