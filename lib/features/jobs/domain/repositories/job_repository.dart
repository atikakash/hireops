import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/jobs/domain/entities/job_entity.dart';

abstract interface class JobRepository {
  Future<(List<JobEntity>, Failure?)> getJobs({JobStatus? status});
  Future<(JobEntity?, Failure?)> getJobById(String id);
  Future<(JobEntity?, Failure?)> createJob({
    required String title,
    required String department,
    required String description,
  });
  Future<(JobEntity?, Failure?)> updateJob({
    required String id,
    String? title,
    String? department,
    String? description,
  });
  Future<(bool, Failure?)> toggleJobStatus(String id);
  Future<(bool, Failure?)> assignCandidate(String jobId, String candidateId);
}
