import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';

/// Drop-in replacement for showDialog when you only need confirm/cancel.
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmLabel;
  final String cancelLabel;
  final bool destructive;
  final IconData? icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.destructive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: destructive ? AppColors.error : AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 10),
          ],
          Text(title),
        ],
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: AppColors.error)
              : null,
          child: Text(confirmLabel),
        ),
      ],
    );
  }

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String content,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool destructive = false,
    IconData? icon,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => ConfirmationDialog(
            title: title,
            content: content,
            confirmLabel: confirmLabel,
            cancelLabel: cancelLabel,
            destructive: destructive,
            icon: icon,
          ),
        ) ??
        false;
  }
}
