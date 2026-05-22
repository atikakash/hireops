// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) {
  return _DashboardStatsModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardStatsModel {
  int get totalCandidates => throw _privateConstructorUsedError;
  int get activeJobs => throw _privateConstructorUsedError;
  int get totalHired => throw _privateConstructorUsedError;
  int get totalRejected => throw _privateConstructorUsedError;
  Map<String, int> get candidatesPerStage => throw _privateConstructorUsedError;
  List<RecentActivityModel> get recentActivity =>
      throw _privateConstructorUsedError;

  /// Serializes this DashboardStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatsModelCopyWith<DashboardStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsModelCopyWith<$Res> {
  factory $DashboardStatsModelCopyWith(
          DashboardStatsModel value, $Res Function(DashboardStatsModel) then) =
      _$DashboardStatsModelCopyWithImpl<$Res, DashboardStatsModel>;
  @useResult
  $Res call(
      {int totalCandidates,
      int activeJobs,
      int totalHired,
      int totalRejected,
      Map<String, int> candidatesPerStage,
      List<RecentActivityModel> recentActivity});
}

/// @nodoc
class _$DashboardStatsModelCopyWithImpl<$Res, $Val extends DashboardStatsModel>
    implements $DashboardStatsModelCopyWith<$Res> {
  _$DashboardStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCandidates = null,
    Object? activeJobs = null,
    Object? totalHired = null,
    Object? totalRejected = null,
    Object? candidatesPerStage = null,
    Object? recentActivity = null,
  }) {
    return _then(_value.copyWith(
      totalCandidates: null == totalCandidates
          ? _value.totalCandidates
          : totalCandidates // ignore: cast_nullable_to_non_nullable
              as int,
      activeJobs: null == activeJobs
          ? _value.activeJobs
          : activeJobs // ignore: cast_nullable_to_non_nullable
              as int,
      totalHired: null == totalHired
          ? _value.totalHired
          : totalHired // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
      candidatesPerStage: null == candidatesPerStage
          ? _value.candidatesPerStage
          : candidatesPerStage // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      recentActivity: null == recentActivity
          ? _value.recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<RecentActivityModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardStatsModelImplCopyWith<$Res>
    implements $DashboardStatsModelCopyWith<$Res> {
  factory _$$DashboardStatsModelImplCopyWith(_$DashboardStatsModelImpl value,
          $Res Function(_$DashboardStatsModelImpl) then) =
      __$$DashboardStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalCandidates,
      int activeJobs,
      int totalHired,
      int totalRejected,
      Map<String, int> candidatesPerStage,
      List<RecentActivityModel> recentActivity});
}

/// @nodoc
class __$$DashboardStatsModelImplCopyWithImpl<$Res>
    extends _$DashboardStatsModelCopyWithImpl<$Res, _$DashboardStatsModelImpl>
    implements _$$DashboardStatsModelImplCopyWith<$Res> {
  __$$DashboardStatsModelImplCopyWithImpl(_$DashboardStatsModelImpl _value,
      $Res Function(_$DashboardStatsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCandidates = null,
    Object? activeJobs = null,
    Object? totalHired = null,
    Object? totalRejected = null,
    Object? candidatesPerStage = null,
    Object? recentActivity = null,
  }) {
    return _then(_$DashboardStatsModelImpl(
      totalCandidates: null == totalCandidates
          ? _value.totalCandidates
          : totalCandidates // ignore: cast_nullable_to_non_nullable
              as int,
      activeJobs: null == activeJobs
          ? _value.activeJobs
          : activeJobs // ignore: cast_nullable_to_non_nullable
              as int,
      totalHired: null == totalHired
          ? _value.totalHired
          : totalHired // ignore: cast_nullable_to_non_nullable
              as int,
      totalRejected: null == totalRejected
          ? _value.totalRejected
          : totalRejected // ignore: cast_nullable_to_non_nullable
              as int,
      candidatesPerStage: null == candidatesPerStage
          ? _value._candidatesPerStage
          : candidatesPerStage // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      recentActivity: null == recentActivity
          ? _value._recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<RecentActivityModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsModelImpl implements _DashboardStatsModel {
  const _$DashboardStatsModelImpl(
      {required this.totalCandidates,
      required this.activeJobs,
      this.totalHired = 0,
      this.totalRejected = 0,
      final Map<String, int> candidatesPerStage = const {},
      final List<RecentActivityModel> recentActivity = const []})
      : _candidatesPerStage = candidatesPerStage,
        _recentActivity = recentActivity;

  factory _$DashboardStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsModelImplFromJson(json);

  @override
  final int totalCandidates;
  @override
  final int activeJobs;
  @override
  @JsonKey()
  final int totalHired;
  @override
  @JsonKey()
  final int totalRejected;
  final Map<String, int> _candidatesPerStage;
  @override
  @JsonKey()
  Map<String, int> get candidatesPerStage {
    if (_candidatesPerStage is EqualUnmodifiableMapView)
      return _candidatesPerStage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_candidatesPerStage);
  }

  final List<RecentActivityModel> _recentActivity;
  @override
  @JsonKey()
  List<RecentActivityModel> get recentActivity {
    if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivity);
  }

  @override
  String toString() {
    return 'DashboardStatsModel(totalCandidates: $totalCandidates, activeJobs: $activeJobs, totalHired: $totalHired, totalRejected: $totalRejected, candidatesPerStage: $candidatesPerStage, recentActivity: $recentActivity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsModelImpl &&
            (identical(other.totalCandidates, totalCandidates) ||
                other.totalCandidates == totalCandidates) &&
            (identical(other.activeJobs, activeJobs) ||
                other.activeJobs == activeJobs) &&
            (identical(other.totalHired, totalHired) ||
                other.totalHired == totalHired) &&
            (identical(other.totalRejected, totalRejected) ||
                other.totalRejected == totalRejected) &&
            const DeepCollectionEquality()
                .equals(other._candidatesPerStage, _candidatesPerStage) &&
            const DeepCollectionEquality()
                .equals(other._recentActivity, _recentActivity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalCandidates,
      activeJobs,
      totalHired,
      totalRejected,
      const DeepCollectionEquality().hash(_candidatesPerStage),
      const DeepCollectionEquality().hash(_recentActivity));

  /// Create a copy of DashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsModelImplCopyWith<_$DashboardStatsModelImpl> get copyWith =>
      __$$DashboardStatsModelImplCopyWithImpl<_$DashboardStatsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatsModelImplToJson(
      this,
    );
  }
}

abstract class _DashboardStatsModel implements DashboardStatsModel {
  const factory _DashboardStatsModel(
          {required final int totalCandidates,
          required final int activeJobs,
          final int totalHired,
          final int totalRejected,
          final Map<String, int> candidatesPerStage,
          final List<RecentActivityModel> recentActivity}) =
      _$DashboardStatsModelImpl;

  factory _DashboardStatsModel.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsModelImpl.fromJson;

  @override
  int get totalCandidates;
  @override
  int get activeJobs;
  @override
  int get totalHired;
  @override
  int get totalRejected;
  @override
  Map<String, int> get candidatesPerStage;
  @override
  List<RecentActivityModel> get recentActivity;

  /// Create a copy of DashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsModelImplCopyWith<_$DashboardStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecentActivityModel _$RecentActivityModelFromJson(Map<String, dynamic> json) {
  return _RecentActivityModel.fromJson(json);
}

/// @nodoc
mixin _$RecentActivityModel {
  String get id => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get actorName => throw _privateConstructorUsedError;
  String? get targetName => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this RecentActivityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentActivityModelCopyWith<RecentActivityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentActivityModelCopyWith<$Res> {
  factory $RecentActivityModelCopyWith(
          RecentActivityModel value, $Res Function(RecentActivityModel) then) =
      _$RecentActivityModelCopyWithImpl<$Res, RecentActivityModel>;
  @useResult
  $Res call(
      {String id,
      String action,
      String actorName,
      String? targetName,
      String createdAt,
      String type});
}

/// @nodoc
class _$RecentActivityModelCopyWithImpl<$Res, $Val extends RecentActivityModel>
    implements $RecentActivityModelCopyWith<$Res> {
  _$RecentActivityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? actorName = null,
    Object? targetName = freezed,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      actorName: null == actorName
          ? _value.actorName
          : actorName // ignore: cast_nullable_to_non_nullable
              as String,
      targetName: freezed == targetName
          ? _value.targetName
          : targetName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentActivityModelImplCopyWith<$Res>
    implements $RecentActivityModelCopyWith<$Res> {
  factory _$$RecentActivityModelImplCopyWith(_$RecentActivityModelImpl value,
          $Res Function(_$RecentActivityModelImpl) then) =
      __$$RecentActivityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String action,
      String actorName,
      String? targetName,
      String createdAt,
      String type});
}

/// @nodoc
class __$$RecentActivityModelImplCopyWithImpl<$Res>
    extends _$RecentActivityModelCopyWithImpl<$Res, _$RecentActivityModelImpl>
    implements _$$RecentActivityModelImplCopyWith<$Res> {
  __$$RecentActivityModelImplCopyWithImpl(_$RecentActivityModelImpl _value,
      $Res Function(_$RecentActivityModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? actorName = null,
    Object? targetName = freezed,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(_$RecentActivityModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      actorName: null == actorName
          ? _value.actorName
          : actorName // ignore: cast_nullable_to_non_nullable
              as String,
      targetName: freezed == targetName
          ? _value.targetName
          : targetName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentActivityModelImpl implements _RecentActivityModel {
  const _$RecentActivityModelImpl(
      {required this.id,
      required this.action,
      required this.actorName,
      this.targetName,
      required this.createdAt,
      this.type = 'candidateAdded'});

  factory _$RecentActivityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentActivityModelImplFromJson(json);

  @override
  final String id;
  @override
  final String action;
  @override
  final String actorName;
  @override
  final String? targetName;
  @override
  final String createdAt;
  @override
  @JsonKey()
  final String type;

  @override
  String toString() {
    return 'RecentActivityModel(id: $id, action: $action, actorName: $actorName, targetName: $targetName, createdAt: $createdAt, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentActivityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.actorName, actorName) ||
                other.actorName == actorName) &&
            (identical(other.targetName, targetName) ||
                other.targetName == targetName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, action, actorName, targetName, createdAt, type);

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentActivityModelImplCopyWith<_$RecentActivityModelImpl> get copyWith =>
      __$$RecentActivityModelImplCopyWithImpl<_$RecentActivityModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentActivityModelImplToJson(
      this,
    );
  }
}

abstract class _RecentActivityModel implements RecentActivityModel {
  const factory _RecentActivityModel(
      {required final String id,
      required final String action,
      required final String actorName,
      final String? targetName,
      required final String createdAt,
      final String type}) = _$RecentActivityModelImpl;

  factory _RecentActivityModel.fromJson(Map<String, dynamic> json) =
      _$RecentActivityModelImpl.fromJson;

  @override
  String get id;
  @override
  String get action;
  @override
  String get actorName;
  @override
  String? get targetName;
  @override
  String get createdAt;
  @override
  String get type;

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentActivityModelImplCopyWith<_$RecentActivityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
