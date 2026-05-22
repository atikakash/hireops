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
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'H',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: size * 0.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
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
            letterSpacing: -0.5,
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
