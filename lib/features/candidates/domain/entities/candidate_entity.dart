import 'package:freezed_annotation/freezed_annotation.dart';

part 'candidate_entity.freezed.dart';

enum PipelineStage { applied, shortlisted, interview, hired, rejected }

@freezed
class CandidateEntity with _$CandidateEntity {
  const factory CandidateEntity({
    required String id,
    required String name,
    required String email,
    String? phone,
    @Default(0) int experienceYears,
    @Default([]) List<String> skills,
    @Default([]) List<String> tags,
    @Default([]) List<CandidateNote> notes,
    @Default([]) List<StageHistoryEntry> stageHistory,
    required PipelineStage currentStage,
    String? cvUrl,
    String? cvId,
    String? jobId,
    String? jobTitle,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CandidateEntity;
}

@freezed
class CandidateNote with _$CandidateNote {
  const factory CandidateNote({
    required String id,
    required String content,
    required String authorName,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _CandidateNote;
}

@freezed
class StageHistoryEntry with _$StageHistoryEntry {
  const factory StageHistoryEntry({
    required String id,
    required PipelineStage stage,
    required String movedByName,
    required DateTime movedAt,
    String? note,
  }) = _StageHistoryEntry;
}
