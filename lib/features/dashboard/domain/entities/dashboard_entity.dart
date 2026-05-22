import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_entity.freezed.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required int totalCandidates,
    required int activeJobs,
    required int totalHired,
    required int totalRejected,
    required Map<String, int> candidatesPerStage,
    required List<RecentActivityItem> recentActivity,
  }) = _DashboardStats;
}

@freezed
class RecentActivityItem with _$RecentActivityItem {
  const factory RecentActivityItem({
    required String id,
    required String action,
    required String actorName,
    String? targetName,
    required DateTime createdAt,
    required ActivityType type,
  }) = _RecentActivityItem;
}

enum ActivityType {
  cvUploaded,
  stageMoved,
  noteAdded,
  jobAssigned,
  candidateAdded,
  jobCreated,
}
