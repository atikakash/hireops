// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsModelImpl _$$DashboardStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardStatsModelImpl(
      totalCandidates: (json['totalCandidates'] as num).toInt(),
      activeJobs: (json['activeJobs'] as num).toInt(),
      totalHired: (json['totalHired'] as num?)?.toInt() ?? 0,
      totalRejected: (json['totalRejected'] as num?)?.toInt() ?? 0,
      candidatesPerStage:
          (json['candidatesPerStage'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      recentActivity: (json['recentActivity'] as List<dynamic>?)
              ?.map((e) =>
                  RecentActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DashboardStatsModelImplToJson(
        _$DashboardStatsModelImpl instance) =>
    <String, dynamic>{
      'totalCandidates': instance.totalCandidates,
      'activeJobs': instance.activeJobs,
      'totalHired': instance.totalHired,
      'totalRejected': instance.totalRejected,
      'candidatesPerStage': instance.candidatesPerStage,
      'recentActivity': instance.recentActivity,
    };

_$RecentActivityModelImpl _$$RecentActivityModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecentActivityModelImpl(
      id: json['id'] as String,
      action: json['action'] as String,
      actorName: json['actorName'] as String,
      targetName: json['targetName'] as String?,
      createdAt: json['createdAt'] as String,
      type: json['type'] as String? ?? 'candidateAdded',
    );

Map<String, dynamic> _$$RecentActivityModelImplToJson(
        _$RecentActivityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'actorName': instance.actorName,
      'targetName': instance.targetName,
      'createdAt': instance.createdAt,
      'type': instance.type,
    };
