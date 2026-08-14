import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_logo.dart';

class RoleSelectionMockScreen extends StatelessWidget {
  const RoleSelectionMockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppLogoMark(height: 120),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Select Role (Mock)',
                textAlign: TextAlign.center,
                style: context.textStyles.welcomeTitle.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () {
                  context.go(AppRoutes.clientHome);
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                ),
                child: const Text('Client App', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: () {
                  context.go(AppRoutes.driverHome);
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  backgroundColor: context.colors.brandGreen,
                ),
                child: const Text('Driver App', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
