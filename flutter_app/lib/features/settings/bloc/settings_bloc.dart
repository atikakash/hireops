import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/settings_model.dart';
import '../repositories/settings_repository.dart';

// ── Events ────────────────────────────────────────────────────────────────────
abstract class SettingsEvent extends Equatable {
  @override List<Object?> get props => [];
}

class SettingsLoadRequested extends SettingsEvent {}

class CompanySettingsUpdateSubmitted extends SettingsEvent {
  final String name, email;
  final String? phone, website, industry, address;
  const CompanySettingsUpdateSubmitted({
    required this.name, required this.email,
    this.phone, this.website, this.industry, this.address,
  });
  @override List<Object?> get props => [name, email];
}

class PipelineStagesUpdateSubmitted extends SettingsEvent {
  final List<PipelineStageSetting> stages;
  const PipelineStagesUpdateSubmitted(this.stages);
  @override List<Object?> get props => [stages];
}

class NotificationSettingsUpdateSubmitted extends SettingsEvent {
  final NotifSettings settings;
  const NotificationSettingsUpdateSubmitted(this.settings);
  @override List<Object?> get props => [settings];
}

// ── States ────────────────────────────────────────────────────────────────────
abstract class SettingsState extends Equatable {
  @override List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}
class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final AllSettings settings;
  const SettingsLoaded(this.settings);
  @override List<Object?> get props => [settings];
}

class SettingsSaving extends SettingsState {
  final AllSettings settings; // keep current data visible
  const SettingsSaving(this.settings);
  @override List<Object?> get props => [settings];
}

class SettingsSaveSuccess extends SettingsState {
  final AllSettings settings;
  final String message;
  const SettingsSaveSuccess({required this.settings, required this.message});
  @override List<Object?> get props => [message];
}

class SettingsError extends SettingsState {
  final String message;
  final Map<String, dynamic>? errors;
  const SettingsError(this.message, {this.errors});
  @override List<Object?> get props => [message];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final _repo = SettingsRepository();

  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsLoadRequested>(_onLoad);
    on<CompanySettingsUpdateSubmitted>(_onUpdateCompany);
    on<PipelineStagesUpdateSubmitted>(_onUpdateStages);
    on<NotificationSettingsUpdateSubmitted>(_onUpdateNotifications);
  }

  AllSettings? get _currentSettings {
    if (state is SettingsLoaded)      return (state as SettingsLoaded).settings;
    if (state is SettingsSaving)      return (state as SettingsSaving).settings;
    if (state is SettingsSaveSuccess) return (state as SettingsSaveSuccess).settings;
    return null;
  }

  Future<void> _onLoad(SettingsLoadRequested event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final settings = await _repo.getAllSettings();
      emit(SettingsLoaded(settings));
    } on SettingsException catch (e) {
      emit(SettingsError(e.message));
    } catch (_) {
      emit(const SettingsError('Failed to load settings.'));
    }
  }

  Future<void> _onUpdateCompany(
      CompanySettingsUpdateSubmitted event, Emitter<SettingsState> emit) async {
    final current = _currentSettings;
    if (current != null) emit(SettingsSaving(current));
    try {
      final updated = await _repo.updateCompany(
        name: event.name, email: event.email,
        phone: event.phone, website: event.website,
        industry: event.industry, address: event.address,
      );
      final newSettings = current!.copyWith(company: updated);
      emit(SettingsSaveSuccess(settings: newSettings, message: 'Company info updated ✅'));
    } on SettingsException catch (e) {
      emit(SettingsError(e.message, errors: e.errors));
    }
  }

  Future<void> _onUpdateStages(
      PipelineStagesUpdateSubmitted event, Emitter<SettingsState> emit) async {
    final current = _currentSettings;
    if (current != null) emit(SettingsSaving(current));
    try {
      final updated = await _repo.renamePipelineStages(event.stages);
      final newSettings = current!.copyWith(stages: updated);
      emit(SettingsSaveSuccess(settings: newSettings, message: 'Pipeline stages updated ✅'));
    } on SettingsException catch (e) {
      emit(SettingsError(e.message));
    }
  }

  Future<void> _onUpdateNotifications(
      NotificationSettingsUpdateSubmitted event, Emitter<SettingsState> emit) async {
    final current = _currentSettings;
    // Optimistic update
    if (current != null) {
      emit(SettingsLoaded(current.copyWith(notifications: event.settings)));
    }
    try {
      final updated = await _repo.updateNotifications(event.settings);
      final newSettings = current!.copyWith(notifications: updated);
      emit(SettingsSaveSuccess(settings: newSettings, message: 'Notification settings saved ✅'));
    } on SettingsException catch (e) {
      emit(SettingsError(e.message));
    }
  }
}
