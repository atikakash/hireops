import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/providers/core_providers.dart';
import '../../data/models/job_model.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/repositories/job_repository.dart';
import '../../domain/usecases/job_usecases.dart';

part 'job_providers.g.dart';
part 'job_providers.freezed.dart';

@riverpod
JobRemoteDataSource jobRemoteDataSource(Ref ref) =>
    JobRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
JobRepository jobRepository(Ref ref) =>
    JobRepositoryImpl(ref.watch(jobRemoteDataSourceProvider));

@riverpod
GetJobsUseCase getJobs(Ref ref) =>
    GetJobsUseCase(ref.watch(jobRepositoryProvider));

@riverpod
GetJobByIdUseCase getJobById(Ref ref) =>
    GetJobByIdUseCase(ref.watch(jobRepositoryProvider));

@riverpod
CreateJobUseCase createJob(Ref ref) =>
    CreateJobUseCase(ref.watch(jobRepositoryProvider));

@riverpod
UpdateJobUseCase updateJob(Ref ref) =>
    UpdateJobUseCase(ref.watch(jobRepositoryProvider));

@riverpod
ToggleJobStatusUseCase toggleJobStatus(Ref ref) =>
    ToggleJobStatusUseCase(ref.watch(jobRepositoryProvider));

@riverpod
AssignCandidateUseCase assignCandidate(Ref ref) =>
    AssignCandidateUseCase(ref.watch(jobRepositoryProvider));

// ── Async providers ───────────────────────────────────────────────────────────

@riverpod
Future<List<JobEntity>> jobList(Ref ref) async {
  final (jobs, failure) = await ref.watch(getJobsProvider).call();
  if (failure != null) {
    return Future.error(failure, StackTrace.current);
  }
  return jobs;
}

@riverpod
Future<JobEntity> jobDetail(Ref ref, String id) async {
  final (job, failure) = await ref.watch(getJobByIdProvider).call(id);
  if (failure != null) {
    return Future.error(failure, StackTrace.current);
  }
  return job!;
}

// ── Form Notifier ─────────────────────────────────────────────────────────────

@freezed
class JobFormState with _$JobFormState {
  const factory JobFormState({
    @Default(false) bool isLoading,
    String? errorMessage,
    JobEntity? savedJob,
  }) = _JobFormState;
}

@riverpod
class JobFormNotifier extends _$JobFormNotifier {
  @override
  JobFormState build() => const JobFormState();

  Future<JobEntity?> create({
    required String title,
    required String department,
    required String description,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final (job, failure) = await ref.read(createJobProvider).call(
          title: title,
          department: department,
          description: description,
        );
    if (failure != null) {
      state = state.copyWith(isLoading: false, errorMessage: failure.message);
      return null;
    }
    state = state.copyWith(isLoading: false, savedJob: job);
    ref.invalidate(jobListProvider);
    return job;
  }

  Future<JobEntity?> update({
    required String id,
    String? title,
    String? department,
    String? description,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final (job, failure) = await ref.read(updateJobProvider).call(
          id: id,
          title: title,
          department: department,
          description: description,
        );
    if (failure != null) {
      state = state.copyWith(isLoading: false, errorMessage: failure.message);
      return null;
    }
    state = state.copyWith(isLoading: false, savedJob: job);
    ref.invalidate(jobListProvider);
    ref.invalidate(jobDetailProvider(id));
    return job;
  }

  Future<bool> toggleStatus(String id) async {
    state = state.copyWith(isLoading: true);
    final (ok, failure) = await ref.read(toggleJobStatusProvider).call(id);
    state = state.copyWith(isLoading: false);
    if (failure != null) {
      state = state.copyWith(errorMessage: failure.message);
      return false;
    }
    ref.invalidate(jobListProvider);
    ref.invalidate(jobDetailProvider(id));
    return ok;
  }

  Future<bool> assignCandidate(String jobId, String candidateId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final (ok, failure) =
        await ref.read(assignCandidateProvider).call(jobId, candidateId);
    state = state.copyWith(isLoading: false);

    if (failure != null) {
      state = state.copyWith(errorMessage: failure.message);
      return false;
    }

    ref.invalidate(jobListProvider);
    ref.invalidate(jobDetailProvider(jobId));
    return ok;
  }

  void clearError() => state = state.copyWith(errorMessage: null);
}

extension FailureMsgJob on Failure {
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
