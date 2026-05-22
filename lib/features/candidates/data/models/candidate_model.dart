import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hireops/features/candidates/domain/entities/candidate_entity.dart';

part 'candidate_model.freezed.dart';
part 'candidate_model.g.dart';

@freezed
class CandidateModel with _$CandidateModel {
  const factory CandidateModel({
    required String id,
    required String name,
    required String email,
    String? phone,
    @Default(0) int experienceYears,
    @Default([]) List<String> skills,
    @Default([]) List<String> tags,
    @Default([]) List<NoteModel> notes,
    @Default([]) List<StageHistoryModel> stageHistory,
    @Default('applied') String currentStage,
    String? cvUrl,
    String? cvId,
    String? jobId,
    String? jobTitle,
    String? avatarUrl,
    String? createdAt,
    String? updatedAt,
  }) = _CandidateModel;

  factory CandidateModel.fromJson(Map<String, dynamic> json) =>
      _$CandidateModelFromJson(json);
}

@freezed
class NoteModel with _$NoteModel {
  const factory NoteModel({
    required String id,
    required String content,
    required String authorName,
    required String createdAt,
    String? updatedAt,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}

@freezed
class StageHistoryModel with _$StageHistoryModel {
  const factory StageHistoryModel({
    required String id,
    required String stage,
    required String movedByName,
    required String movedAt,
    String? note,
  }) = _StageHistoryModel;

  factory StageHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$StageHistoryModelFromJson(json);
}

PipelineStage _stageFromString(String s) => PipelineStage.values.firstWhere(
      (e) => e.name == s,
      orElse: () => PipelineStage.applied,
    );

extension CandidateModelMapper on CandidateModel {
  CandidateEntity toEntity() => CandidateEntity(
        id: id,
        name: name,
        email: email,
        phone: phone,
        experienceYears: experienceYears,
        skills: skills,
        tags: tags,
        notes: notes.map((n) => n.toEntity()).toList(),
        stageHistory: stageHistory.map((s) => s.toEntity()).toList(),
        currentStage: _stageFromString(currentStage),
        cvUrl: cvUrl,
        cvId: cvId,
        jobId: jobId,
        jobTitle: jobTitle,
        avatarUrl: avatarUrl,
        createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
        updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      );
}

extension NoteModelMapper on NoteModel {
  CandidateNote toEntity() => CandidateNote(
        id: id,
        content: content,
        authorName: authorName,
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
        updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      );
}

extension StageHistoryMapper on StageHistoryModel {
  StageHistoryEntry toEntity() => StageHistoryEntry(
        id: id,
        stage: _stageFromString(stage),
        movedByName: movedByName,
        movedAt: DateTime.tryParse(movedAt) ?? DateTime.now(),
        note: note,
      );
}
