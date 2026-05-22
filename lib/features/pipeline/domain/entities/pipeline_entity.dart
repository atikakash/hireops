import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/candidates/domain/entities/candidate_entity.dart';

part 'pipeline_entity.freezed.dart';

@freezed
class PipelineStageConfig with _$PipelineStageConfig {
  const factory PipelineStageConfig({
    required String id,
    required String name,
    required PipelineStage stage,
    required int order,
    @Default([]) List<CandidateEntity> candidates,
  }) = _PipelineStageConfig;
}

abstract interface class PipelineRepository {
  Future<(List<PipelineStageConfig>, Failure?)> getBoard();
  Future<(bool, Failure?)> moveCandidate(
      String candidateId, PipelineStage toStage);
  Future<(bool, Failure?)> renameStage(String stageId, String newName);
}
