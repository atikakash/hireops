// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardRemoteDataSourceHash() =>
    r'cdb8d4a8f55d748c57e1ca3d3e32c87957045856';

/// See also [dashboardRemoteDataSource].
@ProviderFor(dashboardRemoteDataSource)
final dashboardRemoteDataSourceProvider =
    AutoDisposeProvider<DashboardRemoteDataSource>.internal(
  dashboardRemoteDataSource,
  name: r'dashboardRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardRemoteDataSourceRef
    = AutoDisposeProviderRef<DashboardRemoteDataSource>;
String _$dashboardRepositoryHash() =>
    r'7b8de6e77090b445fd69facc27796ecb670a7ec1';

/// See also [dashboardRepository].
@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider =
    AutoDisposeProvider<DashboardRepository>.internal(
  dashboardRepository,
  name: r'dashboardRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardRepositoryRef = AutoDisposeProviderRef<DashboardRepository>;
String _$getDashboardStatsHash() => r'ebb482253187ba3a1dbd1aae56c0890b4baa9ae6';

/// See also [getDashboardStats].
@ProviderFor(getDashboardStats)
final getDashboardStatsProvider =
    AutoDisposeProvider<GetDashboardStatsUseCase>.internal(
  getDashboardStats,
  name: r'getDashboardStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getDashboardStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetDashboardStatsRef = AutoDisposeProviderRef<GetDashboardStatsUseCase>;
String _$getRecentActivityHash() => r'8dd6ca4dccc6c1a8793470e38dc435bb5f2b5d05';

/// See also [getRecentActivity].
@ProviderFor(getRecentActivity)
final getRecentActivityProvider =
    AutoDisposeProvider<GetRecentActivityUseCase>.internal(
  getRecentActivity,
  name: r'getRecentActivityProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getRecentActivityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetRecentActivityRef = AutoDisposeProviderRef<GetRecentActivityUseCase>;
String _$dashboardStatsHash() => r'2621814823707b8ad2b33a2988a7bee4f2c5968b';

/// See also [dashboardStats].
@ProviderFor(dashboardStats)
final dashboardStatsProvider =
    AutoDisposeFutureProvider<DashboardStats>.internal(
  dashboardStats,
  name: r'dashboardStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardStatsRef = AutoDisposeFutureProviderRef<DashboardStats>;
String _$recentActivityFeedHash() =>
    r'54f8101bfb998ca2656dee5a5d585954ea8d2210';

/// See also [recentActivityFeed].
@ProviderFor(recentActivityFeed)
final recentActivityFeedProvider =
    AutoDisposeFutureProvider<List<RecentActivityItem>>.internal(
  recentActivityFeed,
  name: r'recentActivityFeedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentActivityFeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentActivityFeedRef
    = AutoDisposeFutureProviderRef<List<RecentActivityItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
