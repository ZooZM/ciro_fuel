import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../domain/entities/country_dial_code.dart';
import '../cubit/password_reset_cubit.dart';
import '../cubit/password_reset_failure_message.dart';
import '../cubit/password_reset_state.dart';
import '../widgets/phone_field.dart';

/// Password recovery, step 1 and 2 (spec 006 US3): the phone number a
/// code is sent to, then the code itself, with resend — one screen,
/// switching on `PasswordResetCubit`'s state, the same way
/// `VerifyPhoneScreen` switches on its own cubit rather than being two
/// routes for what is really one back-and-forth conversation.
///
/// Previously a stated placeholder with no backend behind it at all.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordResetCubit>(
      create: (_) => getIt<PasswordResetCubit>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  CountryDialCode _country = CountryDialCode.fallback;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<PasswordResetCubit>().requestReset(_country.toE164(_phoneController.text));
  }

  void _resend(String phone) {
    context.read<PasswordResetCubit>().requestReset(phone);
  }

  void _verify(String phone) {
    if (_codeController.text.trim().length != 6) return;
    context.read<PasswordResetCubit>().verifyCode(
      phone: phone,
      code: _codeController.text.trim(),
    );
  }

  void _changeNumber() {
    _codeController.clear();
    context.read<PasswordResetCubit>().restart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        switch (state) {
          case PasswordResetVerified(:final resetToken):
            context.push(AppRoutes.resetPassword, extra: resetToken);
          case PasswordResetFailureState(:final failure):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(passwordResetFailureMessage(failure))),
            );
          case PasswordResetIdle() ||
              PasswordResetRequesting() ||
              PasswordResetCodeSent() ||
              PasswordResetVerifying() ||
              PasswordResetCompleting() ||
              PasswordResetCompleted():
            break;
        }
      },
      builder: (context, state) {
        final phone = state is PasswordResetCodeSent ? state.phone : null;
        final isRequesting = state is PasswordResetRequesting;
        final isVerifying = state is PasswordResetVerifying;

        return Scaffold(
          backgroundColor: context.colors.canvas,
          appBar: AppBar(
            title: Text(PasswordResetKeys.forgotTitle.tr()),
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
                  children: phone == null
                      ? _phoneStep(context, isRequesting)
                      : _codeStep(context, phone, isVerifying),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _phoneStep(BuildContext context, bool isRequesting) {
    return [
      Text(
        PasswordResetKeys.phoneIntro.tr(),
        style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
      ),
      const SizedBox(height: AppSpacing.xl),
      PhoneField(
        controller: _phoneController,
        country: _country,
        onCountryChanged: (c) => setState(() => _country = c),
      ),
      const SizedBox(height: AppSpacing.xl),
      FilledButton(
        onPressed: isRequesting ? null : _sendCode,
        child: isRequesting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(PasswordResetKeys.sendCode.tr()),
      ),
    ];
  }

  List<Widget> _codeStep(BuildContext context, String phone, bool isVerifying) {
    return [
      Text(
        PasswordResetKeys.codeSentTo.tr(namedArgs: {'phone': phone}),
        style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
      ),
      const SizedBox(height: AppSpacing.xl),
      TextFormField(
        controller: _codeController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        decoration: InputDecoration(labelText: PasswordResetKeys.codeLabel.tr()),
      ),
      const SizedBox(height: AppSpacing.md),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => _resend(phone),
            child: Text(PasswordResetKeys.resend.tr()),
          ),
          TextButton(
            onPressed: _changeNumber,
            child: Text(PasswordResetKeys.changeNumber.tr()),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      FilledButton(
        onPressed: isVerifying ? null : () => _verify(phone),
        child: isVerifying
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(PasswordResetKeys.verify.tr()),
      ),
    ];
  }
}
