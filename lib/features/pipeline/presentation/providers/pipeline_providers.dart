import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hireops/core/constants/api_constants.dart';
import 'package:hireops/core/errors/app_exception_utils.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/core/network/dio_client.dart';
import 'package:hireops/features/candidates/data/models/candidate_model.dart';
import 'package:hireops/features/candidates/domain/entities/candidate_entity.dart';
import 'package:hireops/features/pipeline/domain/entities/pipeline_entity.dart';
import 'package:hireops/shared/providers/core_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pipeline_providers.freezed.dart';
part 'pipeline_providers.g.dart';

// â”€â”€ Datasource â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class PipelineRemoteDataSource {
  final DioClient _client;
  const PipelineRemoteDataSource(this._client);
  Dio get _dio => _client.client;

  Future<List<Map<String, dynamic>>> getStages() async {
    final res = await _dio.get(ApiConstants.pipelineStages);
    final payload = _asMap(res.data);
    final data = payload['data'];

    if (data is List) {
      return data.map(_asMap).toList();
    }

    if (data is Map<String, dynamic>) {
      final stages = data['stages'] ?? data['items'];
      if (stages is List) {
        return stages.map(_asMap).toList();
      }
    }

    if (payload['stages'] is List) {
      return (payload['stages'] as List).map(_asMap).toList();
    }

    if (res.data is List) {
      return (res.data as List).map(_asMap).toList();
    }

    return const [];
  }

  Future<void> moveCandidate(String candidateId, String stage) async {
    await _dio.put(
      ApiConstants.movePipelineCandidate(candidateId),
      data: {'stage': stage},
    );
  }

  Future<void> renameStage(String stageId, String name) async {
    await _dio.put('/api/pipeline/stages/$stageId', data: {'name': name});
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
}

// â”€â”€ Repository â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class PipelineRepositoryImpl implements PipelineRepository {
  final PipelineRemoteDataSource _ds;
  const PipelineRepositoryImpl(this._ds);

  static const _defaultStages = [
    PipelineStage.applied,
    PipelineStage.shortlisted,
    PipelineStage.interview,
    PipelineStage.hired,
    PipelineStage.rejected,
  ];

  static const _defaultNames = {
    PipelineStage.applied: 'Applied',
    PipelineStage.shortlisted: 'Shortlisted',
    PipelineStage.interview: 'Interview',
    PipelineStage.hired: 'Hired',
    PipelineStage.rejected: 'Rejected',
  };

  @override
  Future<(List<PipelineStageConfig>, Failure?)> getBoard() async {
    try {
      final raw = await _ds.getStages();
      // Parse API response: each stage has name + list of candidates
      final stages = <PipelineStageConfig>[];
      for (int i = 0; i < _defaultStages.length; i++) {
        final s = _defaultStages[i];
        final match = raw.cast<Map<String, dynamic>?>().firstWhere(
              (r) => r != null && r['stage'] == s.name,
              orElse: () => null,
            );
        final candidates = (match?['candidates'] as List? ?? [])
            .map((c) =>
                CandidateModel.fromJson(c as Map<String, dynamic>).toEntity())
            .toList();
        stages.add(PipelineStageConfig(
          id: match?['id'] as String? ?? s.name,
          name: match?['name'] as String? ?? _defaultNames[s]!,
          stage: s,
          order: i,
          candidates: candidates,
        ));
      }
      return (stages, null);
    } on AppException catch (e) {
      return (
        <PipelineStageConfig>[],
        e is NoInternetException
            ? Failure.noInternet(message: e.message)
            : Failure.network(message: e.message),
      );
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (
          <PipelineStageConfig>[],
          appException is NoInternetException
              ? Failure.noInternet(message: appException.message)
              : Failure.network(message: appException.message),
        );
      }
      return (
        <PipelineStageConfig>[],
        Failure.unknown(message: e.toString()),
      );
    }
  }

  @override
  Future<(bool, Failure?)> moveCandidate(
      String candidateId, PipelineStage toStage) async {
    try {
      await _ds.moveCandidate(candidateId, toStage.name);
      return (true, null);
    } on AppException catch (e) {
      return (
        false,
        e is NoInternetException
            ? Failure.noInternet(message: e.message)
            : Failure.network(message: e.message),
      );
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (
          false,
          appException is NoInternetException
              ? Failure.noInternet(message: appException.message)
              : Failure.network(message: appException.message),
        );
      }
      return (false, Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<(bool, Failure?)> renameStage(String stageId, String newName) async {
    try {
      await _ds.renameStage(stageId, newName);
      return (true, null);
    } on AppException catch (e) {
      return (
        false,
        e is NoInternetException
            ? Failure.noInternet(message: e.message)
            : Failure.network(message: e.message),
      );
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (
          false,
          appException is NoInternetException
              ? Failure.noInternet(message: appException.message)
              : Failure.network(message: appException.message),
        );
      }
      return (false, Failure.unknown(message: e.toString()));
    }
  }
}

// â”€â”€ Providers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

@riverpod
PipelineRemoteDataSource pipelineRemoteDataSource(Ref ref) =>
    PipelineRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
PipelineRepository pipelineRepository(Ref ref) =>
    PipelineRepositoryImpl(ref.watch(pipelineRemoteDataSourceProvider));

@riverpod
Future<List<PipelineStageConfig>> pipelineBoard(Ref ref) async {
  final repo = ref.watch(pipelineRepositoryProvider);
  final (stages, failure) = await repo.getBoard();
  if (failure != null) {
    return Future.error(failure, StackTrace.current);
  }
  return stages;
}

// â”€â”€ Move State â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

@freezed
class PipelineMoveState with _$PipelineMoveState {
  const factory PipelineMoveState({
    @Default(false) bool isMoving,
    String? errorMessage,
    String? lastMovedCandidateId,
  }) = _PipelineMoveState;
}

@riverpod
class PipelineMoveNotifier extends _$PipelineMoveNotifier {
  @override
  PipelineMoveState build() => const PipelineMoveState();

  Future<bool> move(
      String candidateId, PipelineStage toStage, BuildContext context) async {
    // Confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Move Candidate?'),
        content: Text(
            'Move to ${toStage.name[0].toUpperCase()}${toStage.name.substring(1)}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Move')),
        ],
      ),
    );
    if (confirmed != true) return false;

    state = state.copyWith(isMoving: true, errorMessage: null);
    final repo = ref.read(pipelineRepositoryProvider);
    final (ok, failure) = await repo.moveCandidate(candidateId, toStage);

    if (failure != null) {
      state = state.copyWith(
          isMoving: false,
          errorMessage: failure.when(
            network: (m, _) => m,
            unauthorized: (m) => m,
            forbidden: (m) => m,
            notFound: (m) => m,
            validation: (m, _) => m,
            server: (m) => m,
            cache: (m) => m,
            fileValidation: (m) => m,
            noInternet: (m) => m,
            unknown: (m) => m,
          ));
      return false;
    }

    state = state.copyWith(isMoving: false, lastMovedCandidateId: candidateId);
    ref.invalidate(pipelineBoardProvider);
    return ok;
  }
}
