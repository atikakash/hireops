// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candidate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CandidateModelImpl _$$CandidateModelImplFromJson(Map<String, dynamic> json) =>
    _$CandidateModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 0,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      notes: (json['notes'] as List<dynamic>?)
              ?.map((e) => NoteModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      stageHistory: (json['stageHistory'] as List<dynamic>?)
              ?.map(
                  (e) => StageHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentStage: json['currentStage'] as String? ?? 'applied',
      cvUrl: json['cvUrl'] as String?,
      cvId: json['cvId'] as String?,
      jobId: json['jobId'] as String?,
      jobTitle: json['jobTitle'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$CandidateModelImplToJson(
        _$CandidateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'experienceYears': instance.experienceYears,
      'skills': instance.skills,
      'tags': instance.tags,
      'notes': instance.notes,
      'stageHistory': instance.stageHistory,
      'currentStage': instance.currentStage,
      'cvUrl': instance.cvUrl,
      'cvId': instance.cvId,
      'jobId': instance.jobId,
      'jobTitle': instance.jobTitle,
      'avatarUrl': instance.avatarUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$NoteModelImpl _$$NoteModelImplFromJson(Map<String, dynamic> json) =>
    _$NoteModelImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      authorName: json['authorName'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$NoteModelImplToJson(_$NoteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'authorName': instance.authorName,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$StageHistoryModelImpl _$$StageHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StageHistoryModelImpl(
      id: json['id'] as String,
      stage: json['stage'] as String,
      movedByName: json['movedByName'] as String,
      movedAt: json['movedAt'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$StageHistoryModelImplToJson(
        _$StageHistoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stage': instance.stage,
      'movedByName': instance.movedByName,
      'movedAt': instance.movedAt,
      'note': instance.note,
    };
