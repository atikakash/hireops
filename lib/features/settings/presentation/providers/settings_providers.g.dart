// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsRemoteDataSourceHash() =>
    r'514cd76c8b13ad6e6bbd73101b2ed136e2640d69';

/// See also [settingsRemoteDataSource].
@ProviderFor(settingsRemoteDataSource)
final settingsRemoteDataSourceProvider =
    AutoDisposeProvider<SettingsRemoteDataSource>.internal(
  settingsRemoteDataSource,
  name: r'settingsRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsRemoteDataSourceRef
    = AutoDisposeProviderRef<SettingsRemoteDataSource>;
String _$companyProfileNotifierHash() =>
    r'f7ad225ac1cadb07e00f5f100cc02a32a206f586';

/// See also [CompanyProfileNotifier].
@ProviderFor(CompanyProfileNotifier)
final companyProfileNotifierProvider = AutoDisposeNotifierProvider<
    CompanyProfileNotifier, CompanyProfileState>.internal(
  CompanyProfileNotifier.new,
  name: r'companyProfileNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$companyProfileNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CompanyProfileNotifier = AutoDisposeNotifier<CompanyProfileState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
