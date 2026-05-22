// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'candidate_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CandidateFilter {
  String get query => throw _privateConstructorUsedError;
  String? get tag => throw _privateConstructorUsedError;
  int? get minExperience => throw _privateConstructorUsedError;
  int? get maxExperience => throw _privateConstructorUsedError;
  PipelineStage? get stage => throw _privateConstructorUsedError;

  /// Create a copy of CandidateFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CandidateFilterCopyWith<CandidateFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandidateFilterCopyWith<$Res> {
  factory $CandidateFilterCopyWith(
          CandidateFilter value, $Res Function(CandidateFilter) then) =
      _$CandidateFilterCopyWithImpl<$Res, CandidateFilter>;
  @useResult
  $Res call(
      {String query,
      String? tag,
      int? minExperience,
      int? maxExperience,
      PipelineStage? stage});
}

/// @nodoc
class _$CandidateFilterCopyWithImpl<$Res, $Val extends CandidateFilter>
    implements $CandidateFilterCopyWith<$Res> {
  _$CandidateFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CandidateFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? tag = freezed,
    Object? minExperience = freezed,
    Object? maxExperience = freezed,
    Object? stage = freezed,
  }) {
    return _then(_value.copyWith(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      tag: freezed == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String?,
      minExperience: freezed == minExperience
          ? _value.minExperience
          : minExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      maxExperience: freezed == maxExperience
          ? _value.maxExperience
          : maxExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      stage: freezed == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as PipelineStage?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CandidateFilterImplCopyWith<$Res>
    implements $CandidateFilterCopyWith<$Res> {
  factory _$$CandidateFilterImplCopyWith(_$CandidateFilterImpl value,
          $Res Function(_$CandidateFilterImpl) then) =
      __$$CandidateFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String query,
      String? tag,
      int? minExperience,
      int? maxExperience,
      PipelineStage? stage});
}

/// @nodoc
class __$$CandidateFilterImplCopyWithImpl<$Res>
    extends _$CandidateFilterCopyWithImpl<$Res, _$CandidateFilterImpl>
    implements _$$CandidateFilterImplCopyWith<$Res> {
  __$$CandidateFilterImplCopyWithImpl(
      _$CandidateFilterImpl _value, $Res Function(_$CandidateFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of CandidateFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? tag = freezed,
    Object? minExperience = freezed,
    Object? maxExperience = freezed,
    Object? stage = freezed,
  }) {
    return _then(_$CandidateFilterImpl(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      tag: freezed == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String?,
      minExperience: freezed == minExperience
          ? _value.minExperience
          : minExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      maxExperience: freezed == maxExperience
          ? _value.maxExperience
          : maxExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      stage: freezed == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as PipelineStage?,
    ));
  }
}

/// @nodoc

class _$CandidateFilterImpl implements _CandidateFilter {
  const _$CandidateFilterImpl(
      {this.query = '',
      this.tag,
      this.minExperience,
      this.maxExperience,
      this.stage});

  @override
  @JsonKey()
  final String query;
  @override
  final String? tag;
  @override
  final int? minExperience;
  @override
  final int? maxExperience;
  @override
  final PipelineStage? stage;

  @override
  String toString() {
    return 'CandidateFilter(query: $query, tag: $tag, minExperience: $minExperience, maxExperience: $maxExperience, stage: $stage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CandidateFilterImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.minExperience, minExperience) ||
                other.minExperience == minExperience) &&
            (identical(other.maxExperience, maxExperience) ||
                other.maxExperience == maxExperience) &&
            (identical(other.stage, stage) || other.stage == stage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, query, tag, minExperience, maxExperience, stage);

  /// Create a copy of CandidateFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CandidateFilterImplCopyWith<_$CandidateFilterImpl> get copyWith =>
      __$$CandidateFilterImplCopyWithImpl<_$CandidateFilterImpl>(
          this, _$identity);
}

abstract class _CandidateFilter implements CandidateFilter {
  const factory _CandidateFilter(
      {final String query,
      final String? tag,
      final int? minExperience,
      final int? maxExperience,
      final PipelineStage? stage}) = _$CandidateFilterImpl;

  @override
  String get query;
  @override
  String? get tag;
  @override
  int? get minExperience;
  @override
  int? get maxExperience;
  @override
  PipelineStage? get stage;

  /// Create a copy of CandidateFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CandidateFilterImplCopyWith<_$CandidateFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CandidateFormState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  CandidateEntity? get savedCandidate => throw _privateConstructorUsedError;

  /// Create a copy of CandidateFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CandidateFormStateCopyWith<CandidateFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandidateFormStateCopyWith<$Res> {
  factory $CandidateFormStateCopyWith(
          CandidateFormState value, $Res Function(CandidateFormState) then) =
      _$CandidateFormStateCopyWithImpl<$Res, CandidateFormState>;
  @useResult
  $Res call(
      {bool isLoading, String? errorMessage, CandidateEntity? savedCandidate});

  $CandidateEntityCopyWith<$Res>? get savedCandidate;
}

/// @nodoc
class _$CandidateFormStateCopyWithImpl<$Res, $Val extends CandidateFormState>
    implements $CandidateFormStateCopyWith<$Res> {
  _$CandidateFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CandidateFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? savedCandidate = freezed,
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
      savedCandidate: freezed == savedCandidate
          ? _value.savedCandidate
          : savedCandidate // ignore: cast_nullable_to_non_nullable
              as CandidateEntity?,
    ) as $Val);
  }

  /// Create a copy of CandidateFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CandidateEntityCopyWith<$Res>? get savedCandidate {
    if (_value.savedCandidate == null) {
      return null;
    }

    return $CandidateEntityCopyWith<$Res>(_value.savedCandidate!, (value) {
      return _then(_value.copyWith(savedCandidate: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CandidateFormStateImplCopyWith<$Res>
    implements $CandidateFormStateCopyWith<$Res> {
  factory _$$CandidateFormStateImplCopyWith(_$CandidateFormStateImpl value,
          $Res Function(_$CandidateFormStateImpl) then) =
      __$$CandidateFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading, String? errorMessage, CandidateEntity? savedCandidate});

  @override
  $CandidateEntityCopyWith<$Res>? get savedCandidate;
}

/// @nodoc
class __$$CandidateFormStateImplCopyWithImpl<$Res>
    extends _$CandidateFormStateCopyWithImpl<$Res, _$CandidateFormStateImpl>
    implements _$$CandidateFormStateImplCopyWith<$Res> {
  __$$CandidateFormStateImplCopyWithImpl(_$CandidateFormStateImpl _value,
      $Res Function(_$CandidateFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CandidateFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? savedCandidate = freezed,
  }) {
    return _then(_$CandidateFormStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      savedCandidate: freezed == savedCandidate
          ? _value.savedCandidate
          : savedCandidate // ignore: cast_nullable_to_non_nullable
              as CandidateEntity?,
    ));
  }
}

/// @nodoc

class _$CandidateFormStateImpl implements _CandidateFormState {
  const _$CandidateFormStateImpl(
      {this.isLoading = false, this.errorMessage, this.savedCandidate});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  final CandidateEntity? savedCandidate;

  @override
  String toString() {
    return 'CandidateFormState(isLoading: $isLoading, errorMessage: $errorMessage, savedCandidate: $savedCandidate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CandidateFormStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.savedCandidate, savedCandidate) ||
                other.savedCandidate == savedCandidate));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, errorMessage, savedCandidate);

  /// Create a copy of CandidateFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CandidateFormStateImplCopyWith<_$CandidateFormStateImpl> get copyWith =>
      __$$CandidateFormStateImplCopyWithImpl<_$CandidateFormStateImpl>(
          this, _$identity);
}

abstract class _CandidateFormState implements CandidateFormState {
  const factory _CandidateFormState(
      {final bool isLoading,
      final String? errorMessage,
      final CandidateEntity? savedCandidate}) = _$CandidateFormStateImpl;

  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  CandidateEntity? get savedCandidate;

  /// Create a copy of CandidateFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CandidateFormStateImplCopyWith<_$CandidateFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
