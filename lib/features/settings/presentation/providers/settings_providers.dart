import 'dart:async';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hireops/core/constants/api_constants.dart';
import 'package:hireops/core/errors/app_exception_utils.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/core/network/dio_client.dart';
import 'package:hireops/shared/providers/core_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';
part 'settings_providers.freezed.dart';

@freezed
class CompanyProfile with _$CompanyProfile {
  const factory CompanyProfile({
    required String id,
    required String name,
    required String slug,
    required String email,
    String? phone,
    String? website,
    String? industry,
    String? logoUrl,
    String? address,
    @Default(true) bool isActive,
    DateTime? createdAt,
    @Default([]) List<TeamMember> members,
  }) = _CompanyProfile;
}

@freezed
class TeamMember with _$TeamMember {
  const factory TeamMember({
    required String id,
    required String name,
    required String email,
    required String role,
    String? avatarUrl,
  }) = _TeamMember;
}

class SettingsRemoteDataSource {
  final DioClient _client;

  const SettingsRemoteDataSource(this._client);

  Dio get _dio => _client.client;

  Future<Map<String, dynamic>> getCompanyProfile() async {
    final response = await _dio.get(ApiConstants.companyProfile);
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> updateCompanyProfile({
    required String name,
    required String email,
    String? phone,
    String? website,
    String? industry,
    String? address,
  }) async {
    final response = await _dio.put(
      ApiConstants.companyProfile,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'website': website,
        'industry': industry,
        'address': address,
      },
    );

    return _asMap(response.data);
  }

  Future<List<Map<String, dynamic>>> getTeamMembers() async {
    try {
      final response = await _dio.get(ApiConstants.teamMembers);
      return _extractMapList(response.data);
    } on AppException catch (e) {
      if (e.statusCode == 404) {
        return const [];
      }
      rethrow;
    }
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(key.toString(), item),
      );
    }

    return const <String, dynamic>{};
  }

  List<Map<String, dynamic>> _extractMapList(dynamic value) {
    final payload = _asMap(value);
    final data = payload['data'];

    if (data is List) {
      return data.map(_asMap).toList();
    }

    if (data is Map<String, dynamic>) {
      final members = data['members'];
      if (members is List) {
        return members.map(_asMap).toList();
      }
    }

    if (payload['members'] is List) {
      return (payload['members'] as List).map(_asMap).toList();
    }

    if (value is List) {
      return value.map(_asMap).toList();
    }

    return const [];
  }
}

@riverpod
SettingsRemoteDataSource settingsRemoteDataSource(Ref ref) =>
    SettingsRemoteDataSource(ref.watch(dioClientProvider));

@freezed
class CompanyProfileState with _$CompanyProfileState {
  const factory CompanyProfileState({
    CompanyProfile? profile,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? errorMessage,
    String? successMessage,
    Map<String, String>? fieldErrors,
  }) = _CompanyProfileState;
}

@riverpod
class CompanyProfileNotifier extends _$CompanyProfileNotifier {
  @override
  CompanyProfileState build() {
    Future.microtask(_load);
    return const CompanyProfileState(isLoading: true);
  }

  Future<void> reload() => _load();

