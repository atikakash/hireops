import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hireops/features/dashboard/domain/entities/dashboard_entity.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@freezed
class DashboardStatsModel with _$DashboardStatsModel {
  const factory DashboardStatsModel({
    required int totalCandidates,
    required int activeJobs,
    @Default(0) int totalHired,
    @Default(0) int totalRejected,
    @Default({}) Map<String, int> candidatesPerStage,
    @Default([]) List<RecentActivityModel> recentActivity,
  }) = _DashboardStatsModel;

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);
}

@freezed
class RecentActivityModel with _$RecentActivityModel {
  const factory RecentActivityModel({
    required String id,
    required String action,
    required String actorName,
    String? targetName,
    required String createdAt,
    @Default('candidateAdded') String type,
  }) = _RecentActivityModel;

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) =>
      _$RecentActivityModelFromJson(json);
}

extension DashboardStatsMapper on DashboardStatsModel {
  DashboardStats toEntity() => DashboardStats(
        totalCandidates: totalCandidates,
        activeJobs: activeJobs,
        totalHired: totalHired,
        totalRejected: totalRejected,
        candidatesPerStage: candidatesPerStage,
        recentActivity: recentActivity.map((e) => e.toEntity()).toList(),
      );
}

extension RecentActivityMapper on RecentActivityModel {
  RecentActivityItem toEntity() => RecentActivityItem(
        id: id,
        action: action,
        actorName: actorName,
        targetName: targetName,
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
        type: ActivityType.values.firstWhere(
          (t) => t.name == type,
          orElse: () => ActivityType.candidateAdded,
        ),
      );
}
