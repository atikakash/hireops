import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/notification_settings_model.dart';
import '../repositories/notification_repository.dart';

// ── Events ────────────────────────────────────────────────────────────────────
abstract class NotificationEvent extends Equatable {
  @override List<Object?> get props => [];
}

class NotificationSettingsRequested extends NotificationEvent {}

class NotificationSettingsUpdated extends NotificationEvent {
  final NotificationSettings settings;
  const NotificationSettingsUpdated(this.settings);
  @override List<Object?> get props => [settings];
}

// ── States ────────────────────────────────────────────────────────────────────
abstract class NotificationState extends Equatable {
  @override List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}

class NotificationSettingsLoaded extends NotificationState {
  final NotificationSettings settings;
  const NotificationSettingsLoaded(this.settings);
  @override List<Object?> get props => [settings];
}

class NotificationSettingsSaved extends NotificationState {
  final NotificationSettings settings;
  const NotificationSettingsSaved(this.settings);
  @override List<Object?> get props => [settings];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override List<Object?> get props => [message];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final _repo = NotificationRepository();

  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationSettingsRequested>(_onLoad);
    on<NotificationSettingsUpdated>(_onUpdate);
  }

  Future<void> _onLoad(NotificationSettingsRequested event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final settings = await _repo.getSettings();
      emit(NotificationSettingsLoaded(settings));
    } on NotificationException catch (e) {
      emit(NotificationError(e.message));
    } catch (_) {
      emit(const NotificationError('Failed to load notification settings.'));
    }
  }

  Future<void> _onUpdate(NotificationSettingsUpdated event, Emitter<NotificationState> emit) async {
    // Optimistic update — show new state immediately
    emit(NotificationSettingsLoaded(event.settings));
    try {
      final saved = await _repo.updateSettings(event.settings);
      emit(NotificationSettingsSaved(saved));
    } on NotificationException catch (e) {
      emit(NotificationError(e.message));
    }
  }
}
