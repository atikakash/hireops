// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthModelImpl _$$AuthModelImplFromJson(Map<String, dynamic> json) =>
    _$AuthModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      companyId: json['companyId'] as String?,
      companyName: json['companyName'] as String?,
      companySlug: json['companySlug'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$$AuthModelImplToJson(_$AuthModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': instance.role,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'companySlug': instance.companySlug,
      'avatarUrl': instance.avatarUrl,
    };
