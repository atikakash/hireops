// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String? ?? 'system',
      createdAt: json['createdAt'] as String,
      isRead: json['isRead'] as bool? ?? false,
      candidateId: json['candidateId'] as String?,
      jobId: json['jobId'] as String?,
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'type': instance.type,
      'createdAt': instance.createdAt,
      'isRead': instance.isRead,
      'candidateId': instance.candidateId,
      'jobId': instance.jobId,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationRemoteDataSourceHash() =>
    r'7027791ce2d91533c7f19270497cd80c449ea368';

/// See also [notificationRemoteDataSource].
@ProviderFor(notificationRemoteDataSource)
final notificationRemoteDataSourceProvider =
    AutoDisposeProvider<NotificationRemoteDataSource>.internal(
  notificationRemoteDataSource,
  name: r'notificationRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationRemoteDataSourceRef
    = AutoDisposeProviderRef<NotificationRemoteDataSource>;
String _$notificationListHash() => r'0df66f66b0da94baf2e23f9b1e7625e986d4186b';

/// See also [notificationList].
@ProviderFor(notificationList)
final notificationListProvider =
    AutoDisposeFutureProvider<List<NotificationEntity>>.internal(
  notificationList,
  name: r'notificationListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationListRef
    = AutoDisposeFutureProviderRef<List<NotificationEntity>>;
String _$notificationSettingsNotifierHash() =>
    r'6cb1d58a46ca25ed4a19d764e30b8f609fa29797';

/// See also [NotificationSettingsNotifier].
@ProviderFor(NotificationSettingsNotifier)
final notificationSettingsNotifierProvider = AutoDisposeNotifierProvider<
    NotificationSettingsNotifier, NotificationSettings>.internal(
  NotificationSettingsNotifier.new,
  name: r'notificationSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationSettingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationSettingsNotifier
    = AutoDisposeNotifier<NotificationSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
