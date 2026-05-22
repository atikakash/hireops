// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pipeline_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pipelineRemoteDataSourceHash() =>
    r'5c2bb42d02cc1005221c8506bf943c4a8d10343f';

/// See also [pipelineRemoteDataSource].
@ProviderFor(pipelineRemoteDataSource)
final pipelineRemoteDataSourceProvider =
    AutoDisposeProvider<PipelineRemoteDataSource>.internal(
  pipelineRemoteDataSource,
  name: r'pipelineRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pipelineRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PipelineRemoteDataSourceRef
    = AutoDisposeProviderRef<PipelineRemoteDataSource>;
String _$pipelineRepositoryHash() =>
    r'2a86240df454e9b57e372800b74390eec9302819';

/// See also [pipelineRepository].
@ProviderFor(pipelineRepository)
final pipelineRepositoryProvider =
    AutoDisposeProvider<PipelineRepository>.internal(
  pipelineRepository,
  name: r'pipelineRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pipelineRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PipelineRepositoryRef = AutoDisposeProviderRef<PipelineRepository>;
String _$pipelineBoardHash() => r'828f287d920ec001717465040d4fb6cdfcc79fee';

/// See also [pipelineBoard].
@ProviderFor(pipelineBoard)
final pipelineBoardProvider =
    AutoDisposeFutureProvider<List<PipelineStageConfig>>.internal(
  pipelineBoard,
  name: r'pipelineBoardProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pipelineBoardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PipelineBoardRef
    = AutoDisposeFutureProviderRef<List<PipelineStageConfig>>;
String _$pipelineMoveNotifierHash() =>
    r'd341f0f23c19846bd08b6f290ee6bd5054a4a751';

/// See also [PipelineMoveNotifier].
@ProviderFor(PipelineMoveNotifier)
final pipelineMoveNotifierProvider = AutoDisposeNotifierProvider<
    PipelineMoveNotifier, PipelineMoveState>.internal(
  PipelineMoveNotifier.new,
  name: r'pipelineMoveNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pipelineMoveNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PipelineMoveNotifier = AutoDisposeNotifier<PipelineMoveState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
