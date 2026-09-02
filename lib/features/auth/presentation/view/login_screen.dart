import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_failure_message.dart';
import '../cubit/auth_state.dart';
import '../cubit/login_form_cubit.dart';
import '../cubit/login_form_state.dart';
import '../cubit/session_cubit.dart';
import '../widgets/alternatives_divider.dart';
import '../widgets/biometric_button.dart';
import '../widgets/brand_lockup.dart';
import '../widgets/federated_sign_in_row.dart';
import '../widgets/language_switcher.dart';
import '../widgets/login_backdrop.dart';
import '../widgets/login_card.dart';
import '../widgets/login_footer.dart';
import '../widgets/password_field.dart';
import '../widgets/phone_field.dart';
import '../widgets/remember_me_row.dart';
import '../widgets/sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(
            signIn: getIt(),
            restoreSession: getIt(),
            biometrics: getIt(),
            preferences: getIt(),
            sessionCubit: getIt<SessionCubit>(),
          ),
        ),
        BlocProvider(
          create: (_) =>
              LoginFormCubit(biometrics: getIt(), preferences: getIt())
                ..initialize(),
        ),
      ],
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final form = context.read<LoginFormCubit>().state;
    unawaited(
      context.read<AuthCubit>().submit(
        country: form.country,
        nationalNumber: _phoneController.text,
        password: _passwordController.text,
        rememberMe: form.rememberMe,
      ),
    );
  }

  void _signInWithBiometrics() {
    unawaited(
      context.read<AuthCubit>().signInWithBiometrics(
        localizedReason: LoginKeys.biometricReason.tr(),
      ),
    );
  }

  void _notifyComingSoon() => _showMessage(LoginKeys.comingSoon.tr());

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (_, state) =>
                state is AuthLoginFailure || state is AuthLoginError,
            listener: (context, state) => _showMessage(switch (state) {
              AuthLoginFailure(:final failure) => authFailureMessageKey(
                failure,
              ).tr(),
              AuthLoginError(:final messageKey) => messageKey.tr(),
              _ => ErrorKeys.generic.tr(),
            }),
          ),
          BlocListener<LoginFormCubit, LoginFormState>(
            listenWhen: (previous, current) =>
                previous.rememberedNumber != current.rememberedNumber,
            listener: (context, state) {
              final remembered = state.rememberedNumber;
              if (remembered != null && _phoneController.text.isEmpty) {
                _phoneController.text = remembered;
              }
            },
          ),
        ],
        child: Stack(
          children: [
            const LoginBackdrop(),
            SafeArea(bottom: false, child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenGutter,
                ),
                child: Column(
                  children: [
                    // Pinned to the physical left in both directions so it
                    // never lands under the brand wave in the far corner.
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: LanguageSwitcher(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const BrandLockup(),
                    const Spacer(),
                    const SizedBox(height: AppSpacing.xxl),
                    _buildCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return BlocBuilder<LoginFormCubit, LoginFormState>(
      builder: (context, form) {
        final formCubit = context.read<LoginFormCubit>();

        return LoginCard(
          children: [
            PhoneField(
              controller: _phoneController,
              country: form.country,
              onCountryChanged: formCubit.selectCountry,
            ),
            const SizedBox(height: AppSpacing.md),
            PasswordField(
              controller: _passwordController,
              obscure: form.obscurePassword,
              onToggleObscure: formCubit.togglePasswordVisibility,
              onSubmitted: _submit,
            ),
            const SizedBox(height: AppSpacing.lg),
            RememberMeRow(
              rememberMe: form.rememberMe,
              onRememberMeChanged: (_) => formCubit.toggleRememberMe(),
              onForgotPassword: () => context.push(AppRoutes.forgotPassword),
            ),
            const SizedBox(height: AppSpacing.lg),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) => SignInButton(
                isLoading: state is AuthSubmitting,
                onPressed: _submit,
                signInWithBiometrics: _signInWithBiometrics,
                form: form,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const AlternativesDivider(),
            const SizedBox(height: AppSpacing.lg),

            // Hidden outright when the device has no enrolled biometrics —
            // a control that can only ever fail is worse than no control.
            FederatedSignInRow(onProviderSelected: (_) => _notifyComingSoon()),
            const SizedBox(height: AppSpacing.md),
            LoginFooter(onSupportPressed: _notifyComingSoon),
          ],
        );
      },
    );
  }
}
