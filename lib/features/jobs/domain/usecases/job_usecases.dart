import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/jobs/domain/entities/job_entity.dart';
import 'package:hireops/features/jobs/domain/repositories/job_repository.dart';

class GetJobsUseCase {
  final JobRepository _repo;
  const GetJobsUseCase(this._repo);
  Future<(List<JobEntity>, Failure?)> call({JobStatus? status}) =>
      _repo.getJobs(status: status);
}

class GetJobByIdUseCase {
  final JobRepository _repo;
  const GetJobByIdUseCase(this._repo);
  Future<(JobEntity?, Failure?)> call(String id) => _repo.getJobById(id);
}

class CreateJobUseCase {
  final JobRepository _repo;
  const CreateJobUseCase(this._repo);
  Future<(JobEntity?, Failure?)> call({
    required String title,
    required String department,
    required String description,
  }) =>
      _repo.createJob(
          title: title, department: department, description: description);
}

class UpdateJobUseCase {
  final JobRepository _repo;
  const UpdateJobUseCase(this._repo);
  Future<(JobEntity?, Failure?)> call({
    required String id,
    String? title,
    String? department,
    String? description,
  }) =>
      _repo.updateJob(
          id: id,
          title: title,
          department: department,
          description: description);
}

class ToggleJobStatusUseCase {
  final JobRepository _repo;
  const ToggleJobStatusUseCase(this._repo);
  Future<(bool, Failure?)> call(String id) => _repo.toggleJobStatus(id);
}

class AssignCandidateUseCase {
  final JobRepository _repo;
  const AssignCandidateUseCase(this._repo);
  Future<(bool, Failure?)> call(String jobId, String candidateId) =>
      _repo.assignCandidate(jobId, candidateId);
}
