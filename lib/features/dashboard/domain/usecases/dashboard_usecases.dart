import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:hireops/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardStatsUseCase {
  final DashboardRepository _repo;
  const GetDashboardStatsUseCase(this._repo);
  Future<(DashboardStats?, Failure?)> call() => _repo.getStats();
}

class GetRecentActivityUseCase {
  final DashboardRepository _repo;
  const GetRecentActivityUseCase(this._repo);
  Future<(List<RecentActivityItem>, Failure?)> call() =>
      _repo.getRecentActivity();
}
