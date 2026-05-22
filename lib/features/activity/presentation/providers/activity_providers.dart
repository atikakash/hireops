import 'package:dio/dio.dart';
import 'package:hireops/core/constants/api_constants.dart';
import 'package:hireops/core/errors/app_exception_utils.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/core/network/dio_client.dart';
import 'package:hireops/features/dashboard/data/models/dashboard_model.dart';
import 'package:hireops/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:hireops/shared/providers/core_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_providers.g.dart';

class ActivityRemoteDataSource {
  final DioClient _client;

  const ActivityRemoteDataSource(this._client);

  Dio get _dio => _client.client;

  Future<List<RecentActivityModel>> getActivityLog({
    int page = 1,
    int limit = 30,
  }) async {
    final response = await _dio.get(
      ApiConstants.activityLog,
      queryParameters: {'page': page, 'limit': limit},
    );

    return _extractActivityList(response.data)
        .map(RecentActivityModel.fromJson)
        .toList();
  }

  Future<List<RecentActivityModel>> getCandidateActivity(
    String candidateId,
  ) async {
    final response =
        await _dio.get(ApiConstants.candidateActivity(candidateId));
    return _extractActivityList(response.data)
        .map(RecentActivityModel.fromJson)
        .toList();
  }

  List<Map<String, dynamic>> _extractActivityList(dynamic response) {
    final payload = _asMap(response);
    final data = payload['data'];

    if (data is List) {
      return data.map(_asMap).toList();
    }

    if (data is Map<String, dynamic>) {
      final activities = data['activities'] ?? data['items'];
      if (activities is List) {
        return activities.map(_asMap).toList();
      }
    }

    if (payload['activities'] is List) {
      return (payload['activities'] as List).map(_asMap).toList();
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
}

@riverpod
ActivityRemoteDataSource activityRemoteDataSource(Ref ref) =>
    ActivityRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
Future<List<RecentActivityItem>> activityLog(Ref ref) async {
  final dataSource = ref.watch(activityRemoteDataSourceProvider);
  try {
    final models = await dataSource.getActivityLog();
    return models.map((model) => model.toEntity()).toList();
  } on AppException catch (e) {
    return Future.error(
      e is NoInternetException
          ? Failure.noInternet(message: e.message)
          : Failure.network(message: e.message),
      StackTrace.current,
    );
  } on Object catch (e) {
    final appException = extractAppException(e);
    if (appException != null) {
      return Future.error(
        appException is NoInternetException
            ? Failure.noInternet(message: appException.message)
            : Failure.network(message: appException.message),
        StackTrace.current,
      );
    }
    return Future.error(
      Failure.unknown(message: e.toString()),
      StackTrace.current,
    );
  }
}

@riverpod
Future<List<RecentActivityItem>> candidateActivityLog(
  Ref ref,
  String candidateId,
) async {
  final dataSource = ref.watch(activityRemoteDataSourceProvider);
  try {
    final models = await dataSource.getCandidateActivity(candidateId);
    return models.map((model) => model.toEntity()).toList();
  } on AppException catch (e) {
    return Future.error(
      e is NoInternetException
          ? Failure.noInternet(message: e.message)
          : Failure.network(message: e.message),
      StackTrace.current,
    );
  } on Object catch (e) {
    final appException = extractAppException(e);
    if (appException != null) {
      return Future.error(
        appException is NoInternetException
            ? Failure.noInternet(message: appException.message)
            : Failure.network(message: appException.message),
        StackTrace.current,
      );
    }
    return Future.error(
      Failure.unknown(message: e.toString()),
      StackTrace.current,
    );
  }
}
