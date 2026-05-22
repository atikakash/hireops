import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_entity.freezed.dart';

enum UserRole { admin, recruiter }

@freezed
class AuthEntity with _$AuthEntity {
  const factory AuthEntity({
    required String id,
    required String email,
    required String name,
    required UserRole role,
    required String accessToken,
    String? refreshToken,
    String? companyId,
    String? companyName,
    String? companySlug,
    String? avatarUrl,
  }) = _AuthEntity;
}
