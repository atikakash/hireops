// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pipeline_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PipelineStageConfig {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  PipelineStage get stage => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  List<CandidateEntity> get candidates => throw _privateConstructorUsedError;

  /// Create a copy of PipelineStageConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PipelineStageConfigCopyWith<PipelineStageConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PipelineStageConfigCopyWith<$Res> {
  factory $PipelineStageConfigCopyWith(
          PipelineStageConfig value, $Res Function(PipelineStageConfig) then) =
      _$PipelineStageConfigCopyWithImpl<$Res, PipelineStageConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      PipelineStage stage,
      int order,
      List<CandidateEntity> candidates});
}

/// @nodoc
class _$PipelineStageConfigCopyWithImpl<$Res, $Val extends PipelineStageConfig>
    implements $PipelineStageConfigCopyWith<$Res> {
  _$PipelineStageConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PipelineStageConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? stage = null,
    Object? order = null,
    Object? candidates = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as PipelineStage,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      candidates: null == candidates
          ? _value.candidates
          : candidates // ignore: cast_nullable_to_non_nullable
              as List<CandidateEntity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PipelineStageConfigImplCopyWith<$Res>
    implements $PipelineStageConfigCopyWith<$Res> {
  factory _$$PipelineStageConfigImplCopyWith(_$PipelineStageConfigImpl value,
          $Res Function(_$PipelineStageConfigImpl) then) =
      __$$PipelineStageConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      PipelineStage stage,
      int order,
      List<CandidateEntity> candidates});
}

/// @nodoc
class __$$PipelineStageConfigImplCopyWithImpl<$Res>
    extends _$PipelineStageConfigCopyWithImpl<$Res, _$PipelineStageConfigImpl>
    implements _$$PipelineStageConfigImplCopyWith<$Res> {
  __$$PipelineStageConfigImplCopyWithImpl(_$PipelineStageConfigImpl _value,
      $Res Function(_$PipelineStageConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of PipelineStageConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? stage = null,
    Object? order = null,
    Object? candidates = null,
  }) {
    return _then(_$PipelineStageConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as PipelineStage,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      candidates: null == candidates
          ? _value._candidates
          : candidates // ignore: cast_nullable_to_non_nullable
              as List<CandidateEntity>,
    ));
  }
}

/// @nodoc

class _$PipelineStageConfigImpl implements _PipelineStageConfig {
  const _$PipelineStageConfigImpl(
      {required this.id,
      required this.name,
      required this.stage,
      required this.order,
      final List<CandidateEntity> candidates = const []})
      : _candidates = candidates;

  @override
  final String id;
  @override
  final String name;
  @override
  final PipelineStage stage;
  @override
  final int order;
  final List<CandidateEntity> _candidates;
  @override
  @JsonKey()
  List<CandidateEntity> get candidates {
    if (_candidates is EqualUnmodifiableListView) return _candidates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_candidates);
  }

  @override
  String toString() {
    return 'PipelineStageConfig(id: $id, name: $name, stage: $stage, order: $order, candidates: $candidates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PipelineStageConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality()
                .equals(other._candidates, _candidates));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, stage, order,
      const DeepCollectionEquality().hash(_candidates));

  /// Create a copy of PipelineStageConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PipelineStageConfigImplCopyWith<_$PipelineStageConfigImpl> get copyWith =>
      __$$PipelineStageConfigImplCopyWithImpl<_$PipelineStageConfigImpl>(
          this, _$identity);
}

abstract class _PipelineStageConfig implements PipelineStageConfig {
  const factory _PipelineStageConfig(
      {required final String id,
      required final String name,
      required final PipelineStage stage,
      required final int order,
      final List<CandidateEntity> candidates}) = _$PipelineStageConfigImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  PipelineStage get stage;
  @override
  int get order;
  @override
  List<CandidateEntity> get candidates;

  /// Create a copy of PipelineStageConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PipelineStageConfigImplCopyWith<_$PipelineStageConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
