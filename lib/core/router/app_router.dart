import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/activity/presentation/screens/activity_log_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/candidates/presentation/screens/add_edit_candidate_screen.dart';
import '../../features/candidates/presentation/screens/candidate_list_screen.dart';
import '../../features/candidates/presentation/screens/candidate_profile_screen.dart';
import '../../features/cv_upload/presentation/screens/cv_preview_screen.dart';
import '../../features/cv_upload/presentation/screens/cv_upload_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/jobs/presentation/screens/add_edit_job_screen.dart';
import '../../features/jobs/presentation/screens/job_detail_screen.dart';
import '../../features/jobs/presentation/screens/job_list_screen.dart';
import '../../features/notifications/presentation/screens/notification_list_screen.dart';
import '../../features/pipeline/presentation/screens/pipeline_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../shared/providers/auth_state_provider.dart';
import '../shell/main_shell.dart';

part 'app_router.g.dart';

// ── Route Names ───────────────────────────────────────────────────────────────
class AppRoutes {
  AppRoutes._();

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Shell tabs
  static const String dashboard = '/dashboard';
  static const String candidates = '/candidates';
  static const String jobs = '/jobs';
  static const String pipeline = '/pipeline';
  static const String activity = '/activity';
  static const String settings = '/settings';

  // Candidate sub-routes
  static const String candidateProfile = '/candidates/:id';
  static const String addCandidate = '/candidates/add';
  static const String editCandidate = '/candidates/:id/edit';

  // CV
  static const String cvUpload = '/cv-upload';
  static const String cvPreview = '/cv-preview';

  // Job sub-routes
  static const String jobDetail = '/jobs/:id';
  static const String addJob = '/jobs/add';
  static const String editJob = '/jobs/:id/edit';

  // Notifications
  static const String notifications = '/notifications';
}

// ── Router Provider ───────────────────────────────────────────────────────────
@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull ?? false;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation.startsWith('/forgot-password');

      if (!isAuthenticated && !isAuthRoute) return AppRoutes.login;
      if (isAuthenticated && isAuthRoute) return AppRoutes.dashboard;
      return null;
    },
    routes: [
      // ── Auth Routes (no shell) ──────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),

      // ── Main Shell (bottom nav) ─────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (_, __) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.candidates,
            name: 'candidates',
            builder: (_, __) => const CandidateListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'add-candidate',
                builder: (_, __) => const AddEditCandidateScreen(),
              ),
              GoRoute(
                path: ':id',
                name: 'candidate-profile',
                builder: (context, state) => CandidateProfileScreen(
                  candidateId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'edit-candidate',
                    builder: (context, state) => AddEditCandidateScreen(
                      candidateId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.jobs,
            name: 'jobs',
            builder: (_, __) => const JobListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'add-job',
                builder: (_, __) => const AddEditJobScreen(),
              ),
              GoRoute(
                path: ':id',
                name: 'job-detail',
                builder: (context, state) => JobDetailScreen(
                  jobId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'edit-job',
                    builder: (context, state) => AddEditJobScreen(
                      jobId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.pipeline,
            name: 'pipeline',
            builder: (_, __) => const PipelineScreen(),
          ),
          GoRoute(
            path: AppRoutes.activity,
            name: 'activity',
            builder: (_, __) => const ActivityLogScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),

      // ── Full-screen routes (above shell) ────────────────────────────────────
      GoRoute(
        path: AppRoutes.cvUpload,
        name: 'cv-upload',
        builder: (_, __) => const CvUploadScreen(),
      ),
      GoRoute(
        path: AppRoutes.cvPreview,
        name: 'cv-preview',
        builder: (context, state) => CvPreviewScreen(
          cvUrl: state.uri.queryParameters['url'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (_, __) => const NotificationListScreen(),
      ),
    ],
  );
}
