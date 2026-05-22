# HireOps - CV Management SaaS

HireOps is organized as a split project with a Node.js backend and a Flutter mobile app reference implementation.

## Project Structure

```text
hireops/
|-- backend/
|   |-- package.json
|   |-- .env.example
|   `-- src/
|       |-- config/
|       |   `-- database.js
|       |-- controllers/
|       |   |-- auditController.js
|       |   |-- dashboardController.js
|       |   |-- jobController.js
|       |   |-- notificationController.js
|       |   `-- settingsController.js
|       |-- database/
|       |   |-- migrate_jobs.js
|       |   `-- migrate_notifications.js
|       |-- helpers/
|       |   `-- pipelineHelper.js
|       |-- middleware/
|       |   |-- authMiddleware.js
|       |   `-- securityMiddleware.js
|       |-- routes/
|       |   |-- auditRoutes.js
|       |   |-- dashboardRoutes.js
|       |   |-- jobRoutes.js
|       |   |-- notificationRoutes.js
|       |   `-- settingsRoutes.js
|       |-- services/
|       |   `-- emailService.js
|       |-- validations/
|       `-- server.js
|-- flutter_app/
|   `-- lib/
|       |-- core/
|       |   `-- shell/
|       |       `-- app_shell.dart
|       |-- features/
|       |   |-- dashboard/
|       |   |   |-- bloc/dashboard_bloc.dart
|       |   |   |-- models/dashboard_model.dart
|       |   |   |-- repositories/dashboard_repository.dart
|       |   |   `-- screens/dashboard_screen.dart
|       |   |-- notifications/
|       |   |   |-- bloc/notification_bloc.dart
|       |   |   |-- models/notification_settings_model.dart
|       |   |   |-- repositories/notification_repository.dart
|       |   |   `-- screens/notification_settings_screen.dart
|       |   |-- security/
|       |   |   `-- screens/audit_log_screen.dart
|       |   `-- settings/
|       |       |-- bloc/settings_bloc.dart
|       |       |-- models/settings_model.dart
|       |       |-- repositories/settings_repository.dart
|       |       `-- screens/settings_screen.dart
|       `-- main.dart
|-- imports/
|-- lib/
`-- pubspec.yaml
```

## Backend Setup

```bash
cd backend
npm install
cp .env.example .env
npm run migrate:core
npm run migrate:jobs
npm run migrate:notifications
npm run dev
```

The backend entrypoint is `backend/src/server.js`.

## Flutter Reference Modules

The files you provided have been organized under `flutter_app/lib/` to match the updated README structure:

- `core/shell/app_shell.dart`
- `features/security/screens/audit_log_screen.dart`
- `features/notifications/...`
- `features/dashboard/...`
- `features/settings/...`

## Notes

- The active clean-architecture Flutter app that already existed in this repository remains under the root `lib/` folder.
- The new `backend/` and `flutter_app/` trees are now aligned with the updated README structure and ready for further migration work.
