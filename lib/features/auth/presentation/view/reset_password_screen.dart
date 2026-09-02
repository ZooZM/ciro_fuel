import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../cubit/password_reset_cubit.dart';
import '../cubit/password_reset_failure_message.dart';
import '../cubit/password_reset_state.dart';

/// Password recovery, step 3 (spec 006 US3): the new password, once
/// `ForgotPasswordScreen` has a verified `resetToken` to carry here via
/// route `extra`. A fresh cubit instance — it needs nothing the previous
/// screen accumulated beyond that token (same reasoning as
/// `PhoneVerificationCubit`'s one-instance-per-screen precedent).
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({required this.resetToken, super.key});

  final String resetToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordResetCubit>(
      create: (_) => getIt<PasswordResetCubit>(),
      child: _ResetPasswordView(resetToken: resetToken),
    );
  }
}

class _ResetPasswordView extends StatefulWidget {
  const _ResetPasswordView({required this.resetToken});

  final String resetToken;

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<PasswordResetCubit>().completeReset(
      resetToken: widget.resetToken,
      newPassword: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        switch (state) {
          case PasswordResetCompleted():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(PasswordResetKeys.completedMessage.tr())),
            );
            // Never signs the driver in — they prove the new password
            // works by using it, on the screen that is the only way
            // forward from here anyway.
            context.go(AppRoutes.login);
          case PasswordResetFailureState(:final failure):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(passwordResetFailureMessage(failure))),
            );
          case PasswordResetIdle() ||
              PasswordResetRequesting() ||
              PasswordResetCodeSent() ||
              PasswordResetVerifying() ||
              PasswordResetVerified() ||
              PasswordResetCompleting():
            break;
        }
      },
      builder: (context, state) {
        final isCompleting = state is PasswordResetCompleting;
        return Scaffold(
          backgroundColor: context.colors.canvas,
          appBar: AppBar(
            title: Text(PasswordResetKeys.newPasswordTitle.tr()),
            backgroundColor: context.colors.canvas,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // FR-026: the rule is stated before submission, not
                    // only surfaced on rejection.
                    Text(
                      PasswordResetKeys.newPasswordRules.tr(),
                      style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: PasswordResetKeys.newPasswordLabel.tr(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (value) => (value == null || value.length < 8)
                          ? PasswordResetKeys.newPasswordRules.tr()
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      onPressed: isCompleting ? null : _submit,
                      child: isCompleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(PasswordResetKeys.submit.tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
