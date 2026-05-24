import 'package:flutter/foundation.dart';

/// Central API configuration for HireOps.
/// Override via --dart-define=API_BASE_URL=http://YOUR_HOST:3000
/// or switch to production via --dart-define=ENV=prod.
class ApiConstants {
  ApiConstants._();

  static const String _baseUrlDev = 'http://localhost:3000';
  static const String _baseUrlAndroidEmulator = 'http://10.0.2.2:3000';
  static const String _baseUrlProd = 'https://hireops-api.onrender.com';

  static const String _env = String.fromEnvironment(
    'ENV',
    defaultValue: kReleaseMode ? 'prod' : 'dev',
  );
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static String get _fallbackBaseUrl {
    if (_env == 'prod') {
      return _baseUrlProd;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return _baseUrlAndroidEmulator;
    }

    return _baseUrlDev;
  }

  static String get baseUrl =>
      _baseUrlOverride.isNotEmpty ? _baseUrlOverride : _fallbackBaseUrl;

  static bool isLocalBaseUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    final host = uri?.host.toLowerCase();
    return host == 'localhost' || host == '127.0.0.1' || host == '10.0.2.2';
  }

  // ── Auth ────────────────────────────────────────────────────────────────────
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String verifyEmail = '/api/auth/verify-email';
  static const String resendVerification = '/api/auth/resend-verification';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String verifyOtp = '/api/auth/verify-otp';
  static const String resetPassword = '/api/auth/reset-password';
  static const String logout = '/api/auth/logout';
  static const String refreshToken = '/api/auth/refresh';

  // ── Dashboard ───────────────────────────────────────────────────────────────
  static const String dashboardStats = '/api/dashboard/stats';
  static const String recentActivity = '/api/dashboard/recent-activity';

  // ── Candidates ──────────────────────────────────────────────────────────────
  static const String candidates = '/api/candidates';
  static String candidate(String id) => '/api/candidates/$id';
  static String candidateTags(String id) => '/api/candidates/$id/tags';
  static String candidateNotes(String id) => '/api/candidates/$id/notes';
  static String candidateNote(String cId, String nId) =>
      '/api/candidates/$cId/notes/$nId';

  // ── CV ──────────────────────────────────────────────────────────────────────
  static const String cvUpload = '/api/cv/upload';
  static String cvDownload(String id) => '/api/cv/$id/download';

  // ── Jobs ────────────────────────────────────────────────────────────────────
  static const String jobs = '/api/jobs';
  static String job(String id) => '/api/jobs/$id';
  static String jobAssign(String id) => '/api/jobs/$id/assign';
  static String jobToggle(String id) => '/api/jobs/$id/toggle';

  // ── Pipeline ────────────────────────────────────────────────────────────────
  static const String pipelineStages = '/api/pipeline/stages';
  static String movePipelineCandidate(String id) =>
      '/api/pipeline/candidates/$id/move';

  // ── Activity ────────────────────────────────────────────────────────────────
  static const String activityLog = '/api/activity-log';
  static String candidateActivity(String id) => '/api/candidates/$id/activity';

  // ── Notifications ────────────────────────────────────────────────────────────
  static const String notifications = '/api/notifications';
  static const String notificationSettings = '/api/notifications/settings';

  // ── Settings ────────────────────────────────────────────────────────────────
  static const String companyProfile = '/api/company';
  static const String teamMembers = '/api/company/members';

  // ── HTTP ─────────────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int maxCvSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const List<String> allowedCvExtensions = ['pdf', 'doc', 'docx'];
}
