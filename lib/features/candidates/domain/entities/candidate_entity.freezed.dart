// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'candidate_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CandidateEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  int get experienceYears => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<CandidateNote> get notes => throw _privateConstructorUsedError;
  List<StageHistoryEntry> get stageHistory =>
      throw _privateConstructorUsedError;
  PipelineStage get currentStage => throw _privateConstructorUsedError;
  String? get cvUrl => throw _privateConstructorUsedError;
  String? get cvId => throw _privateConstructorUsedError;
  String? get jobId => throw _privateConstructorUsedError;
  String? get jobTitle => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of CandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CandidateEntityCopyWith<CandidateEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandidateEntityCopyWith<$Res> {
  factory $CandidateEntityCopyWith(
          CandidateEntity value, $Res Function(CandidateEntity) then) =
      _$CandidateEntityCopyWithImpl<$Res, CandidateEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      String? phone,
      int experienceYears,
      List<String> skills,
      List<String> tags,
      List<CandidateNote> notes,
      List<StageHistoryEntry> stageHistory,
      PipelineStage currentStage,
      String? cvUrl,
      String? cvId,
      String? jobId,
      String? jobTitle,
      String? avatarUrl,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$CandidateEntityCopyWithImpl<$Res, $Val extends CandidateEntity>
    implements $CandidateEntityCopyWith<$Res> {
  _$CandidateEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CandidateEntity
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
              as List<CandidateNote>,
      stageHistory: null == stageHistory
          ? _value.stageHistory
          : stageHistory // ignore: cast_nullable_to_non_nullable
              as List<StageHistoryEntry>,
      currentStage: null == currentStage
          ? _value.currentStage
          : currentStage // ignore: cast_nullable_to_non_nullable
              as PipelineStage,
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
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CandidateEntityImplCopyWith<$Res>
    implements $CandidateEntityCopyWith<$Res> {
  factory _$$CandidateEntityImplCopyWith(_$CandidateEntityImpl value,
          $Res Function(_$CandidateEntityImpl) then) =
      __$$CandidateEntityImplCopyWithImpl<$Res>;
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
      List<CandidateNote> notes,
      List<StageHistoryEntry> stageHistory,
      PipelineStage currentStage,
      String? cvUrl,
      String? cvId,
      String? jobId,
      String? jobTitle,
      String? avatarUrl,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$CandidateEntityImplCopyWithImpl<$Res>
    extends _$CandidateEntityCopyWithImpl<$Res, _$CandidateEntityImpl>
    implements _$$CandidateEntityImplCopyWith<$Res> {
  __$$CandidateEntityImplCopyWithImpl(
      _$CandidateEntityImpl _value, $Res Function(_$CandidateEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of CandidateEntity
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
    return _then(_$CandidateEntityImpl(
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
              as List<CandidateNote>,
      stageHistory: null == stageHistory
          ? _value._stageHistory
          : stageHistory // ignore: cast_nullable_to_non_nullable
              as List<StageHistoryEntry>,
      currentStage: null == currentStage
          ? _value.currentStage
          : currentStage // ignore: cast_nullable_to_non_nullable
              as PipelineStage,
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
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CandidateEntityImpl implements _CandidateEntity {
  const _$CandidateEntityImpl(
      {required this.id,
      required this.name,
      required this.email,
      this.phone,
      this.experienceYears = 0,
      final List<String> skills = const [],
      final List<String> tags = const [],
      final List<CandidateNote> notes = const [],
      final List<StageHistoryEntry> stageHistory = const [],
      required this.currentStage,
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

  final List<CandidateNote> _notes;
  @override
  @JsonKey()
  List<CandidateNote> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  final List<StageHistoryEntry> _stageHistory;
  @override
  @JsonKey()
  List<StageHistoryEntry> get stageHistory {
    if (_stageHistory is EqualUnmodifiableListView) return _stageHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stageHistory);
  }

  @override
  final PipelineStage currentStage;
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
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CandidateEntity(id: $id, name: $name, email: $email, phone: $phone, experienceYears: $experienceYears, skills: $skills, tags: $tags, notes: $notes, stageHistory: $stageHistory, currentStage: $currentStage, cvUrl: $cvUrl, cvId: $cvId, jobId: $jobId, jobTitle: $jobTitle, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CandidateEntityImpl &&
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

  /// Create a copy of CandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CandidateEntityImplCopyWith<_$CandidateEntityImpl> get copyWith =>
      __$$CandidateEntityImplCopyWithImpl<_$CandidateEntityImpl>(
          this, _$identity);
}

abstract class _CandidateEntity implements CandidateEntity {
  const factory _CandidateEntity(
      {required final String id,
      required final String name,
      required final String email,
      final String? phone,
      final int experienceYears,
      final List<String> skills,
      final List<String> tags,
      final List<CandidateNote> notes,
      final List<StageHistoryEntry> stageHistory,
      required final PipelineStage currentStage,
      final String? cvUrl,
      final String? cvId,
      final String? jobId,
      final String? jobTitle,
      final String? avatarUrl,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$CandidateEntityImpl;

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
  List<CandidateNote> get notes;
  @override
  List<StageHistoryEntry> get stageHistory;
  @override
  PipelineStage get currentStage;
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
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CandidateEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CandidateEntityImplCopyWith<_$CandidateEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CandidateNote {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of CandidateNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CandidateNoteCopyWith<CandidateNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandidateNoteCopyWith<$Res> {
  factory $CandidateNoteCopyWith(
          CandidateNote value, $Res Function(CandidateNote) then) =
      _$CandidateNoteCopyWithImpl<$Res, CandidateNote>;
  @useResult
  $Res call(
      {String id,
      String content,
      String authorName,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$CandidateNoteCopyWithImpl<$Res, $Val extends CandidateNote>
    implements $CandidateNoteCopyWith<$Res> {
  _$CandidateNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CandidateNote
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
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CandidateNoteImplCopyWith<$Res>
    implements $CandidateNoteCopyWith<$Res> {
  factory _$$CandidateNoteImplCopyWith(
          _$CandidateNoteImpl value, $Res Function(_$CandidateNoteImpl) then) =
      __$$CandidateNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String content,
      String authorName,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$CandidateNoteImplCopyWithImpl<$Res>
    extends _$CandidateNoteCopyWithImpl<$Res, _$CandidateNoteImpl>
    implements _$$CandidateNoteImplCopyWith<$Res> {
  __$$CandidateNoteImplCopyWithImpl(
      _$CandidateNoteImpl _value, $Res Function(_$CandidateNoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of CandidateNote
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
    return _then(_$CandidateNoteImpl(
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
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CandidateNoteImpl implements _CandidateNote {
  const _$CandidateNoteImpl(
      {required this.id,
      required this.content,
      required this.authorName,
      required this.createdAt,
      this.updatedAt});

  @override
  final String id;
  @override
  final String content;
  @override
  final String authorName;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CandidateNote(id: $id, content: $content, authorName: $authorName, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CandidateNoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, content, authorName, createdAt, updatedAt);

  /// Create a copy of CandidateNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CandidateNoteImplCopyWith<_$CandidateNoteImpl> get copyWith =>
      __$$CandidateNoteImplCopyWithImpl<_$CandidateNoteImpl>(this, _$identity);
}

abstract class _CandidateNote implements CandidateNote {
  const factory _CandidateNote(
      {required final String id,
      required final String content,
      required final String authorName,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$CandidateNoteImpl;

  @override
  String get id;
  @override
  String get content;
  @override
  String get authorName;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CandidateNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CandidateNoteImplCopyWith<_$CandidateNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StageHistoryEntry {
  String get id => throw _privateConstructorUsedError;
  PipelineStage get stage => throw _privateConstructorUsedError;
  String get movedByName => throw _privateConstructorUsedError;
  DateTime get movedAt => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Create a copy of StageHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StageHistoryEntryCopyWith<StageHistoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StageHistoryEntryCopyWith<$Res> {
  factory $StageHistoryEntryCopyWith(
          StageHistoryEntry value, $Res Function(StageHistoryEntry) then) =
      _$StageHistoryEntryCopyWithImpl<$Res, StageHistoryEntry>;
  @useResult
  $Res call(
      {String id,
      PipelineStage stage,
      String movedByName,
      DateTime movedAt,
      String? note});
}

/// @nodoc
class _$StageHistoryEntryCopyWithImpl<$Res, $Val extends StageHistoryEntry>
    implements $StageHistoryEntryCopyWith<$Res> {
  _$StageHistoryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StageHistoryEntry
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
              as PipelineStage,
      movedByName: null == movedByName
          ? _value.movedByName
          : movedByName // ignore: cast_nullable_to_non_nullable
              as String,
      movedAt: null == movedAt
          ? _value.movedAt
          : movedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StageHistoryEntryImplCopyWith<$Res>
    implements $StageHistoryEntryCopyWith<$Res> {
  factory _$$StageHistoryEntryImplCopyWith(_$StageHistoryEntryImpl value,
          $Res Function(_$StageHistoryEntryImpl) then) =
      __$$StageHistoryEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      PipelineStage stage,
      String movedByName,
      DateTime movedAt,
      String? note});
}

/// @nodoc
class __$$StageHistoryEntryImplCopyWithImpl<$Res>
    extends _$StageHistoryEntryCopyWithImpl<$Res, _$StageHistoryEntryImpl>
    implements _$$StageHistoryEntryImplCopyWith<$Res> {
  __$$StageHistoryEntryImplCopyWithImpl(_$StageHistoryEntryImpl _value,
      $Res Function(_$StageHistoryEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of StageHistoryEntry
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
    return _then(_$StageHistoryEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as PipelineStage,
      movedByName: null == movedByName
          ? _value.movedByName
          : movedByName // ignore: cast_nullable_to_non_nullable
              as String,
      movedAt: null == movedAt
          ? _value.movedAt
          : movedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$StageHistoryEntryImpl implements _StageHistoryEntry {
  const _$StageHistoryEntryImpl(
      {required this.id,
      required this.stage,
      required this.movedByName,
      required this.movedAt,
      this.note});

  @override
  final String id;
  @override
  final PipelineStage stage;
  @override
  final String movedByName;
  @override
  final DateTime movedAt;
  @override
  final String? note;

  @override
  String toString() {
    return 'StageHistoryEntry(id: $id, stage: $stage, movedByName: $movedByName, movedAt: $movedAt, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StageHistoryEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.movedByName, movedByName) ||
                other.movedByName == movedByName) &&
            (identical(other.movedAt, movedAt) || other.movedAt == movedAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, stage, movedByName, movedAt, note);

  /// Create a copy of StageHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StageHistoryEntryImplCopyWith<_$StageHistoryEntryImpl> get copyWith =>
      __$$StageHistoryEntryImplCopyWithImpl<_$StageHistoryEntryImpl>(
          this, _$identity);
}

abstract class _StageHistoryEntry implements StageHistoryEntry {
  const factory _StageHistoryEntry(
      {required final String id,
      required final PipelineStage stage,
      required final String movedByName,
      required final DateTime movedAt,
      final String? note}) = _$StageHistoryEntryImpl;

  @override
  String get id;
  @override
  PipelineStage get stage;
  @override
  String get movedByName;
  @override
  DateTime get movedAt;
  @override
  String? get note;

  /// Create a copy of StageHistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StageHistoryEntryImplCopyWith<_$StageHistoryEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
