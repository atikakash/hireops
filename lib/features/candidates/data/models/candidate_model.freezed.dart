// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'candidate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CandidateModel _$CandidateModelFromJson(Map<String, dynamic> json) {
  return _CandidateModel.fromJson(json);
}

/// @nodoc
mixin _$CandidateModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  int get experienceYears => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<NoteModel> get notes => throw _privateConstructorUsedError;
  List<StageHistoryModel> get stageHistory =>
      throw _privateConstructorUsedError;
  String get currentStage => throw _privateConstructorUsedError;
  String? get cvUrl => throw _privateConstructorUsedError;
  String? get cvId => throw _privateConstructorUsedError;
  String? get jobId => throw _privateConstructorUsedError;
  String? get jobTitle => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CandidateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CandidateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CandidateModelCopyWith<CandidateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandidateModelCopyWith<$Res> {
  factory $CandidateModelCopyWith(
          CandidateModel value, $Res Function(CandidateModel) then) =
      _$CandidateModelCopyWithImpl<$Res, CandidateModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      String? phone,
      int experienceYears,
      List<String> skills,
      List<String> tags,
      List<NoteModel> notes,
      List<StageHistoryModel> stageHistory,
      String currentStage,
      String? cvUrl,
      String? cvId,
      String? jobId,
      String? jobTitle,
      String? avatarUrl,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class _$CandidateModelCopyWithImpl<$Res, $Val extends CandidateModel>
    implements $CandidateModelCopyWith<$Res> {
  _$CandidateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CandidateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = freezed,
    Object? experienceYears = null,
    Object? skills = null,
    Object? tags = null,
    Object? notes = null,
    Object? stageHistory = null,
    Object? currentStage = null,
    Object? cvUrl = freezed,
    Object? cvId = freezed,
    Object? jobId = freezed,
    Object? jobTitle = freezed,
    Object? avatarUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<NoteModel>,
      stageHistory: null == stageHistory
          ? _value.stageHistory
          : stageHistory // ignore: cast_nullable_to_non_nullable
              as List<StageHistoryModel>,
      currentStage: null == currentStage
          ? _value.currentStage
          : currentStage // ignore: cast_nullable_to_non_nullable
              as String,
      cvUrl: freezed == cvUrl
          ? _value.cvUrl
          : cvUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cvId: freezed == cvId
          ? _value.cvId
          : cvId // ignore: cast_nullable_to_non_nullable
              as String?,
      jobId: freezed == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String?,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CandidateModelImplCopyWith<$Res>
    implements $CandidateModelCopyWith<$Res> {
  factory _$$CandidateModelImplCopyWith(_$CandidateModelImpl value,
          $Res Function(_$CandidateModelImpl) then) =
      __$$CandidateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      String? phone,
      int experienceYears,
      List<String> skills,
      List<String> tags,
      List<NoteModel> notes,
      List<StageHistoryModel> stageHistory,
      String currentStage,
      String? cvUrl,
      String? cvId,
      String? jobId,
      String? jobTitle,
      String? avatarUrl,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class __$$CandidateModelImplCopyWithImpl<$Res>
    extends _$CandidateModelCopyWithImpl<$Res, _$CandidateModelImpl>
    implements _$$CandidateModelImplCopyWith<$Res> {
  __$$CandidateModelImplCopyWithImpl(
      _$CandidateModelImpl _value, $Res Function(_$CandidateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CandidateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = freezed,
    Object? experienceYears = null,
    Object? skills = null,
    Object? tags = null,
    Object? notes = null,
    Object? stageHistory = null,
    Object? currentStage = null,
    Object? cvUrl = freezed,
    Object? cvId = freezed,
    Object? jobId = freezed,
    Object? jobTitle = freezed,
    Object? avatarUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CandidateModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      skills: null == skills
          ? _value._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<NoteModel>,
      stageHistory: null == stageHistory
          ? _value._stageHistory
          : stageHistory // ignore: cast_nullable_to_non_nullable
              as List<StageHistoryModel>,
      currentStage: null == currentStage
          ? _value.currentStage
          : currentStage // ignore: cast_nullable_to_non_nullable
              as String,
      cvUrl: freezed == cvUrl
          ? _value.cvUrl
          : cvUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cvId: freezed == cvId
          ? _value.cvId
          : cvId // ignore: cast_nullable_to_non_nullable
              as String?,
      jobId: freezed == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String?,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CandidateModelImpl implements _CandidateModel {
  const _$CandidateModelImpl(
      {required this.id,
      required this.name,
      required this.email,
      this.phone,
      this.experienceYears = 0,
      final List<String> skills = const [],
      final List<String> tags = const [],
      final List<NoteModel> notes = const [],
      final List<StageHistoryModel> stageHistory = const [],
      this.currentStage = 'applied',
      this.cvUrl,
      this.cvId,
      this.jobId,
      this.jobTitle,
      this.avatarUrl,
      this.createdAt,
      this.updatedAt})
      : _skills = skills,
        _tags = tags,
        _notes = notes,
        _stageHistory = stageHistory;

  factory _$CandidateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CandidateModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String? phone;
  @override
  @JsonKey()
  final int experienceYears;
  final List<String> _skills;
  @override
  @JsonKey()
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<NoteModel> _notes;
  @override
  @JsonKey()
  List<NoteModel> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  final List<StageHistoryModel> _stageHistory;
  @override
  @JsonKey()
  List<StageHistoryModel> get stageHistory {
    if (_stageHistory is EqualUnmodifiableListView) return _stageHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stageHistory);
  }

  @override
  @JsonKey()
  final String currentStage;
  @override
  final String? cvUrl;
  @override
  final String? cvId;
  @override
  final String? jobId;
  @override
  final String? jobTitle;
  @override
  final String? avatarUrl;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'CandidateModel(id: $id, name: $name, email: $email, phone: $phone, experienceYears: $experienceYears, skills: $skills, tags: $tags, notes: $notes, stageHistory: $stageHistory, currentStage: $currentStage, cvUrl: $cvUrl, cvId: $cvId, jobId: $jobId, jobTitle: $jobTitle, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CandidateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            const DeepCollectionEquality()
                .equals(other._stageHistory, _stageHistory) &&
            (identical(other.currentStage, currentStage) ||
                other.currentStage == currentStage) &&
            (identical(other.cvUrl, cvUrl) || other.cvUrl == cvUrl) &&
            (identical(other.cvId, cvId) || other.cvId == cvId) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      email,
      phone,
      experienceYears,
      const DeepCollectionEquality().hash(_skills),
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_notes),
      const DeepCollectionEquality().hash(_stageHistory),
      currentStage,
      cvUrl,
      cvId,
      jobId,
      jobTitle,
      avatarUrl,
      createdAt,
      updatedAt);

  /// Create a copy of CandidateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CandidateModelImplCopyWith<_$CandidateModelImpl> get copyWith =>
      __$$CandidateModelImplCopyWithImpl<_$CandidateModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CandidateModelImplToJson(
      this,
    );
  }
}

abstract class _CandidateModel implements CandidateModel {
  const factory _CandidateModel(
      {required final String id,
      required final String name,
      required final String email,
      final String? phone,
      final int experienceYears,
      final List<String> skills,
      final List<String> tags,
      final List<NoteModel> notes,
      final List<StageHistoryModel> stageHistory,
      final String currentStage,
      final String? cvUrl,
      final String? cvId,
      final String? jobId,
      final String? jobTitle,
      final String? avatarUrl,
      final String? createdAt,
      final String? updatedAt}) = _$CandidateModelImpl;

  factory _CandidateModel.fromJson(Map<String, dynamic> json) =
      _$CandidateModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String? get phone;
  @override
  int get experienceYears;
  @override
  List<String> get skills;
  @override
  List<String> get tags;
  @override
  List<NoteModel> get notes;
  @override
  List<StageHistoryModel> get stageHistory;
  @override
  String get currentStage;
  @override
  String? get cvUrl;
  @override
  String? get cvId;
  @override
  String? get jobId;
  @override
  String? get jobTitle;
  @override
  String? get avatarUrl;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of CandidateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CandidateModelImplCopyWith<_$CandidateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) {
  return _NoteModel.fromJson(json);
}

/// @nodoc
mixin _$NoteModel {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NoteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteModelCopyWith<NoteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteModelCopyWith<$Res> {
  factory $NoteModelCopyWith(NoteModel value, $Res Function(NoteModel) then) =
      _$NoteModelCopyWithImpl<$Res, NoteModel>;
  @useResult
  $Res call(
      {String id,
      String content,
      String authorName,
      String createdAt,
      String? updatedAt});
}

/// @nodoc
class _$NoteModelCopyWithImpl<$Res, $Val extends NoteModel>
    implements $NoteModelCopyWith<$Res> {
  _$NoteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? authorName = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteModelImplCopyWith<$Res>
    implements $NoteModelCopyWith<$Res> {
  factory _$$NoteModelImplCopyWith(
          _$NoteModelImpl value, $Res Function(_$NoteModelImpl) then) =
      __$$NoteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String content,
      String authorName,
      String createdAt,
      String? updatedAt});
}

/// @nodoc
class __$$NoteModelImplCopyWithImpl<$Res>
    extends _$NoteModelCopyWithImpl<$Res, _$NoteModelImpl>
    implements _$$NoteModelImplCopyWith<$Res> {
  __$$NoteModelImplCopyWithImpl(
      _$NoteModelImpl _value, $Res Function(_$NoteModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? authorName = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NoteModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoteModelImpl implements _NoteModel {
  const _$NoteModelImpl(
      {required this.id,
      required this.content,
      required this.authorName,
      required this.createdAt,
      this.updatedAt});

  factory _$NoteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteModelImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final String authorName;
  @override
  final String createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'NoteModel(id: $id, content: $content, authorName: $authorName, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, content, authorName, createdAt, updatedAt);

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteModelImplCopyWith<_$NoteModelImpl> get copyWith =>
      __$$NoteModelImplCopyWithImpl<_$NoteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteModelImplToJson(
      this,
    );
  }
}

abstract class _NoteModel implements NoteModel {
  const factory _NoteModel(
      {required final String id,
      required final String content,
      required final String authorName,
      required final String createdAt,
      final String? updatedAt}) = _$NoteModelImpl;

  factory _NoteModel.fromJson(Map<String, dynamic> json) =
      _$NoteModelImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  String get authorName;
  @override
  String get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteModelImplCopyWith<_$NoteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StageHistoryModel _$StageHistoryModelFromJson(Map<String, dynamic> json) {
  return _StageHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$StageHistoryModel {
  String get id => throw _privateConstructorUsedError;
  String get stage => throw _privateConstructorUsedError;
  String get movedByName => throw _privateConstructorUsedError;
  String get movedAt => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this StageHistoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StageHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StageHistoryModelCopyWith<StageHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StageHistoryModelCopyWith<$Res> {
  factory $StageHistoryModelCopyWith(
          StageHistoryModel value, $Res Function(StageHistoryModel) then) =
      _$StageHistoryModelCopyWithImpl<$Res, StageHistoryModel>;
  @useResult
  $Res call(
      {String id,
      String stage,
      String movedByName,
      String movedAt,
      String? note});
}

/// @nodoc
class _$StageHistoryModelCopyWithImpl<$Res, $Val extends StageHistoryModel>
    implements $StageHistoryModelCopyWith<$Res> {
  _$StageHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StageHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stage = null,
    Object? movedByName = null,
    Object? movedAt = null,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String,
      movedByName: null == movedByName
          ? _value.movedByName
          : movedByName // ignore: cast_nullable_to_non_nullable
              as String,
      movedAt: null == movedAt
          ? _value.movedAt
          : movedAt // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StageHistoryModelImplCopyWith<$Res>
    implements $StageHistoryModelCopyWith<$Res> {
  factory _$$StageHistoryModelImplCopyWith(_$StageHistoryModelImpl value,
          $Res Function(_$StageHistoryModelImpl) then) =
      __$$StageHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String stage,
      String movedByName,
      String movedAt,
      String? note});
}

/// @nodoc
class __$$StageHistoryModelImplCopyWithImpl<$Res>
    extends _$StageHistoryModelCopyWithImpl<$Res, _$StageHistoryModelImpl>
    implements _$$StageHistoryModelImplCopyWith<$Res> {
  __$$StageHistoryModelImplCopyWithImpl(_$StageHistoryModelImpl _value,
      $Res Function(_$StageHistoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StageHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stage = null,
    Object? movedByName = null,
    Object? movedAt = null,
    Object? note = freezed,
  }) {
    return _then(_$StageHistoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String,
      movedByName: null == movedByName
          ? _value.movedByName
          : movedByName // ignore: cast_nullable_to_non_nullable
              as String,
      movedAt: null == movedAt
          ? _value.movedAt
          : movedAt // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StageHistoryModelImpl implements _StageHistoryModel {
  const _$StageHistoryModelImpl(
      {required this.id,
      required this.stage,
      required this.movedByName,
      required this.movedAt,
      this.note});

  factory _$StageHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StageHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String stage;
  @override
  final String movedByName;
  @override
  final String movedAt;
  @override
  final String? note;

  @override
  String toString() {
    return 'StageHistoryModel(id: $id, stage: $stage, movedByName: $movedByName, movedAt: $movedAt, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StageHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.movedByName, movedByName) ||
                other.movedByName == movedByName) &&
            (identical(other.movedAt, movedAt) || other.movedAt == movedAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, stage, movedByName, movedAt, note);

  /// Create a copy of StageHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StageHistoryModelImplCopyWith<_$StageHistoryModelImpl> get copyWith =>
      __$$StageHistoryModelImplCopyWithImpl<_$StageHistoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StageHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _StageHistoryModel implements StageHistoryModel {
  const factory _StageHistoryModel(
      {required final String id,
      required final String stage,
      required final String movedByName,
      required final String movedAt,
      final String? note}) = _$StageHistoryModelImpl;

  factory _StageHistoryModel.fromJson(Map<String, dynamic> json) =
      _$StageHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get stage;
  @override
  String get movedByName;
  @override
  String get movedAt;
  @override
  String? get note;

  /// Create a copy of StageHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StageHistoryModelImplCopyWith<_$StageHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
