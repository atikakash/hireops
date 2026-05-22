// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pipeline_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PipelineMoveState {
  bool get isMoving => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get lastMovedCandidateId => throw _privateConstructorUsedError;

  /// Create a copy of PipelineMoveState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PipelineMoveStateCopyWith<PipelineMoveState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PipelineMoveStateCopyWith<$Res> {
  factory $PipelineMoveStateCopyWith(
          PipelineMoveState value, $Res Function(PipelineMoveState) then) =
      _$PipelineMoveStateCopyWithImpl<$Res, PipelineMoveState>;
  @useResult
  $Res call(
      {bool isMoving, String? errorMessage, String? lastMovedCandidateId});
}

/// @nodoc
class _$PipelineMoveStateCopyWithImpl<$Res, $Val extends PipelineMoveState>
    implements $PipelineMoveStateCopyWith<$Res> {
  _$PipelineMoveStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PipelineMoveState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isMoving = null,
    Object? errorMessage = freezed,
    Object? lastMovedCandidateId = freezed,
  }) {
    return _then(_value.copyWith(
      isMoving: null == isMoving
          ? _value.isMoving
          : isMoving // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMovedCandidateId: freezed == lastMovedCandidateId
          ? _value.lastMovedCandidateId
          : lastMovedCandidateId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PipelineMoveStateImplCopyWith<$Res>
    implements $PipelineMoveStateCopyWith<$Res> {
  factory _$$PipelineMoveStateImplCopyWith(_$PipelineMoveStateImpl value,
          $Res Function(_$PipelineMoveStateImpl) then) =
      __$$PipelineMoveStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isMoving, String? errorMessage, String? lastMovedCandidateId});
}

/// @nodoc
class __$$PipelineMoveStateImplCopyWithImpl<$Res>
    extends _$PipelineMoveStateCopyWithImpl<$Res, _$PipelineMoveStateImpl>
    implements _$$PipelineMoveStateImplCopyWith<$Res> {
  __$$PipelineMoveStateImplCopyWithImpl(_$PipelineMoveStateImpl _value,
      $Res Function(_$PipelineMoveStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PipelineMoveState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isMoving = null,
    Object? errorMessage = freezed,
    Object? lastMovedCandidateId = freezed,
  }) {
    return _then(_$PipelineMoveStateImpl(
      isMoving: null == isMoving
          ? _value.isMoving
          : isMoving // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMovedCandidateId: freezed == lastMovedCandidateId
          ? _value.lastMovedCandidateId
          : lastMovedCandidateId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PipelineMoveStateImpl implements _PipelineMoveState {
  const _$PipelineMoveStateImpl(
      {this.isMoving = false, this.errorMessage, this.lastMovedCandidateId});

  @override
  @JsonKey()
  final bool isMoving;
  @override
  final String? errorMessage;
  @override
  final String? lastMovedCandidateId;

  @override
  String toString() {
    return 'PipelineMoveState(isMoving: $isMoving, errorMessage: $errorMessage, lastMovedCandidateId: $lastMovedCandidateId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PipelineMoveStateImpl &&
            (identical(other.isMoving, isMoving) ||
                other.isMoving == isMoving) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.lastMovedCandidateId, lastMovedCandidateId) ||
                other.lastMovedCandidateId == lastMovedCandidateId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isMoving, errorMessage, lastMovedCandidateId);

  /// Create a copy of PipelineMoveState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PipelineMoveStateImplCopyWith<_$PipelineMoveStateImpl> get copyWith =>
      __$$PipelineMoveStateImplCopyWithImpl<_$PipelineMoveStateImpl>(
          this, _$identity);
}

abstract class _PipelineMoveState implements PipelineMoveState {
  const factory _PipelineMoveState(
      {final bool isMoving,
      final String? errorMessage,
      final String? lastMovedCandidateId}) = _$PipelineMoveStateImpl;

  @override
  bool get isMoving;
  @override
  String? get errorMessage;
  @override
  String? get lastMovedCandidateId;

  /// Create a copy of PipelineMoveState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PipelineMoveStateImplCopyWith<_$PipelineMoveStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
