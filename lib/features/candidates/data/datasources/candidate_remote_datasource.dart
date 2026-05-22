import 'package:dio/dio.dart';
import 'package:hireops/core/constants/api_constants.dart';
import 'package:hireops/core/network/dio_client.dart';
import 'package:hireops/features/candidates/data/models/candidate_model.dart';
import 'package:hireops/features/candidates/domain/entities/candidate_entity.dart';

abstract interface class CandidateRemoteDataSource {
  Future<List<CandidateModel>> getCandidates({
    String? query,
    String? tag,
    int? minExperience,
    int? maxExperience,
    PipelineStage? stage,
    int page,
    int limit,
  });

  Future<CandidateModel> getCandidateById(String id);
  Future<CandidateModel> createCandidate(Map<String, dynamic> data);
  Future<CandidateModel> updateCandidate(String id, Map<String, dynamic> data);
  Future<void> addTag(String candidateId, String tag);
  Future<void> removeTag(String candidateId, String tag);
  Future<NoteModel> addNote(String candidateId, String content);
  Future<void> deleteNote(String candidateId, String noteId);
  Future<void> deleteCandidate(String id);
}

class CandidateRemoteDataSourceImpl implements CandidateRemoteDataSource {
  final DioClient _dioClient;

  const CandidateRemoteDataSourceImpl(this._dioClient);

  Dio get _dio => _dioClient.client;

  @override
  Future<List<CandidateModel>> getCandidates({
    String? query,
    String? tag,
    int? minExperience,
    int? maxExperience,
    PipelineStage? stage,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      ApiConstants.candidates,
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        if (tag != null) 'tag': tag,
        if (minExperience != null) 'minExp': minExperience,
        if (maxExperience != null) 'maxExp': maxExperience,
        if (stage != null) 'stage': stage.name,
        'page': page,
        'limit': limit,
      },
    );

    return _extractCandidateList(response.data)
        .map(CandidateModel.fromJson)
        .toList();
  }

  @override
  Future<CandidateModel> getCandidateById(String id) async {
    final response = await _dio.get(ApiConstants.candidate(id));
    return CandidateModel.fromJson(_extractCandidateMap(response.data));
  }

  @override
  Future<CandidateModel> createCandidate(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.candidates, data: data);
    return CandidateModel.fromJson(_extractCandidateMap(response.data));
  }

  @override
  Future<CandidateModel> updateCandidate(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put(ApiConstants.candidate(id), data: data);
    return CandidateModel.fromJson(_extractCandidateMap(response.data));
  }

  @override
  Future<void> addTag(String candidateId, String tag) async {
    await _dio.post(
      ApiConstants.candidateTags(candidateId),
      data: {'tag': tag},
    );
  }

  @override
  Future<void> removeTag(String candidateId, String tag) async {
    await _dio.delete(
      ApiConstants.candidateTags(candidateId),
      data: {'tag': tag},
    );
  }

  @override
  Future<NoteModel> addNote(String candidateId, String content) async {
    final response = await _dio.post(
      ApiConstants.candidateNotes(candidateId),
      data: {'content': content},
    );
    return NoteModel.fromJson(_extractNoteMap(response.data));
  }

  @override
  Future<void> deleteNote(String candidateId, String noteId) async {
    await _dio.delete(ApiConstants.candidateNote(candidateId, noteId));
  }

  @override
  Future<void> deleteCandidate(String id) async {
    await _dio.delete(ApiConstants.candidate(id));
  }

  List<Map<String, dynamic>> _extractCandidateList(dynamic response) {
    final payload = _asMap(response);
    final data = payload['data'];

    if (data is List) {
      return data.map(_asMap).toList();
    }

    if (data is Map<String, dynamic>) {
      final candidates = data['candidates'] ?? data['items'];
      if (candidates is List) {
        return candidates.map(_asMap).toList();
      }
    }

    if (payload['candidates'] is List) {
      return (payload['candidates'] as List).map(_asMap).toList();
    }

    if (response is List) {
      return response.map(_asMap).toList();
    }

    return const [];
  }

  Map<String, dynamic> _extractCandidateMap(dynamic response) {
    final payload = _asMap(response);
    final data = payload['data'];

    if (data is Map<String, dynamic>) {
      final candidate = data['candidate'];
      if (candidate is Map<String, dynamic>) {
        return candidate;
      }
      return data;
    }

    if (payload['candidate'] is Map<String, dynamic>) {
      return payload['candidate'] as Map<String, dynamic>;
    }

    return payload;
  }

  Map<String, dynamic> _extractNoteMap(dynamic response) {
    final payload = _asMap(response);
    final data = payload['data'];

    if (data is Map<String, dynamic>) {
      final note = data['note'];
      if (note is Map<String, dynamic>) {
        return note;
      }
      return data;
    }

    if (payload['note'] is Map<String, dynamic>) {
      return payload['note'] as Map<String, dynamic>;
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
