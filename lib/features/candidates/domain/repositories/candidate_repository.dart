import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/candidates/domain/entities/candidate_entity.dart';

abstract interface class CandidateRepository {
  Future<(List<CandidateEntity>, Failure?)> getCandidates({
    String? query,
    String? tag,
    int? minExperience,
    int? maxExperience,
    PipelineStage? stage,
    int page,
    int limit,
  });

  Future<(CandidateEntity?, Failure?)> getCandidateById(String id);

  Future<(CandidateEntity?, Failure?)> createCandidate({
    required String name,
    required String email,
    String? phone,
    int? experienceYears,
    List<String>? skills,
  });

  Future<(CandidateEntity?, Failure?)> updateCandidate({
    required String id,
    String? name,
    String? email,
    String? phone,
    int? experienceYears,
    List<String>? skills,
  });

  Future<(bool, Failure?)> addTag(String candidateId, String tag);
  Future<(bool, Failure?)> removeTag(String candidateId, String tag);

  Future<(CandidateNote?, Failure?)> addNote(
      String candidateId, String content);
  Future<(bool, Failure?)> deleteNote(String candidateId, String noteId);

  Future<(bool, Failure?)> deleteCandidate(String id);
}
