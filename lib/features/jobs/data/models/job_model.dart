import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hireops/core/constants/api_constants.dart';
import 'package:hireops/core/errors/app_exception_utils.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/core/network/dio_client.dart';
import 'package:hireops/features/jobs/domain/entities/job_entity.dart';
import 'package:hireops/features/jobs/domain/repositories/job_repository.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

@freezed
class JobModel with _$JobModel {
  const factory JobModel({
    required String id,
    required String title,
    required String department,
    required String description,
    @Default('open') String status,
    required String openDate,
    @Default(0) int candidateCount,
    @Default([]) List<String> assignedCandidateIds,
    String? closedDate,
    String? createdAt,
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);
}

extension JobModelMapper on JobModel {
  JobEntity toEntity() => JobEntity(
        id: id,
        title: title,
        department: department,
        description: description,
        status: status == 'open' ? JobStatus.open : JobStatus.closed,
        openDate: DateTime.tryParse(openDate) ?? DateTime.now(),
        candidateCount: candidateCount,
        assignedCandidateIds: assignedCandidateIds,
        closedDate: closedDate != null ? DateTime.tryParse(closedDate!) : null,
        createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      );
}

// â”€â”€ Remote Datasource â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class JobRemoteDataSource {
  final DioClient _client;
  const JobRemoteDataSource(this._client);
  Dio get _dio => _client.client;

  Future<List<JobModel>> getJobs({String? status}) async {
    final res = await _dio.get(
      ApiConstants.jobs,
      queryParameters: {if (status != null) 'status': status},
    );
    return _extractJobList(res.data).map(JobModel.fromJson).toList();
  }

  Future<JobModel> getJobById(String id) async {
    final res = await _dio.get(ApiConstants.job(id));
    return JobModel.fromJson(_extractJobMap(res.data));
  }

  Future<JobModel> createJob(Map<String, dynamic> data) async {
    final res = await _dio.post(ApiConstants.jobs, data: data);
    return JobModel.fromJson(_extractJobMap(res.data));
  }

  Future<JobModel> updateJob(String id, Map<String, dynamic> data) async {
    final res = await _dio.put(ApiConstants.job(id), data: data);
    return JobModel.fromJson(_extractJobMap(res.data));
  }

  Future<void> toggleStatus(String id) async =>
      _dio.post(ApiConstants.jobToggle(id));

  Future<void> assignCandidate(String jobId, String candidateId) async => _dio
      .post(ApiConstants.jobAssign(jobId), data: {'candidateId': candidateId});

  List<Map<String, dynamic>> _extractJobList(dynamic response) {
    final payload = _asMap(response);
    final data = payload['data'];

    if (data is List) {
      return data.map(_asMap).toList();
    }

    if (data is Map<String, dynamic>) {
      final jobs = data['jobs'] ?? data['items'];
      if (jobs is List) {
        return jobs.map(_asMap).toList();
      }
    }

    if (payload['jobs'] is List) {
      return (payload['jobs'] as List).map(_asMap).toList();
    }

    if (response is List) {
      return response.map(_asMap).toList();
    }

    return const [];
  }

  Map<String, dynamic> _extractJobMap(dynamic response) {
    final payload = _asMap(response);
    final data = payload['data'];

    if (data is Map<String, dynamic>) {
      final job = data['job'];
      if (job is Map<String, dynamic>) {
        return job;
      }
      return data;
    }

    if (payload['job'] is Map<String, dynamic>) {
      return payload['job'] as Map<String, dynamic>;
    }

    return payload;
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

// â”€â”€ Repository Implementation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource _ds;
  const JobRepositoryImpl(this._ds);

  @override
  Future<(List<JobEntity>, Failure?)> getJobs({JobStatus? status}) async {
    try {
      final models = await _ds.getJobs(status: status?.name);
      return (models.map((m) => m.toEntity()).toList(), null);
    } on AppException catch (e) {
      return (<JobEntity>[], _map(e));
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (<JobEntity>[], _map(appException));
      }
      return (<JobEntity>[], Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<(JobEntity?, Failure?)> getJobById(String id) async {
    try {
      final model = await _ds.getJobById(id);
      return (model.toEntity(), null);
    } on AppException catch (e) {
      return (null, _map(e));
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (null, _map(appException));
      }
      return (null, Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<(JobEntity?, Failure?)> createJob({
    required String title,
    required String department,
    required String description,
  }) async {
    try {
      final model = await _ds.createJob({
        'title': title,
        'department': department,
        'description': description,
      });
      return (model.toEntity(), null);
    } on AppException catch (e) {
      return (null, _map(e));
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (null, _map(appException));
      }
      return (null, Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<(JobEntity?, Failure?)> updateJob({
    required String id,
    String? title,
    String? department,
    String? description,
  }) async {
    try {
      final model = await _ds.updateJob(id, {
        if (title != null) 'title': title,
        if (department != null) 'department': department,
        if (description != null) 'description': description,
      });
      return (model.toEntity(), null);
    } on AppException catch (e) {
      return (null, _map(e));
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (null, _map(appException));
      }
      return (null, Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<(bool, Failure?)> toggleJobStatus(String id) async {
    try {
      await _ds.toggleStatus(id);
      return (true, null);
    } on AppException catch (e) {
      return (false, _map(e));
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (false, _map(appException));
      }
      return (false, Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<(bool, Failure?)> assignCandidate(
      String jobId, String candidateId) async {
    try {
      await _ds.assignCandidate(jobId, candidateId);
      return (true, null);
    } on AppException catch (e) {
      return (false, _map(e));
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (false, _map(appException));
      }
      return (false, Failure.unknown(message: e.toString()));
    }
  }

  Failure _map(AppException e) => switch (e.statusCode) {
        401 => const Failure.unauthorized(),
        403 => const Failure.forbidden(),
        404 => const Failure.notFound(),
        _ => e is NoInternetException
            ? Failure.noInternet(message: e.message)
            : Failure.network(message: e.message),
      };
}
