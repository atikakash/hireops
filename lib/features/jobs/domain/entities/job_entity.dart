import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_entity.freezed.dart';

enum JobStatus { open, closed }

@freezed
class JobEntity with _$JobEntity {
  const factory JobEntity({
    required String id,
    required String title,
    required String department,
    required String description,
    required JobStatus status,
    required DateTime openDate,
    @Default(0) int candidateCount,
    @Default([]) List<String> assignedCandidateIds,
    DateTime? closedDate,
    DateTime? createdAt,
  }) = _JobEntity;
}
