import 'package:flutter/material.dart';
import 'package:hireops/core/constants/app_strings.dart';
import 'package:hireops/core/constants/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showTagline;

  const AppLogo({super.key, this.size = 48, this.showTagline = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceVariantDark : Colors.white,
            borderRadius: BorderRadius.circular(size * 0.22),
            border: Border.all(
              color: (isDark ? AppColors.outlineDark : AppColors.outlineLight)
                  .withValues(alpha: 0.75),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(size * 0.12),
            child: Image.asset(
              'assets/icons/hireops_launcher.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppStrings.appName,
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: size * 0.42,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.onSurfaceLight,
            letterSpacing: 0,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 4),
          Text(
            AppStrings.appTagline,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 12,
              color: (isDark ? Colors.white : AppColors.onSurfaceLight)
                  .withValues(alpha: 0.55),
            ),
          ),
        ],
      ],
    );
  }
}
