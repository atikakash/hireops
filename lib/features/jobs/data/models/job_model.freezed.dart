// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JobModel _$JobModelFromJson(Map<String, dynamic> json) {
  return _JobModel.fromJson(json);
}

/// @nodoc
mixin _$JobModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get department => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get openDate => throw _privateConstructorUsedError;
  int get candidateCount => throw _privateConstructorUsedError;
  List<String> get assignedCandidateIds => throw _privateConstructorUsedError;
  String? get closedDate => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this JobModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobModelCopyWith<JobModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobModelCopyWith<$Res> {
  factory $JobModelCopyWith(JobModel value, $Res Function(JobModel) then) =
      _$JobModelCopyWithImpl<$Res, JobModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String department,
      String description,
      String status,
      String openDate,
      int candidateCount,
      List<String> assignedCandidateIds,
      String? closedDate,
      String? createdAt});
}

/// @nodoc
class _$JobModelCopyWithImpl<$Res, $Val extends JobModel>
    implements $JobModelCopyWith<$Res> {
  _$JobModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobModel
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
              as String,
      openDate: null == openDate
          ? _value.openDate
          : openDate // ignore: cast_nullable_to_non_nullable
              as String,
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
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JobModelImplCopyWith<$Res>
    implements $JobModelCopyWith<$Res> {
  factory _$$JobModelImplCopyWith(
          _$JobModelImpl value, $Res Function(_$JobModelImpl) then) =
      __$$JobModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String department,
      String description,
      String status,
      String openDate,
      int candidateCount,
      List<String> assignedCandidateIds,
      String? closedDate,
      String? createdAt});
}

/// @nodoc
class __$$JobModelImplCopyWithImpl<$Res>
    extends _$JobModelCopyWithImpl<$Res, _$JobModelImpl>
    implements _$$JobModelImplCopyWith<$Res> {
  __$$JobModelImplCopyWithImpl(
      _$JobModelImpl _value, $Res Function(_$JobModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of JobModel
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
    return _then(_$JobModelImpl(
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
              as String,
      openDate: null == openDate
          ? _value.openDate
          : openDate // ignore: cast_nullable_to_non_nullable
              as String,
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
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JobModelImpl implements _JobModel {
  const _$JobModelImpl(
      {required this.id,
      required this.title,
      required this.department,
      required this.description,
      this.status = 'open',
      required this.openDate,
      this.candidateCount = 0,
      final List<String> assignedCandidateIds = const [],
      this.closedDate,
      this.createdAt})
      : _assignedCandidateIds = assignedCandidateIds;

  factory _$JobModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String department;
  @override
  final String description;
  @override
  @JsonKey()
  final String status;
  @override
  final String openDate;
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
  final String? closedDate;
  @override
  final String? createdAt;

  @override
  String toString() {
    return 'JobModel(id: $id, title: $title, department: $department, description: $description, status: $status, openDate: $openDate, candidateCount: $candidateCount, assignedCandidateIds: $assignedCandidateIds, closedDate: $closedDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      __$$JobModelImplCopyWithImpl<_$JobModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobModelImplToJson(
      this,
    );
  }
}

abstract class _JobModel implements JobModel {
  const factory _JobModel(
      {required final String id,
      required final String title,
      required final String department,
      required final String description,
      final String status,
      required final String openDate,
      final int candidateCount,
      final List<String> assignedCandidateIds,
      final String? closedDate,
      final String? createdAt}) = _$JobModelImpl;

  factory _JobModel.fromJson(Map<String, dynamic> json) =
      _$JobModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get department;
  @override
  String get description;
  @override
  String get status;
  @override
  String get openDate;
  @override
  int get candidateCount;
  @override
  List<String> get assignedCandidateIds;
  @override
  String? get closedDate;
  @override
  String? get createdAt;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
