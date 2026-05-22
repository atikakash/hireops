import 'package:dio/dio.dart';
import 'package:hireops/core/network/dio_client.dart';
import 'package:hireops/core/network/token_storage.dart';

import '../models/job_models.dart';

class JobRepository {
  final Dio _client = DioClient(tokenStorage: TokenStorage()).client;

  // ── Jobs ──────────────────────────────────────────────────────────────────

  Future<List<JobModel>> listJobs({bool? isOpen, String? search}) async {
    try {
      final response = await _client.get('/api/jobs', queryParameters: {
        if (isOpen != null) 'is_open': isOpen.toString(),
        if (search != null) 'search': search,
      });
      final List data = response.data['data']['jobs'];
      return data.map((j) => JobModel.fromJson(j)).toList();
    } on DioException catch (e) { throw _handleError(e); }
  }

  Future<JobModel> createJob({
    required String title,
    String? department, String? location,
    String type = 'full_time',
    String? description, String? requirements,
    bool isOpen = true,
  }) async {
    try {
      final response = await _client.post('/api/jobs', data: {
        'title': title, 'department': department, 'location': location,
        'type': type, 'description': description,
        'requirements': requirements, 'is_open': isOpen,
      });
      return JobModel.fromJson(response.data['data']['job']);
    } on DioException catch (e) { throw _handleError(e); }
  }

  Future<void> updateJob(int id, {
    required String title,
    String? department, String? location,
    String type = 'full_time',
    String? description, String? requirements,
    bool isOpen = true,
  }) async {
    try {
      await _client.put('/api/jobs/$id', data: {
        'title': title, 'department': department, 'location': location,
        'type': type, 'description': description,
        'requirements': requirements, 'is_open': isOpen,
      });
    } on DioException catch (e) { throw _handleError(e); }
  }

  Future<void> deleteJob(int id) async {
    try {
      await _client.delete('/api/jobs/$id');
    } on DioException catch (e) { throw _handleError(e); }
  }

  // ── Pipeline ─────────────────────────────────────────────────────────────

  Future<List<PipelineStageModel>> getPipeline(int jobId) async {
    try {
      final response = await _client.get('/api/jobs/$jobId/pipeline');
      final List board = response.data['data']['board'];
      return board.map((s) => PipelineStageModel.fromJson(s)).toList();
    } on DioException catch (e) { throw _handleError(e); }
  }

  Future<void> assignCandidate(int jobId, int candidateId, int stageId, {String? notes}) async {
    try {
      await _client.post('/api/jobs/$jobId/candidates', data: {
        'candidate_id': candidateId, 'stage_id': stageId, 'notes': notes,
      });
    } on DioException catch (e) { throw _handleError(e); }
  }

  Future<void> moveStage(int jobId, int candidateId, int stageId, {String? notes}) async {
    try {
      await _client.patch('/api/jobs/$jobId/candidates/$candidateId/stage', data: {
        'stage_id': stageId, 'notes': notes,
      });
    } on DioException catch (e) { throw _handleError(e); }
  }

  Future<void> removeFromPipeline(int jobId, int candidateId) async {
    try {
      await _client.delete('/api/jobs/$jobId/candidates/$candidateId');
    } on DioException catch (e) { throw _handleError(e); }
  }

  JobException _handleError(DioException e) {
    final message = e.response?.data?['message'] ?? 'Something went wrong.';
    return JobException(message: message);
  }
}

class JobException implements Exception {
  final String message;
  const JobException({required this.message});
}
