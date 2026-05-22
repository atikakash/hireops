// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardStats {
  int get totalCandidates => throw _privateConstructorUsedError;
  int get activeJobs => throw _privateConstructorUsedError;
  int get totalHired => throw _privateConstructorUsedError;
  int get totalRejected => throw _privateConstructorUsedError;
  Map<String, int> get candidatesPerStage => throw _privateConstructorUsedError;
  List<RecentActivityItem> get recentActivity =>
      throw _privateConstructorUsedError;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatsCopyWith<DashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsCopyWith<$Res> {
  factory $DashboardStatsCopyWith(
          DashboardStats value, $Res Function(DashboardStats) then) =
      _$DashboardStatsCopyWithImpl<$Res, DashboardStats>;
  @useResult
  $Res call(
      {int totalCandidates,
      int activeJobs,
      int totalHired,
      int totalRejected,
      Map<String, int> candidatesPerStage,
      List<RecentActivityItem> recentActivity});
}

/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res, $Val extends DashboardStats>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStats
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
              as List<RecentActivityItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardStatsImplCopyWith<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  factory _$$DashboardStatsImplCopyWith(_$DashboardStatsImpl value,
          $Res Function(_$DashboardStatsImpl) then) =
      __$$DashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalCandidates,
      int activeJobs,
      int totalHired,
      int totalRejected,
      Map<String, int> candidatesPerStage,
      List<RecentActivityItem> recentActivity});
}

/// @nodoc
class __$$DashboardStatsImplCopyWithImpl<$Res>
    extends _$DashboardStatsCopyWithImpl<$Res, _$DashboardStatsImpl>
    implements _$$DashboardStatsImplCopyWith<$Res> {
  __$$DashboardStatsImplCopyWithImpl(
      _$DashboardStatsImpl _value, $Res Function(_$DashboardStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardStats
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
    return _then(_$DashboardStatsImpl(
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
              as List<RecentActivityItem>,
    ));
  }
}

/// @nodoc

class _$DashboardStatsImpl implements _DashboardStats {
  const _$DashboardStatsImpl(
      {required this.totalCandidates,
      required this.activeJobs,
      required this.totalHired,
      required this.totalRejected,
      required final Map<String, int> candidatesPerStage,
      required final List<RecentActivityItem> recentActivity})
      : _candidatesPerStage = candidatesPerStage,
        _recentActivity = recentActivity;

  @override
  final int totalCandidates;
  @override
  final int activeJobs;
  @override
  final int totalHired;
  @override
  final int totalRejected;
  final Map<String, int> _candidatesPerStage;
  @override
  Map<String, int> get candidatesPerStage {
    if (_candidatesPerStage is EqualUnmodifiableMapView)
      return _candidatesPerStage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_candidatesPerStage);
  }

  final List<RecentActivityItem> _recentActivity;
  @override
  List<RecentActivityItem> get recentActivity {
    if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivity);
  }

  @override
  String toString() {
    return 'DashboardStats(totalCandidates: $totalCandidates, activeJobs: $activeJobs, totalHired: $totalHired, totalRejected: $totalRejected, candidatesPerStage: $candidatesPerStage, recentActivity: $recentActivity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
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

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalCandidates,
      activeJobs,
      totalHired,
      totalRejected,
      const DeepCollectionEquality().hash(_candidatesPerStage),
      const DeepCollectionEquality().hash(_recentActivity));

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      __$$DashboardStatsImplCopyWithImpl<_$DashboardStatsImpl>(
          this, _$identity);
}

abstract class _DashboardStats implements DashboardStats {
  const factory _DashboardStats(
          {required final int totalCandidates,
          required final int activeJobs,
          required final int totalHired,
          required final int totalRejected,
          required final Map<String, int> candidatesPerStage,
          required final List<RecentActivityItem> recentActivity}) =
      _$DashboardStatsImpl;

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
  List<RecentActivityItem> get recentActivity;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RecentActivityItem {
  String get id => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get actorName => throw _privateConstructorUsedError;
  String? get targetName => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  ActivityType get type => throw _privateConstructorUsedError;

  /// Create a copy of RecentActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentActivityItemCopyWith<RecentActivityItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentActivityItemCopyWith<$Res> {
  factory $RecentActivityItemCopyWith(
          RecentActivityItem value, $Res Function(RecentActivityItem) then) =
      _$RecentActivityItemCopyWithImpl<$Res, RecentActivityItem>;
  @useResult
  $Res call(
      {String id,
      String action,
      String actorName,
      String? targetName,
      DateTime createdAt,
      ActivityType type});
}

/// @nodoc
class _$RecentActivityItemCopyWithImpl<$Res, $Val extends RecentActivityItem>
    implements $RecentActivityItemCopyWith<$Res> {
  _$RecentActivityItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentActivityItem
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
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActivityType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentActivityItemImplCopyWith<$Res>
    implements $RecentActivityItemCopyWith<$Res> {
  factory _$$RecentActivityItemImplCopyWith(_$RecentActivityItemImpl value,
          $Res Function(_$RecentActivityItemImpl) then) =
      __$$RecentActivityItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String action,
      String actorName,
      String? targetName,
      DateTime createdAt,
      ActivityType type});
}

/// @nodoc
class __$$RecentActivityItemImplCopyWithImpl<$Res>
    extends _$RecentActivityItemCopyWithImpl<$Res, _$RecentActivityItemImpl>
    implements _$$RecentActivityItemImplCopyWith<$Res> {
  __$$RecentActivityItemImplCopyWithImpl(_$RecentActivityItemImpl _value,
      $Res Function(_$RecentActivityItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecentActivityItem
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
    return _then(_$RecentActivityItemImpl(
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
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActivityType,
    ));
  }
}

/// @nodoc

class _$RecentActivityItemImpl implements _RecentActivityItem {
  const _$RecentActivityItemImpl(
      {required this.id,
      required this.action,
      required this.actorName,
      this.targetName,
      required this.createdAt,
      required this.type});

  @override
  final String id;
  @override
  final String action;
  @override
  final String actorName;
  @override
  final String? targetName;
  @override
  final DateTime createdAt;
  @override
  final ActivityType type;

  @override
  String toString() {
    return 'RecentActivityItem(id: $id, action: $action, actorName: $actorName, targetName: $targetName, createdAt: $createdAt, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentActivityItemImpl &&
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

  @override
  int get hashCode => Object.hash(
      runtimeType, id, action, actorName, targetName, createdAt, type);

  /// Create a copy of RecentActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentActivityItemImplCopyWith<_$RecentActivityItemImpl> get copyWith =>
      __$$RecentActivityItemImplCopyWithImpl<_$RecentActivityItemImpl>(
          this, _$identity);
}

abstract class _RecentActivityItem implements RecentActivityItem {
  const factory _RecentActivityItem(
      {required final String id,
      required final String action,
      required final String actorName,
      final String? targetName,
      required final DateTime createdAt,
      required final ActivityType type}) = _$RecentActivityItemImpl;

  @override
  String get id;
  @override
  String get action;
  @override
  String get actorName;
  @override
  String? get targetName;
  @override
  DateTime get createdAt;
  @override
  ActivityType get type;

  /// Create a copy of RecentActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentActivityItemImplCopyWith<_$RecentActivityItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
