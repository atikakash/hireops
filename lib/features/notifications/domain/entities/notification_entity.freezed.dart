// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotificationEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  String? get candidateId => throw _privateConstructorUsedError;
  String? get jobId => throw _privateConstructorUsedError;

  /// Create a copy of NotificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationEntityCopyWith<NotificationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationEntityCopyWith<$Res> {
  factory $NotificationEntityCopyWith(
          NotificationEntity value, $Res Function(NotificationEntity) then) =
      _$NotificationEntityCopyWithImpl<$Res, NotificationEntity>;
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      NotificationType type,
      DateTime createdAt,
      bool isRead,
      String? candidateId,
      String? jobId});
}

/// @nodoc
class _$NotificationEntityCopyWithImpl<$Res, $Val extends NotificationEntity>
    implements $NotificationEntityCopyWith<$Res> {
  _$NotificationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? createdAt = null,
    Object? isRead = null,
    Object? candidateId = freezed,
    Object? jobId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      candidateId: freezed == candidateId
          ? _value.candidateId
          : candidateId // ignore: cast_nullable_to_non_nullable
              as String?,
      jobId: freezed == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationEntityImplCopyWith<$Res>
    implements $NotificationEntityCopyWith<$Res> {
  factory _$$NotificationEntityImplCopyWith(_$NotificationEntityImpl value,
          $Res Function(_$NotificationEntityImpl) then) =
      __$$NotificationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      NotificationType type,
      DateTime createdAt,
      bool isRead,
      String? candidateId,
      String? jobId});
}

