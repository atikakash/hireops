import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../constants/api_constants.dart';

// â”€â”€ Validators â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class AppValidators {
  AppValidators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required.';
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) return 'Enter a valid email address.';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    return null;
  }

  static String? required(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$label is required.';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    final regex = RegExp(r'^\+?[\d\s\-()]{7,15}$');
    if (!regex.hasMatch(value)) return 'Enter a valid phone number.';
    return null;
  }

  static String? experience(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    final n = int.tryParse(value);
    if (n == null || n < 0 || n > 60) return 'Enter a valid number (0â€“60).';
    return null;
  }

  /// Validates file extension against allowed CV extensions.
  static String? cvExtension(String? path) {
    if (path == null) return 'No file selected.';
    final ext = path.split('.').last.toLowerCase();
    if (!ApiConstants.allowedCvExtensions.contains(ext)) {
      return 'Only ${ApiConstants.allowedCvExtensions.join(', ')} allowed.';
    }
    return null;
  }

  /// Validates file size (bytes).
  static String? cvSize(int? bytes) {
    if (bytes == null) return null;
    if (bytes > ApiConstants.maxCvSizeBytes) {
      return 'File exceeds 5 MB limit.';
    }
    return null;
  }
}

// â”€â”€ Date Formatters â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class AppDateFormatter {
  AppDateFormatter._();

  static final _date = DateFormat('dd MMM yyyy');
  static final _dateTime = DateFormat('dd MMM yyyy, HH:mm');
  static final _time = DateFormat('HH:mm');
  static final _month = DateFormat('MMM yyyy');

  static String date(DateTime dt) => _date.format(dt);
  static String dateTime(DateTime dt) => _dateTime.format(dt);
  static String time(DateTime dt) => _time.format(dt);
  static String month(DateTime dt) => _month.format(dt);
  static String timeAgo(DateTime dt) => timeago.format(dt);

  static String fromIso(String iso) {
    try {
      return date(DateTime.parse(iso).toLocal());
    } on Object catch (_) {
      return iso;
    }
  }

  static String timeAgoFromIso(String iso) {
    try {
      return timeAgo(DateTime.parse(iso).toLocal());
    } on Object catch (_) {
      return iso;
    }
  }
}

// â”€â”€ File Helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class AppFileHelper {
  AppFileHelper._();

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static String extension(String path) => path.split('.').last.toLowerCase();
}

// â”€â”€ String Extensions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
extension StringExt on String {
  String get capitalized =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  String get titleCase => split(' ').map((w) => w.capitalized).join(' ');
}
