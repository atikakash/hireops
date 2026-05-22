import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hireops/features/auth/domain/entities/auth_entity.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
class AuthModel with _$AuthModel {
  const factory AuthModel({
    required String id,
    required String email,
    required String name,
    required String role,
    required String accessToken,
    String? refreshToken,
    String? companyId,
    String? companyName,
    String? companySlug,
    String? avatarUrl,
  }) = _AuthModel;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  factory AuthModel.fromApiJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    final user = _asMap(data['user']);
    final company = _asMap(data['company']);

    return AuthModel(
      id: '${user['id'] ?? ''}',
      email: '${user['email'] ?? ''}',
      name: '${user['name'] ?? ''}',
      role: '${user['role'] ?? 'recruiter'}',
      accessToken: '${data['token'] ?? ''}',
      refreshToken: _nullableString(data['refreshToken']),
      companyId: _nullableString(company['id']),
      companyName: _nullableString(company['name']),
      companySlug: _nullableString(company['slug']),
      avatarUrl: _nullableString(user['avatar_url'] ?? user['avatarUrl']),
    );
  }
}

extension AuthModelMapper on AuthModel {
  AuthEntity toEntity() => AuthEntity(
        id: id,
        email: email,
        name: name,
        role: role == 'admin' ? UserRole.admin : UserRole.recruiter,
        accessToken: accessToken,
        refreshToken: refreshToken,
        companyId: companyId,
        companyName: companyName,
        companySlug: companySlug,
        avatarUrl: avatarUrl,
      );
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }

  return const <String, dynamic>{};
}

String? _nullableString(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalized = value.toString().trim();
  return normalized.isEmpty ? null : normalized;
}
