import 'package:hireops/core/errors/app_exception_utils.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/candidates/data/datasources/candidate_remote_datasource.dart';
import 'package:hireops/features/candidates/data/models/candidate_model.dart';
import 'package:hireops/features/candidates/domain/entities/candidate_entity.dart';
import 'package:hireops/features/candidates/domain/repositories/candidate_repository.dart';

class CandidateRepositoryImpl implements CandidateRepository {
  final CandidateRemoteDataSource _ds;
  const CandidateRepositoryImpl(this._ds);

  @override
  Future<(List<CandidateEntity>, Failure?)> getCandidates({
    String? query,
    String? tag,
    int? minExperience,
    int? maxExperience,
    PipelineStage? stage,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await _ds.getCandidates(
        query: query,
        tag: tag,
        minExperience: minExperience,
        maxExperience: maxExperience,
        stage: stage,
        page: page,
        limit: limit,
      );
      return (models.map((m) => m.toEntity()).toList(), null);
    } on AppException catch (e) {
      return (<CandidateEntity>[], _map(e));
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (<CandidateEntity>[], _map(appException));
      }
      return (
        <CandidateEntity>[],
        Failure.unknown(message: e.toString()),
      );
    }
  }

  @override
  Future<(CandidateEntity?, Failure?)> getCandidateById(String id) async {
    try {
      final model = await _ds.getCandidateById(id);
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
  Future<(CandidateEntity?, Failure?)> createCandidate({
    required String name,
    required String email,
    String? phone,
    int? experienceYears,
    List<String>? skills,
  }) async {
    try {
      final model = await _ds.createCandidate({
        'name': name,
        'email': email,
        if (phone != null) 'phone': phone,
        if (experienceYears != null) 'experienceYears': experienceYears,
        if (skills != null) 'skills': skills,
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
  Future<(CandidateEntity?, Failure?)> updateCandidate({
    required String id,
    String? name,
    String? email,
    String? phone,
    int? experienceYears,
    List<String>? skills,
  }) async {
    try {
      final model = await _ds.updateCandidate(id, {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (experienceYears != null) 'experienceYears': experienceYears,
        if (skills != null) 'skills': skills,
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
  Future<(bool, Failure?)> addTag(String candidateId, String tag) async {
    try {
      await _ds.addTag(candidateId, tag);
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
  Future<(bool, Failure?)> removeTag(String candidateId, String tag) async {
    try {
      await _ds.removeTag(candidateId, tag);
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
  Future<(CandidateNote?, Failure?)> addNote(
      String candidateId, String content) async {
    try {
      final model = await _ds.addNote(candidateId, content);
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
  Future<(bool, Failure?)> deleteNote(String candidateId, String noteId) async {
    try {
      await _ds.deleteNote(candidateId, noteId);
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
  Future<(bool, Failure?)> deleteCandidate(String id) async {
    try {
      await _ds.deleteCandidate(id);
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
