import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/providers/core_providers.dart';
import '../../data/datasources/candidate_remote_datasource.dart';
import '../../data/repositories/candidate_repository_impl.dart';
import '../../domain/entities/candidate_entity.dart';
import '../../domain/repositories/candidate_repository.dart';
import '../../domain/usecases/candidate_usecases.dart';

part 'candidate_providers.g.dart';
part 'candidate_providers.freezed.dart';

// ── DI ────────────────────────────────────────────────────────────────────────

@riverpod
CandidateRemoteDataSource candidateRemoteDataSource(Ref ref) =>
    CandidateRemoteDataSourceImpl(ref.watch(dioClientProvider));

@riverpod
CandidateRepository candidateRepository(Ref ref) =>
    CandidateRepositoryImpl(ref.watch(candidateRemoteDataSourceProvider));

@riverpod
GetCandidatesUseCase getCandidates(Ref ref) =>
    GetCandidatesUseCase(ref.watch(candidateRepositoryProvider));

@riverpod
GetCandidateByIdUseCase getCandidateById(Ref ref) =>
    GetCandidateByIdUseCase(ref.watch(candidateRepositoryProvider));

@riverpod
CreateCandidateUseCase createCandidate(Ref ref) =>
    CreateCandidateUseCase(ref.watch(candidateRepositoryProvider));

@riverpod
UpdateCandidateUseCase updateCandidate(Ref ref) =>
    UpdateCandidateUseCase(ref.watch(candidateRepositoryProvider));

@riverpod
AddNoteUseCase addNote(Ref ref) =>
    AddNoteUseCase(ref.watch(candidateRepositoryProvider));

@riverpod
DeleteNoteUseCase deleteNote(Ref ref) =>
    DeleteNoteUseCase(ref.watch(candidateRepositoryProvider));

@riverpod
AddTagUseCase addTag(Ref ref) =>
    AddTagUseCase(ref.watch(candidateRepositoryProvider));

@riverpod
DeleteCandidateUseCase deleteCandidate(Ref ref) =>
    DeleteCandidateUseCase(ref.watch(candidateRepositoryProvider));

// ── Filter State ──────────────────────────────────────────────────────────────

@freezed
class CandidateFilter with _$CandidateFilter {
  const factory CandidateFilter({
    @Default('') String query,
    String? tag,
    int? minExperience,
    int? maxExperience,
    PipelineStage? stage,
  }) = _CandidateFilter;
}

@riverpod
class CandidateFilterNotifier extends _$CandidateFilterNotifier {
  @override
  CandidateFilter build() => const CandidateFilter();

  void setQuery(String q) => state = state.copyWith(query: q);
  void setTag(String? tag) => state = state.copyWith(tag: tag);
  void setStage(PipelineStage? stage) => state = state.copyWith(stage: stage);
  void setExperience(int? min, int? max) =>
      state = state.copyWith(minExperience: min, maxExperience: max);
  void clearFilters() => state = const CandidateFilter();
}

// ── Candidate List Provider ───────────────────────────────────────────────────

@riverpod
Future<List<CandidateEntity>> candidateList(Ref ref) async {
  final filter = ref.watch(candidateFilterNotifierProvider);
  final useCase = ref.watch(getCandidatesProvider);
  final (list, failure) = await useCase(
    query: filter.query.isEmpty ? null : filter.query,
    tag: filter.tag,
    minExperience: filter.minExperience,
    maxExperience: filter.maxExperience,
    stage: filter.stage,
  );
  if (failure != null) {
    return Future.error(failure, StackTrace.current);
  }
  return list;
}

// ── Single Candidate Provider ─────────────────────────────────────────────────

@riverpod
Future<CandidateEntity> candidateDetail(Ref ref, String id) async {
  final useCase = ref.watch(getCandidateByIdProvider);
  final (candidate, failure) = await useCase(id);
  if (failure != null) {
    return Future.error(failure, StackTrace.current);
  }
  return candidate!;
}

// ── Candidate Form Notifier ───────────────────────────────────────────────────

@freezed
class CandidateFormState with _$CandidateFormState {
  const factory CandidateFormState({
    @Default(false) bool isLoading,
    String? errorMessage,
    CandidateEntity? savedCandidate,
  }) = _CandidateFormState;
}

@riverpod
class CandidateFormNotifier extends _$CandidateFormNotifier {
  @override
  CandidateFormState build() => const CandidateFormState();

  Future<CandidateEntity?> createCandidate({
    required String name,
    required String email,
    String? phone,
    int? experienceYears,
    List<String>? skills,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final useCase = ref.read(createCandidateProvider);
    final (candidate, failure) = await useCase(
      name: name,
      email: email,
      phone: phone,
      experienceYears: experienceYears,
      skills: skills,
    );
    if (failure != null) {
      state = state.copyWith(isLoading: false, errorMessage: failure.message);
      return null;
    }
    state = state.copyWith(isLoading: false, savedCandidate: candidate);
    ref.invalidate(candidateListProvider);
    return candidate;
  }

  Future<CandidateEntity?> updateCandidate({
    required String id,
    String? name,
    String? email,
    String? phone,
    int? experienceYears,
    List<String>? skills,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final useCase = ref.read(updateCandidateProvider);
    final (candidate, failure) = await useCase(
      id: id,
      name: name,
      email: email,
      phone: phone,
      experienceYears: experienceYears,
      skills: skills,
    );
    if (failure != null) {
      state = state.copyWith(isLoading: false, errorMessage: failure.message);
      return null;
    }
    state = state.copyWith(isLoading: false, savedCandidate: candidate);
    ref.invalidate(candidateListProvider);
    ref.invalidate(candidateDetailProvider(id));
    return candidate;
  }

  Future<bool> addNote(String candidateId, String content) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final useCase = ref.read(addNoteProvider);
    final (note, failure) = await useCase(candidateId, content);
    if (failure != null) {
      state = state.copyWith(isLoading: false, errorMessage: failure.message);
      return false;
    }
    state = state.copyWith(isLoading: false);
    ref.invalidate(candidateDetailProvider(candidateId));
    return note != null;
  }

  Future<bool> deleteNote(String candidateId, String noteId) async {
    final useCase = ref.read(deleteNoteProvider);
    final (ok, failure) = await useCase(candidateId, noteId);
    if (failure != null) {
      state = state.copyWith(errorMessage: failure.message);
      return false;
    }
    ref.invalidate(candidateDetailProvider(candidateId));
    return ok;
  }

  void clearError() => state = state.copyWith(errorMessage: null);
}

// Failure message extension (reused from auth)
extension FailureMsg on Failure {
  String get message => when(
        network: (msg, _) => msg,
        unauthorized: (msg) => msg,
        forbidden: (msg) => msg,
        notFound: (msg) => msg,
        validation: (msg, _) => msg,
        server: (msg) => msg,
        cache: (msg) => msg,
        fileValidation: (msg) => msg,
        noInternet: (msg) => msg,
        unknown: (msg) => msg,
      );
}
