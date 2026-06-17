import 'package:hooks_riverpod/hooks_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/providers/core_providers.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/dashboard_usecases.dart';

part 'dashboard_providers.g.dart';

@riverpod
DashboardRemoteDataSource dashboardRemoteDataSource(Ref ref) =>
    DashboardRemoteDataSourceImpl(
      ref.watch(dioClientProvider),
      ref.watch(appConfigStorageProvider),
    );

@riverpod
DashboardRepository dashboardRepository(Ref ref) =>
    DashboardRepositoryImpl(ref.watch(dashboardRemoteDataSourceProvider));

@riverpod
GetDashboardStatsUseCase getDashboardStats(Ref ref) =>
    GetDashboardStatsUseCase(ref.watch(dashboardRepositoryProvider));

@riverpod
GetRecentActivityUseCase getRecentActivity(Ref ref) =>
    GetRecentActivityUseCase(ref.watch(dashboardRepositoryProvider));

// ── Async providers consumed by UI ────────────────────────────────────────────

@riverpod
Future<DashboardStats> dashboardStats(Ref ref) async {
  final useCase = ref.watch(getDashboardStatsProvider);
  final (stats, failure) = await useCase();
  if (failure != null) {
    return Future<DashboardStats>.error(failure, StackTrace.current);
  }
  return stats!;
}

@riverpod
Future<List<RecentActivityItem>> recentActivityFeed(Ref ref) async {
  final useCase = ref.watch(getRecentActivityProvider);
  final (items, failure) = await useCase();
  if (failure != null) {
    return Future<List<RecentActivityItem>>.error(failure, StackTrace.current);
  }
  return items;
}
