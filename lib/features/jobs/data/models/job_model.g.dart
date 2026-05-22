// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobModelImpl _$$JobModelImplFromJson(Map<String, dynamic> json) =>
    _$JobModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      department: json['department'] as String,
      description: json['description'] as String,
      status: json['status'] as String? ?? 'open',
      openDate: json['openDate'] as String,
      candidateCount: (json['candidateCount'] as num?)?.toInt() ?? 0,
      assignedCandidateIds: (json['assignedCandidateIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      closedDate: json['closedDate'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$JobModelImplToJson(_$JobModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'department': instance.department,
      'description': instance.description,
      'status': instance.status,
      'openDate': instance.openDate,
      'candidateCount': instance.candidateCount,
      'assignedCandidateIds': instance.assignedCandidateIds,
      'closedDate': instance.closedDate,
      'createdAt': instance.createdAt,
    };
