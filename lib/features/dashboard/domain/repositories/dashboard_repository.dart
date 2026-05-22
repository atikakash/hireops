import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/dashboard/domain/entities/dashboard_entity.dart';

abstract interface class DashboardRepository {
  Future<(DashboardStats?, Failure?)> getStats();
  Future<(List<RecentActivityItem>, Failure?)> getRecentActivity();
}
