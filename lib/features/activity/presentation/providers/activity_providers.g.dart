// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityRemoteDataSourceHash() =>
    r'8e668ffa4563815eeb93b4f5367601efd21cf675';

/// See also [activityRemoteDataSource].
@ProviderFor(activityRemoteDataSource)
final activityRemoteDataSourceProvider =
    AutoDisposeProvider<ActivityRemoteDataSource>.internal(
  activityRemoteDataSource,
  name: r'activityRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activityRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivityRemoteDataSourceRef
    = AutoDisposeProviderRef<ActivityRemoteDataSource>;
String _$activityLogHash() => r'9cbce0be431cad102c282cc761f60ad5bf42f64a';

/// See also [activityLog].
@ProviderFor(activityLog)
final activityLogProvider =
    AutoDisposeFutureProvider<List<RecentActivityItem>>.internal(
  activityLog,
  name: r'activityLogProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activityLogHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivityLogRef = AutoDisposeFutureProviderRef<List<RecentActivityItem>>;
String _$candidateActivityLogHash() =>
    r'c9eb1f514a222fb989fbac81eb9a99ec82b5c8b7';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [candidateActivityLog].
@ProviderFor(candidateActivityLog)
const candidateActivityLogProvider = CandidateActivityLogFamily();

/// See also [candidateActivityLog].
class CandidateActivityLogFamily
    extends Family<AsyncValue<List<RecentActivityItem>>> {
  /// See also [candidateActivityLog].
  const CandidateActivityLogFamily();

  /// See also [candidateActivityLog].
  CandidateActivityLogProvider call(
    String candidateId,
  ) {
    return CandidateActivityLogProvider(
      candidateId,
    );
  }

  @override
  CandidateActivityLogProvider getProviderOverride(
    covariant CandidateActivityLogProvider provider,
  ) {
    return call(
      provider.candidateId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'candidateActivityLogProvider';
}

/// See also [candidateActivityLog].
class CandidateActivityLogProvider
    extends AutoDisposeFutureProvider<List<RecentActivityItem>> {
  /// See also [candidateActivityLog].
  CandidateActivityLogProvider(
    String candidateId,
  ) : this._internal(
          (ref) => candidateActivityLog(
            ref as CandidateActivityLogRef,
            candidateId,
          ),
          from: candidateActivityLogProvider,
          name: r'candidateActivityLogProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$candidateActivityLogHash,
          dependencies: CandidateActivityLogFamily._dependencies,
          allTransitiveDependencies:
              CandidateActivityLogFamily._allTransitiveDependencies,
          candidateId: candidateId,
        );

  CandidateActivityLogProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.candidateId,
  }) : super.internal();

  final String candidateId;

  @override
  Override overrideWith(
    FutureOr<List<RecentActivityItem>> Function(
            CandidateActivityLogRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CandidateActivityLogProvider._internal(
        (ref) => create(ref as CandidateActivityLogRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        candidateId: candidateId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RecentActivityItem>> createElement() {
    return _CandidateActivityLogProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CandidateActivityLogProvider &&
        other.candidateId == candidateId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, candidateId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CandidateActivityLogRef
    on AutoDisposeFutureProviderRef<List<RecentActivityItem>> {
  /// The parameter `candidateId` of this provider.
  String get candidateId;
}

class _CandidateActivityLogProviderElement
    extends AutoDisposeFutureProviderElement<List<RecentActivityItem>>
    with CandidateActivityLogRef {
  _CandidateActivityLogProviderElement(super.provider);

  @override
  String get candidateId =>
      (origin as CandidateActivityLogProvider).candidateId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
