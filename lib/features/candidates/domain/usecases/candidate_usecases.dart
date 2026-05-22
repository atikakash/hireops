import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/candidates/domain/entities/candidate_entity.dart';
import 'package:hireops/features/candidates/domain/repositories/candidate_repository.dart';

class GetCandidatesUseCase {
  final CandidateRepository _repo;
  const GetCandidatesUseCase(this._repo);

  Future<(List<CandidateEntity>, Failure?)> call({
    String? query,
    String? tag,
    int? minExperience,
    int? maxExperience,
    PipelineStage? stage,
    int page = 1,
    int limit = 20,
  }) =>
      _repo.getCandidates(
        query: query,
        tag: tag,
        minExperience: minExperience,
        maxExperience: maxExperience,
        stage: stage,
        page: page,
        limit: limit,
      );
}

class GetCandidateByIdUseCase {
  final CandidateRepository _repo;
  const GetCandidateByIdUseCase(this._repo);

  Future<(CandidateEntity?, Failure?)> call(String id) =>
      _repo.getCandidateById(id);
}

class CreateCandidateUseCase {
  final CandidateRepository _repo;
  const CreateCandidateUseCase(this._repo);

  Future<(CandidateEntity?, Failure?)> call({
    required String name,
    required String email,
    String? phone,
    int? experienceYears,
    List<String>? skills,
  }) =>
      _repo.createCandidate(
        name: name,
        email: email,
        phone: phone,
        experienceYears: experienceYears,
        skills: skills,
      );
}

class UpdateCandidateUseCase {
  final CandidateRepository _repo;
  const UpdateCandidateUseCase(this._repo);

  Future<(CandidateEntity?, Failure?)> call({
    required String id,
    String? name,
    String? email,
    String? phone,
    int? experienceYears,
    List<String>? skills,
  }) =>
      _repo.updateCandidate(
        id: id,
        name: name,
        email: email,
        phone: phone,
        experienceYears: experienceYears,
        skills: skills,
      );
}

class AddNoteUseCase {
  final CandidateRepository _repo;
  const AddNoteUseCase(this._repo);

  Future<(CandidateNote?, Failure?)> call(String candidateId, String content) =>
      _repo.addNote(candidateId, content);
}

class DeleteNoteUseCase {
  final CandidateRepository _repo;
  const DeleteNoteUseCase(this._repo);

  Future<(bool, Failure?)> call(String candidateId, String noteId) =>
      _repo.deleteNote(candidateId, noteId);
}

class AddTagUseCase {
  final CandidateRepository _repo;
  const AddTagUseCase(this._repo);

  Future<(bool, Failure?)> call(String candidateId, String tag) =>
      _repo.addTag(candidateId, tag);
}

class DeleteCandidateUseCase {
  final CandidateRepository _repo;
  const DeleteCandidateUseCase(this._repo);

  Future<(bool, Failure?)> call(String id) => _repo.deleteCandidate(id);
}