/// @nodoc
class __$$NotificationEntityImplCopyWithImpl<$Res>
    extends _$NotificationEntityCopyWithImpl<$Res, _$NotificationEntityImpl>
    implements _$$NotificationEntityImplCopyWith<$Res> {
  __$$NotificationEntityImplCopyWithImpl(_$NotificationEntityImpl _value,
      $Res Function(_$NotificationEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? createdAt = null,
    Object? isRead = null,
    Object? candidateId = freezed,
    Object? jobId = freezed,
  }) {
    return _then(_$NotificationEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      candidateId: freezed == candidateId
          ? _value.candidateId
          : candidateId // ignore: cast_nullable_to_non_nullable
              as String?,
      jobId: freezed == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NotificationEntityImpl implements _NotificationEntity {
  const _$NotificationEntityImpl(
      {required this.id,
      required this.title,
      required this.body,
      required this.type,
      required this.createdAt,
      this.isRead = false,
      this.candidateId,
      this.jobId});

  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final NotificationType type;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final String? candidateId;
  @override
  final String? jobId;

  @override
  String toString() {
    return 'NotificationEntity(id: $id, title: $title, body: $body, type: $type, createdAt: $createdAt, isRead: $isRead, candidateId: $candidateId, jobId: $jobId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.candidateId, candidateId) ||
                other.candidateId == candidateId) &&
            (identical(other.jobId, jobId) || other.jobId == jobId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, body, type, createdAt,
      isRead, candidateId, jobId);

  /// Create a copy of NotificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationEntityImplCopyWith<_$NotificationEntityImpl> get copyWith =>
      __$$NotificationEntityImplCopyWithImpl<_$NotificationEntityImpl>(
          this, _$identity);
}

abstract class _NotificationEntity implements NotificationEntity {
  const factory _NotificationEntity(
      {required final String id,
      required final String title,
      required final String body,
      required final NotificationType type,
      required final DateTime createdAt,
      final bool isRead,
      final String? candidateId,
      final String? jobId}) = _$NotificationEntityImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get body;
  @override
  NotificationType get type;
  @override
  DateTime get createdAt;
  @override
  bool get isRead;
  @override
  String? get candidateId;
  @override
  String? get jobId;

  /// Create a copy of NotificationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationEntityImplCopyWith<_$NotificationEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NotificationSettings {
  bool get cvUploadedEmail => throw _privateConstructorUsedError;
  bool get stageMovedEmail => throw _privateConstructorUsedError;
  bool get jobAssignedEmail => throw _privateConstructorUsedError;
  bool get pushEnabled => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingsCopyWith<NotificationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsCopyWith<$Res> {
  factory $NotificationSettingsCopyWith(NotificationSettings value,
          $Res Function(NotificationSettings) then) =
      _$NotificationSettingsCopyWithImpl<$Res, NotificationSettings>;
  @useResult
  $Res call(
      {bool cvUploadedEmail,
      bool stageMovedEmail,
      bool jobAssignedEmail,
      bool pushEnabled});
}

/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res,
        $Val extends NotificationSettings>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cvUploadedEmail = null,
    Object? stageMovedEmail = null,
    Object? jobAssignedEmail = null,
    Object? pushEnabled = null,
  }) {
    return _then(_value.copyWith(
      cvUploadedEmail: null == cvUploadedEmail
          ? _value.cvUploadedEmail
          : cvUploadedEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      stageMovedEmail: null == stageMovedEmail
          ? _value.stageMovedEmail
          : stageMovedEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      jobAssignedEmail: null == jobAssignedEmail
          ? _value.jobAssignedEmail
          : jobAssignedEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingsImplCopyWith<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  factory _$$NotificationSettingsImplCopyWith(_$NotificationSettingsImpl value,
          $Res Function(_$NotificationSettingsImpl) then) =
      __$$NotificationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool cvUploadedEmail,
      bool stageMovedEmail,
      bool jobAssignedEmail,
      bool pushEnabled});
}

/// @nodoc
class __$$NotificationSettingsImplCopyWithImpl<$Res>
    extends _$NotificationSettingsCopyWithImpl<$Res, _$NotificationSettingsImpl>
    implements _$$NotificationSettingsImplCopyWith<$Res> {
  __$$NotificationSettingsImplCopyWithImpl(_$NotificationSettingsImpl _value,
      $Res Function(_$NotificationSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cvUploadedEmail = null,
    Object? stageMovedEmail = null,
    Object? jobAssignedEmail = null,
    Object? pushEnabled = null,
  }) {
    return _then(_$NotificationSettingsImpl(
      cvUploadedEmail: null == cvUploadedEmail
          ? _value.cvUploadedEmail
          : cvUploadedEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      stageMovedEmail: null == stageMovedEmail
          ? _value.stageMovedEmail
          : stageMovedEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      jobAssignedEmail: null == jobAssignedEmail
          ? _value.jobAssignedEmail
          : jobAssignedEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NotificationSettingsImpl implements _NotificationSettings {
  const _$NotificationSettingsImpl(
      {this.cvUploadedEmail = true,
      this.stageMovedEmail = true,
      this.jobAssignedEmail = true,
      this.pushEnabled = true});

  @override
  @JsonKey()
  final bool cvUploadedEmail;
  @override
  @JsonKey()
  final bool stageMovedEmail;
  @override
  @JsonKey()
  final bool jobAssignedEmail;
  @override
  @JsonKey()
  final bool pushEnabled;

  @override
  String toString() {
    return 'NotificationSettings(cvUploadedEmail: $cvUploadedEmail, stageMovedEmail: $stageMovedEmail, jobAssignedEmail: $jobAssignedEmail, pushEnabled: $pushEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsImpl &&
            (identical(other.cvUploadedEmail, cvUploadedEmail) ||
                other.cvUploadedEmail == cvUploadedEmail) &&
            (identical(other.stageMovedEmail, stageMovedEmail) ||
                other.stageMovedEmail == stageMovedEmail) &&
            (identical(other.jobAssignedEmail, jobAssignedEmail) ||
                other.jobAssignedEmail == jobAssignedEmail) &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cvUploadedEmail, stageMovedEmail,
      jobAssignedEmail, pushEnabled);

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith =>
          __$$NotificationSettingsImplCopyWithImpl<_$NotificationSettingsImpl>(
              this, _$identity);
}

abstract class _NotificationSettings implements NotificationSettings {
  const factory _NotificationSettings(
      {final bool cvUploadedEmail,
      final bool stageMovedEmail,
      final bool jobAssignedEmail,
      final bool pushEnabled}) = _$NotificationSettingsImpl;

  @override
  bool get cvUploadedEmail;
  @override
  bool get stageMovedEmail;
  @override
  bool get jobAssignedEmail;
  @override
  bool get pushEnabled;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
