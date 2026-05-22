// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$jobRemoteDataSourceHash() =>
    r'399bf3c376a9cc8de85243a27994d27740ce2b13';

/// See also [jobRemoteDataSource].
@ProviderFor(jobRemoteDataSource)
final jobRemoteDataSourceProvider =
    AutoDisposeProvider<JobRemoteDataSource>.internal(
  jobRemoteDataSource,
  name: r'jobRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$jobRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobRemoteDataSourceRef = AutoDisposeProviderRef<JobRemoteDataSource>;
String _$jobRepositoryHash() => r'3381b12ac0b6b25a522db33f8314ea69a9cb189a';

/// See also [jobRepository].
@ProviderFor(jobRepository)
final jobRepositoryProvider = AutoDisposeProvider<JobRepository>.internal(
  jobRepository,
  name: r'jobRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$jobRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobRepositoryRef = AutoDisposeProviderRef<JobRepository>;
String _$getJobsHash() => r'e8c60f0e40a11f761bad6c2d36cba989c48d43fd';

/// See also [getJobs].
@ProviderFor(getJobs)
final getJobsProvider = AutoDisposeProvider<GetJobsUseCase>.internal(
  getJobs,
  name: r'getJobsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getJobsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetJobsRef = AutoDisposeProviderRef<GetJobsUseCase>;
String _$getJobByIdHash() => r'01a0135bca4151857b31b5b1424e7cf4d8b956f4';

/// See also [getJobById].
@ProviderFor(getJobById)
final getJobByIdProvider = AutoDisposeProvider<GetJobByIdUseCase>.internal(
  getJobById,
  name: r'getJobByIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getJobByIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetJobByIdRef = AutoDisposeProviderRef<GetJobByIdUseCase>;
String _$createJobHash() => r'cb3f614cc5a6c709a047dd490972fde325cb36cd';

/// See also [createJob].
@ProviderFor(createJob)
final createJobProvider = AutoDisposeProvider<CreateJobUseCase>.internal(
  createJob,
  name: r'createJobProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$createJobHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateJobRef = AutoDisposeProviderRef<CreateJobUseCase>;
String _$updateJobHash() => r'edd1d4de00adde98412fc4efa82a4b9306a049b7';

/// See also [updateJob].
@ProviderFor(updateJob)
final updateJobProvider = AutoDisposeProvider<UpdateJobUseCase>.internal(
  updateJob,
  name: r'updateJobProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$updateJobHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateJobRef = AutoDisposeProviderRef<UpdateJobUseCase>;
String _$toggleJobStatusHash() => r'e8d32f2ec243db32ea8663c5f9720fd55150a752';

/// See also [toggleJobStatus].
@ProviderFor(toggleJobStatus)
final toggleJobStatusProvider =
    AutoDisposeProvider<ToggleJobStatusUseCase>.internal(
  toggleJobStatus,
  name: r'toggleJobStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$toggleJobStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ToggleJobStatusRef = AutoDisposeProviderRef<ToggleJobStatusUseCase>;
String _$assignCandidateHash() => r'9aca646fca0317bd081c354373bb846a3fac1220';

/// See also [assignCandidate].
@ProviderFor(assignCandidate)
final assignCandidateProvider =
    AutoDisposeProvider<AssignCandidateUseCase>.internal(
  assignCandidate,
  name: r'assignCandidateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$assignCandidateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssignCandidateRef = AutoDisposeProviderRef<AssignCandidateUseCase>;
String _$jobListHash() => r'3e845b48c42807c366eb0a26382ffd50e8b0e6ad';

/// See also [jobList].
@ProviderFor(jobList)
final jobListProvider = AutoDisposeFutureProvider<List<JobEntity>>.internal(
  jobList,
  name: r'jobListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$jobListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobListRef = AutoDisposeFutureProviderRef<List<JobEntity>>;
String _$jobDetailHash() => r'c1c274e1f1ab6b2f228a83122fdf202f42815141';

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

/// See also [jobDetail].
@ProviderFor(jobDetail)
const jobDetailProvider = JobDetailFamily();

/// See also [jobDetail].
class JobDetailFamily extends Family<AsyncValue<JobEntity>> {
  /// See also [jobDetail].
  const JobDetailFamily();

  /// See also [jobDetail].
  JobDetailProvider call(
    String id,
  ) {
    return JobDetailProvider(
      id,
    );
  }

  @override
  JobDetailProvider getProviderOverride(
    covariant JobDetailProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'jobDetailProvider';
}

/// See also [jobDetail].
class JobDetailProvider extends AutoDisposeFutureProvider<JobEntity> {
  /// See also [jobDetail].
  JobDetailProvider(
    String id,
  ) : this._internal(
          (ref) => jobDetail(
            ref as JobDetailRef,
            id,
          ),
          from: jobDetailProvider,
          name: r'jobDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$jobDetailHash,
          dependencies: JobDetailFamily._dependencies,
          allTransitiveDependencies: JobDetailFamily._allTransitiveDependencies,
          id: id,
        );

  JobDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<JobEntity> Function(JobDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobDetailProvider._internal(
        (ref) => create(ref as JobDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<JobEntity> createElement() {
    return _JobDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JobDetailRef on AutoDisposeFutureProviderRef<JobEntity> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JobDetailProviderElement
    extends AutoDisposeFutureProviderElement<JobEntity> with JobDetailRef {
  _JobDetailProviderElement(super.provider);

  @override
  String get id => (origin as JobDetailProvider).id;
}

String _$jobFormNotifierHash() => r'fdd002597c6a9e280ba45c8935998ddfa9cd6c68';

/// See also [JobFormNotifier].
@ProviderFor(JobFormNotifier)
final jobFormNotifierProvider =
    AutoDisposeNotifierProvider<JobFormNotifier, JobFormState>.internal(
  JobFormNotifier.new,
  name: r'jobFormNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$jobFormNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JobFormNotifier = AutoDisposeNotifier<JobFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
