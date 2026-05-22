// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$JobEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get department => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  JobStatus get status => throw _privateConstructorUsedError;
  DateTime get openDate => throw _privateConstructorUsedError;
  int get candidateCount => throw _privateConstructorUsedError;
  List<String> get assignedCandidateIds => throw _privateConstructorUsedError;
  DateTime? get closedDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of JobEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobEntityCopyWith<JobEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobEntityCopyWith<$Res> {
  factory $JobEntityCopyWith(JobEntity value, $Res Function(JobEntity) then) =
      _$JobEntityCopyWithImpl<$Res, JobEntity>;
  @useResult
  $Res call(
      {String id,
      String title,
      String department,
      String description,
      JobStatus status,
      DateTime openDate,
      int candidateCount,
      List<String> assignedCandidateIds,
      DateTime? closedDate,
      DateTime? createdAt});
}

/// @nodoc
class _$JobEntityCopyWithImpl<$Res, $Val extends JobEntity>
    implements $JobEntityCopyWith<$Res> {
  _$JobEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? department = null,
    Object? description = null,
    Object? status = null,
    Object? openDate = null,
    Object? candidateCount = null,
    Object? assignedCandidateIds = null,
    Object? closedDate = freezed,
    Object? createdAt = freezed,
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
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JobStatus,
      openDate: null == openDate
          ? _value.openDate
          : openDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      candidateCount: null == candidateCount
          ? _value.candidateCount
          : candidateCount // ignore: cast_nullable_to_non_nullable
              as int,
      assignedCandidateIds: null == assignedCandidateIds
          ? _value.assignedCandidateIds
          : assignedCandidateIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      closedDate: freezed == closedDate
          ? _value.closedDate
          : closedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JobEntityImplCopyWith<$Res>
    implements $JobEntityCopyWith<$Res> {
  factory _$$JobEntityImplCopyWith(
          _$JobEntityImpl value, $Res Function(_$JobEntityImpl) then) =
      __$$JobEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String department,
      String description,
      JobStatus status,
      DateTime openDate,
      int candidateCount,
      List<String> assignedCandidateIds,
      DateTime? closedDate,
      DateTime? createdAt});
}

/// @nodoc
class __$$JobEntityImplCopyWithImpl<$Res>
    extends _$JobEntityCopyWithImpl<$Res, _$JobEntityImpl>
    implements _$$JobEntityImplCopyWith<$Res> {
  __$$JobEntityImplCopyWithImpl(
      _$JobEntityImpl _value, $Res Function(_$JobEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of JobEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? department = null,
    Object? description = null,
    Object? status = null,
    Object? openDate = null,
    Object? candidateCount = null,
    Object? assignedCandidateIds = null,
    Object? closedDate = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$JobEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JobStatus,
      openDate: null == openDate
          ? _value.openDate
          : openDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      candidateCount: null == candidateCount
          ? _value.candidateCount
          : candidateCount // ignore: cast_nullable_to_non_nullable
              as int,
      assignedCandidateIds: null == assignedCandidateIds
          ? _value._assignedCandidateIds
          : assignedCandidateIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      closedDate: freezed == closedDate
          ? _value.closedDate
          : closedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$JobEntityImpl implements _JobEntity {
  const _$JobEntityImpl(
      {required this.id,
      required this.title,
      required this.department,
      required this.description,
      required this.status,
      required this.openDate,
      this.candidateCount = 0,
      final List<String> assignedCandidateIds = const [],
      this.closedDate,
      this.createdAt})
      : _assignedCandidateIds = assignedCandidateIds;

  @override
  final String id;
  @override
  final String title;
  @override
  final String department;
  @override
  final String description;
  @override
  final JobStatus status;
  @override
  final DateTime openDate;
  @override
  @JsonKey()
  final int candidateCount;
  final List<String> _assignedCandidateIds;
  @override
  @JsonKey()
  List<String> get assignedCandidateIds {
    if (_assignedCandidateIds is EqualUnmodifiableListView)
      return _assignedCandidateIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignedCandidateIds);
  }

  @override
  final DateTime? closedDate;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'JobEntity(id: $id, title: $title, department: $department, description: $description, status: $status, openDate: $openDate, candidateCount: $candidateCount, assignedCandidateIds: $assignedCandidateIds, closedDate: $closedDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.openDate, openDate) ||
                other.openDate == openDate) &&
            (identical(other.candidateCount, candidateCount) ||
                other.candidateCount == candidateCount) &&
            const DeepCollectionEquality()
                .equals(other._assignedCandidateIds, _assignedCandidateIds) &&
            (identical(other.closedDate, closedDate) ||
                other.closedDate == closedDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      department,
      description,
      status,
      openDate,
      candidateCount,
      const DeepCollectionEquality().hash(_assignedCandidateIds),
      closedDate,
      createdAt);

  /// Create a copy of JobEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobEntityImplCopyWith<_$JobEntityImpl> get copyWith =>
      __$$JobEntityImplCopyWithImpl<_$JobEntityImpl>(this, _$identity);
}

abstract class _JobEntity implements JobEntity {
  const factory _JobEntity(
      {required final String id,
      required final String title,
      required final String department,
      required final String description,
      required final JobStatus status,
      required final DateTime openDate,
      final int candidateCount,
      final List<String> assignedCandidateIds,
      final DateTime? closedDate,
      final DateTime? createdAt}) = _$JobEntityImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get department;
  @override
  String get description;
  @override
  JobStatus get status;
  @override
  DateTime get openDate;
  @override
  int get candidateCount;
  @override
  List<String> get assignedCandidateIds;
  @override
  DateTime? get closedDate;
  @override
  DateTime? get createdAt;

  /// Create a copy of JobEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobEntityImplCopyWith<_$JobEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
