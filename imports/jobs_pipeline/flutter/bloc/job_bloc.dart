import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/job_models.dart';
import '../repositories/job_repository.dart';

// ── Events ────────────────────────────────────────────────────────────────────
abstract class JobEvent extends Equatable {
  const JobEvent();

  @override List<Object?> get props => [];
}

class JobsLoadRequested extends JobEvent {
  final bool? isOpen; final String? search;
  const JobsLoadRequested({this.isOpen, this.search});
  @override List<Object?> get props => [isOpen, search];
}

class JobCreateSubmitted extends JobEvent {
  final String title, type;
  final String? department, location, description, requirements;
  final bool isOpen;
  const JobCreateSubmitted({
    required this.title, this.department, this.location,
    this.type = 'full_time', this.description, this.requirements,
    this.isOpen = true,
  });
  @override List<Object?> get props => [title];
}

class JobDeleteRequested extends JobEvent {
  final int jobId;
  const JobDeleteRequested(this.jobId);
  @override List<Object?> get props => [jobId];
}

class PipelineLoadRequested extends JobEvent {
  final int jobId;
  const PipelineLoadRequested(this.jobId);
  @override List<Object?> get props => [jobId];
}

class CandidateAssignRequested extends JobEvent {
  final int jobId, candidateId, stageId;
  final String? notes;
  const CandidateAssignRequested({
    required this.jobId, required this.candidateId,
    required this.stageId, this.notes,
  });
  @override List<Object?> get props => [jobId, candidateId, stageId];
}

class CandidateStageMoveRequested extends JobEvent {
  final int jobId, candidateId, stageId;
  final String? notes;
  const CandidateStageMoveRequested({
    required this.jobId, required this.candidateId,
    required this.stageId, this.notes,
  });
  @override List<Object?> get props => [jobId, candidateId, stageId];
}

// ── States ────────────────────────────────────────────────────────────────────
abstract class JobState extends Equatable {
  const JobState();

  @override List<Object?> get props => [];
}

class JobInitial extends JobState {
  const JobInitial();
}

class JobLoading extends JobState {
  const JobLoading();
}

class JobsLoaded extends JobState {
  final List<JobModel> jobs;
  const JobsLoaded(this.jobs);
  @override List<Object?> get props => [jobs];
}

class PipelineLoaded extends JobState {
  final int jobId;
  final List<PipelineStageModel> board;
  const PipelineLoaded({required this.jobId, required this.board});
  @override List<Object?> get props => [jobId, board];
}

class JobActionSuccess extends JobState {
  final String message;
  final List<JobModel>? jobs;
  final List<PipelineStageModel>? board;
  const JobActionSuccess({required this.message, this.jobs, this.board});
  @override List<Object?> get props => [message];
}

class JobError extends JobState {
  final String message;
  const JobError(this.message);
  @override List<Object?> get props => [message];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────
class JobBloc extends Bloc<JobEvent, JobState> {
  final _repo = JobRepository();

  JobBloc() : super(const JobInitial()) {
    on<JobsLoadRequested>(_onLoadJobs);
    on<JobCreateSubmitted>(_onCreateJob);
    on<JobDeleteRequested>(_onDeleteJob);
    on<PipelineLoadRequested>(_onLoadPipeline);
    on<CandidateAssignRequested>(_onAssign);
    on<CandidateStageMoveRequested>(_onMoveStage);
  }

  Future<void> _onLoadJobs(JobsLoadRequested event, Emitter<JobState> emit) async {
    emit(const JobLoading());
    try {
      final jobs = await _repo.listJobs(isOpen: event.isOpen, search: event.search);
      emit(JobsLoaded(jobs));
    } on JobException catch (e) {
      emit(JobError(e.message));
    } on Object {
      emit(const JobError('Failed to load jobs.'));
    }
  }

  Future<void> _onCreateJob(JobCreateSubmitted event, Emitter<JobState> emit) async {
    emit(const JobLoading());
    try {
      await _repo.createJob(
        title: event.title, department: event.department,
        location: event.location, type: event.type,
        description: event.description, requirements: event.requirements,
        isOpen: event.isOpen,
      );
      final jobs = await _repo.listJobs();
      emit(JobActionSuccess(message: 'Job created successfully!', jobs: jobs));
    } on JobException catch (e) {
      emit(JobError(e.message));
    }
  }

  Future<void> _onDeleteJob(JobDeleteRequested event, Emitter<JobState> emit) async {
    try {
      await _repo.deleteJob(event.jobId);
      final current = state is JobsLoaded ? (state as JobsLoaded).jobs : <JobModel>[];
      final updated = current.where((j) => j.id != event.jobId).toList();
      emit(JobActionSuccess(message: 'Job deleted.', jobs: updated));
    } on JobException catch (e) {
      emit(JobError(e.message));
    }
  }

  Future<void> _onLoadPipeline(PipelineLoadRequested event, Emitter<JobState> emit) async {
    emit(const JobLoading());
    try {
      final board = await _repo.getPipeline(event.jobId);
      emit(PipelineLoaded(jobId: event.jobId, board: board));
    } on JobException catch (e) {
      emit(JobError(e.message));
    }
  }

  Future<void> _onAssign(CandidateAssignRequested event, Emitter<JobState> emit) async {
    try {
      await _repo.assignCandidate(event.jobId, event.candidateId, event.stageId, notes: event.notes);
      final board = await _repo.getPipeline(event.jobId);
      emit(JobActionSuccess(message: 'Candidate added to pipeline!', board: board));
    } on JobException catch (e) {
      emit(JobError(e.message));
    }
  }

  Future<void> _onMoveStage(CandidateStageMoveRequested event, Emitter<JobState> emit) async {
    try {
      await _repo.moveStage(event.jobId, event.candidateId, event.stageId, notes: event.notes);
      final board = await _repo.getPipeline(event.jobId);
      emit(JobActionSuccess(message: 'Candidate moved!', board: board));
    } on JobException catch (e) {
      emit(JobError(e.message));
    }
  }
}
