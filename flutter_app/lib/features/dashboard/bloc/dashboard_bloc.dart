import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/dashboard_model.dart';
import '../repositories/dashboard_repository.dart';

// ── Events ────────────────────────────────────────────────────────────────────
abstract class DashboardEvent extends Equatable {
  @override List<Object?> get props => [];
}

class DashboardLoadRequested extends DashboardEvent {}
class DashboardRefreshRequested extends DashboardEvent {}

// ── States ────────────────────────────────────────────────────────────────────
abstract class DashboardState extends Equatable {
  @override List<Object?> get props => [];
}

class DashboardInitial  extends DashboardState {}
class DashboardLoading  extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardData data;
  const DashboardLoaded(this.data);
  @override List<Object?> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override List<Object?> get props => [message];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final _repo = DashboardRepository();

  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardLoadRequested>(_onLoad);
    on<DashboardRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(DashboardLoadRequested event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final data = await _repo.getDashboard();
      emit(DashboardLoaded(data));
    } on DashboardException catch (e) {
      emit(DashboardError(e.message));
    } catch (_) {
      emit(const DashboardError('Failed to load dashboard.'));
    }
  }

  Future<void> _onRefresh(DashboardRefreshRequested event, Emitter<DashboardState> emit) async {
    // Keep showing current data while refreshing
    try {
      final data = await _repo.getDashboard();
      emit(DashboardLoaded(data));
    } on DashboardException catch (e) {
      emit(DashboardError(e.message));
    }
  }
}
