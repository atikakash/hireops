// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$JobFormState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  JobEntity? get savedJob => throw _privateConstructorUsedError;

  /// Create a copy of JobFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobFormStateCopyWith<JobFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobFormStateCopyWith<$Res> {
  factory $JobFormStateCopyWith(
          JobFormState value, $Res Function(JobFormState) then) =
      _$JobFormStateCopyWithImpl<$Res, JobFormState>;
  @useResult
  $Res call({bool isLoading, String? errorMessage, JobEntity? savedJob});

  $JobEntityCopyWith<$Res>? get savedJob;
}

/// @nodoc
class _$JobFormStateCopyWithImpl<$Res, $Val extends JobFormState>
    implements $JobFormStateCopyWith<$Res> {
  _$JobFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? savedJob = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      savedJob: freezed == savedJob
          ? _value.savedJob
          : savedJob // ignore: cast_nullable_to_non_nullable
              as JobEntity?,
    ) as $Val);
  }

  /// Create a copy of JobFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JobEntityCopyWith<$Res>? get savedJob {
    if (_value.savedJob == null) {
      return null;
    }

    return $JobEntityCopyWith<$Res>(_value.savedJob!, (value) {
      return _then(_value.copyWith(savedJob: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JobFormStateImplCopyWith<$Res>
    implements $JobFormStateCopyWith<$Res> {
  factory _$$JobFormStateImplCopyWith(
          _$JobFormStateImpl value, $Res Function(_$JobFormStateImpl) then) =
      __$$JobFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, String? errorMessage, JobEntity? savedJob});

  @override
  $JobEntityCopyWith<$Res>? get savedJob;
}

/// @nodoc
class __$$JobFormStateImplCopyWithImpl<$Res>
    extends _$JobFormStateCopyWithImpl<$Res, _$JobFormStateImpl>
    implements _$$JobFormStateImplCopyWith<$Res> {
  __$$JobFormStateImplCopyWithImpl(
      _$JobFormStateImpl _value, $Res Function(_$JobFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of JobFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? savedJob = freezed,
  }) {
    return _then(_$JobFormStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      savedJob: freezed == savedJob
          ? _value.savedJob
          : savedJob // ignore: cast_nullable_to_non_nullable
              as JobEntity?,
    ));
  }
}

/// @nodoc

class _$JobFormStateImpl implements _JobFormState {
  const _$JobFormStateImpl(
      {this.isLoading = false, this.errorMessage, this.savedJob});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  final JobEntity? savedJob;

  @override
  String toString() {
    return 'JobFormState(isLoading: $isLoading, errorMessage: $errorMessage, savedJob: $savedJob)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobFormStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.savedJob, savedJob) ||
                other.savedJob == savedJob));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, errorMessage, savedJob);

  /// Create a copy of JobFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobFormStateImplCopyWith<_$JobFormStateImpl> get copyWith =>
      __$$JobFormStateImplCopyWithImpl<_$JobFormStateImpl>(this, _$identity);
}

abstract class _JobFormState implements JobFormState {
  const factory _JobFormState(
      {final bool isLoading,
      final String? errorMessage,
      final JobEntity? savedJob}) = _$JobFormStateImpl;

  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  JobEntity? get savedJob;

  /// Create a copy of JobFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobFormStateImplCopyWith<_$JobFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