  Future<void> _load() async {
    final currentProfile = state.profile;
    final currentMembers = currentProfile?.members ?? const <TeamMember>[];

    state = CompanyProfileState(
      profile: currentProfile == null
          ? null
          : currentProfile.copyWith(members: currentMembers),
      isLoading: true,
    );

    final dataSource = ref.read(settingsRemoteDataSourceProvider);

    try {
      final companyResponse = await dataSource.getCompanyProfile();
      final teamMembers = await dataSource.getTeamMembers();
      final profile = _mapCompanyProfile(companyResponse, teamMembers);

      state = state.copyWith(
        isLoading: false,
        profile: profile,
        errorMessage: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
        fieldErrors: _extractFieldErrors(e.data),
      );
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: appException.message,
          fieldErrors: _extractFieldErrors(appException.data),
        );
        return;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load company profile.',
      );
    }
  }

  Future<bool> save({
    required String name,
    required String email,
    String? phone,
    String? website,
    String? industry,
    String? address,
  }) async {
    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
      fieldErrors: null,
    );

    final dataSource = ref.read(settingsRemoteDataSourceProvider);

    try {
      final response = await dataSource.updateCompanyProfile(
        name: name,
        email: email,
        phone: phone,
        website: website,
        industry: industry,
        address: address,
      );

      final updated = _mapCompanyProfile(
        response,
        state.profile?.members
                .map(
                  (member) => {
                    'id': member.id,
                    'name': member.name,
                    'email': member.email,
                    'role': member.role,
                    'avatarUrl': member.avatarUrl,
                  },
                )
                .toList() ??
            const [],
      );

      state = state.copyWith(
        isSaving: false,
        profile: updated,
        successMessage: 'Company profile updated successfully.',
      );

      return true;
    } on AppException catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.message,
        fieldErrors: _extractFieldErrors(e.data),
      );
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: appException.message,
          fieldErrors: _extractFieldErrors(appException.data),
        );
        return false;
      }
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save company profile.',
      );
    }

    return false;
  }

  void clearMessages() {
    state = state.copyWith(
      errorMessage: null,
      successMessage: null,
      fieldErrors: null,
    );
  }

  CompanyProfile _mapCompanyProfile(
    Map<String, dynamic> rawResponse,
    List<Map<String, dynamic>> membersRaw,
  ) {
    final payload = _extractPayload(rawResponse);
    final company = _extractCompany(payload);
    final members = _extractMembers(payload, membersRaw);

    return CompanyProfile(
      id: '${company['id'] ?? ''}',
      name: '${company['name'] ?? ''}',
      slug: '${company['slug'] ?? ''}',
      email: '${company['email'] ?? ''}',
      phone: _nullableString(company['phone']),
      website: _nullableString(company['website']),
      industry: _nullableString(company['industry']),
      logoUrl: _nullableString(company['logo']),
      address: _nullableString(company['address']),
      isActive: _toBool(company['is_active']),
      createdAt: DateTime.tryParse('${company['created_at'] ?? ''}'),
      members: members,
    );
  }

  Map<String, dynamic> _extractPayload(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return response;
  }

  Map<String, dynamic> _extractCompany(Map<String, dynamic> payload) {
    final company = payload['company'];
    if (company is Map<String, dynamic>) {
      return company;
    }
    return payload;
  }

  List<TeamMember> _extractMembers(
    Map<String, dynamic> payload,
    List<Map<String, dynamic>> fallbackMembers,
  ) {
    final membersValue = payload['members'];
    final rawMembers = switch (membersValue) {
      List() => membersValue.map((member) => _toMap(member)).toList(),
      _ => fallbackMembers,
    };

    return rawMembers
        .map(
          (member) => TeamMember(
            id: '${member['id'] ?? ''}',
            name: '${member['name'] ?? ''}',
            email: '${member['email'] ?? ''}',
            role: '${member['role'] ?? 'member'}',
            avatarUrl: _nullableString(member['avatarUrl'] ?? member['avatar']),
          ),
        )
        .where(
          (member) => member.name.isNotEmpty && member.email.isNotEmpty,
        )
        .toList();
  }

  Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(key.toString(), item),
      );
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

  bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value == 1;
    }

    final normalized = value?.toString().toLowerCase();
    return normalized == '1' || normalized == 'true';
  }

  Map<String, String>? _extractFieldErrors(Map<String, dynamic>? data) {
    final rawErrors = data?['errors'];
    if (rawErrors is! Map) {
      return null;
    }

    final parsed = <String, String>{};

    for (final entry in rawErrors.entries) {
      final key = entry.key.toString();
      final value = entry.value;

      if (value is List && value.isNotEmpty) {
        parsed[key] = value.first.toString();
      } else if (value != null) {
        parsed[key] = value.toString();
      }
    }

    return parsed.isEmpty ? null : parsed;
  }
}
