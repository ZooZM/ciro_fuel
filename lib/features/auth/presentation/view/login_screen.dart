import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/di/injector.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_failure_message.dart';
import '../cubit/auth_state.dart';
import '../cubit/session_cubit.dart';

const _kBackgroundImage = 'assets/sign in/background .jpg';
const _kLogo = 'assets/logo/Logo.svg';
const _kFaceId = 'assets/biometric/Face ID.svg';
const _kWave = 'assets/sign in/Wave.svg';
const _kPhoneIcon = 'assets/icons/phone.svg';
const _kLockIcon = 'assets/icons/locked.svg';
const _kShieldIcon = 'assets/icons/protection.svg';
const _kHeadsetIcon = 'assets/icons/customer service.svg';
const _kAppleIcon = 'assets/social media/apple.svg';
const _kGoogleIcon = 'assets/social media/google.svg';

const _kBlue = Color(0xFF1E5FFF);
const _kGreen = Color(0xFF17A34A);
const _kNavy = Color(0xFF0F1B2E);
const _kGrey = Color(0xFF8A93A6);
const _kBorder = Color(0xFFE6E9F0);
const _kFieldFill = Color(0xFFF8F9FB);

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthCubit(signIn: getIt(), sessionCubit: getIt<SessionCubit>()),
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().submit(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state case AuthLoginFailure(:final failure)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(authFailureMessage(failure))),
              );
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  _kBackgroundImage,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.transparent],
                      stops: const [0.0, 0.4],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: SvgPicture.asset(_kWave, width: 160),
                ),
              ),
              Positioned.fill(
                child: Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: SafeArea(
                              child: Column(
                                children: [
                                  const _HeaderContent(),
                                  const Spacer(),
                                  _buildCard(context),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      width: 354,
      height: 498,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(width: 1, color: _kBorder),
          left: BorderSide(width: 1, color: _kBorder),
          right: BorderSide(width: 1, color: _kBorder),
        ),
        boxShadow: [
          BoxShadow(color: Color(0x1A0F1B2E), blurRadius: 24, offset: Offset(0, -8)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PhoneField(controller: _emailController),
              const SizedBox(height: 24),
              _PasswordField(controller: _passwordController),
              const SizedBox(height: 24),
              _RememberForgotRow(
                rememberMe: _rememberMe,
                onChanged: (value) => setState(() => _rememberMe = value),
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isSubmitting = state is AuthSubmitting;
                  return _SignInButton(
                    isLoading: isSubmitting,
                    onPressed: isSubmitting ? null : () => _submit(context),
                  );
                },
              ),
              const SizedBox(height: 24),
              const _OrDivider(),
              const SizedBox(height: 24),
              const _FaceIdButton(),
              const SizedBox(height: 24),
              const _SocialButtonsRow(),
              const SizedBox(height: 24),
              const _FooterInfo(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Align(alignment: Alignment.topLeft, child: _LanguagePill()),
        ),
        const SizedBox(height: 16),
        SvgPicture.asset(_kLogo, width: 150),
        const SizedBox(height: 2),
        const Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
            ),
            children: [
              TextSpan(text: 'F', style: TextStyle(color: _kGreen)),
              TextSpan(text: ' U E L', style: TextStyle(color: _kBlue)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5),
            children: [
              TextSpan(text: 'FUEL TRANSPORT', style: TextStyle(color: _kGreen)),
              TextSpan(text: ' & ', style: TextStyle(color: _kNavy)),
              TextSpan(text: 'LOGISTICS', style: TextStyle(color: _kBlue)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'مرحباً بك في سيرو',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: _kNavy),
        ),
        const SizedBox(height: 6),
        const Text(
          'لطلب وقودك و متابعة الاستلام لحظة بلحظة',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, color: _kGrey),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _LanguagePill extends StatelessWidget {
  const _LanguagePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xE6FFFFFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: const Row(
        textDirection: TextDirection.ltr,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language, size: 16, color: _kBlue),
          SizedBox(width: 6),
          Text('العربية', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kNavy)),
          SizedBox(width: 2),
          Icon(Icons.keyboard_arrow_down, size: 16, color: _kBlue),
        ],
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      validator: (value) => (value == null || value.isEmpty) ? 'أدخل رقم الجوال' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: _kFieldFill,
        hintText: '5X XXX XXXX',
        hintStyle: const TextStyle(color: _kGrey, fontSize: 13),
        labelText: 'رقم الجوال',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(color: _kGrey, fontSize: 11),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kBlue),
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(_kPhoneIcon, width: 18, height: 18, colorFilter: const ColorFilter.mode(_kBlue, BlendMode.srcIn)),
              const SizedBox(width: 8),
              const Text(
                '+966',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _kBlue),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: _kBlue),
              const SizedBox(width: 10),
              Container(width: 1, height: 22, color: _kBorder),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) => (value == null || value.isEmpty) ? 'أدخل كلمة المرور' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: _kFieldFill,
        hintText: 'كلمة المرور',
        hintStyle: const TextStyle(color: _kGrey, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kBlue),
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 14, left: 6),
          child: SvgPicture.asset(_kLockIcon, width: 18, height: 18, colorFilter: const ColorFilter.mode(_kBlue, BlendMode.srcIn)),
        ),
      ),
    );
  }
}

class _RememberForgotRow extends StatelessWidget {
  const _RememberForgotRow({required this.rememberMe, required this.onChanged});

  final bool rememberMe;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => onChanged(!rememberMe),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: rememberMe ? _kBlue : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: rememberMe ? _kBlue : _kBorder, width: 1.4),
                ),
                child: rememberMe ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
              ),
              const SizedBox(width: 8),
              const Text('تذكرني', style: TextStyle(fontSize: 12.5, color: _kNavy)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: _kBlue),
          ),
        ),
      ],
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('دخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: _kBorder, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('أو سجل الدخول باستخدام', style: TextStyle(fontSize: 11.5, color: _kGrey)),
        ),
        Expanded(child: Divider(color: _kBorder, thickness: 1)),
      ],
    );
  }
}

class _FaceIdButton extends StatelessWidget {
  const _FaceIdButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.fromBorderSide(BorderSide(color: _kBorder)),
            boxShadow: [BoxShadow(color: Color(0x140F1B2E), blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Center(child: SvgPicture.asset(_kFaceId, width: 28, height: 28, colorFilter: const ColorFilter.mode(_kBlue, BlendMode.srcIn))),
        ),
        const SizedBox(height: 8),
        const Text('بصمة الوجه', style: TextStyle(fontSize: 11.5, color: _kGrey)),
      ],
    );
  }
}

class _SocialButtonsRow extends StatelessWidget {
  const _SocialButtonsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _SocialButton(
            icon: _AssetIcon(_kAppleIcon, size: 18),
            label: 'Apple',
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _SocialButton(
            icon: _AssetIcon(_kGoogleIcon, size: 18),
            label: 'Google',
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: _kBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _kNavy)),
          ],
        ),
      ),
    );
  }
}

class _AssetIcon extends StatelessWidget {
  const _AssetIcon(this.asset, {required this.size});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(asset, width: size, height: size);
  }
}

class _FooterInfo extends StatelessWidget {
  const _FooterInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(_kHeadsetIcon, width: 14, height: 14, colorFilter: const ColorFilter.mode(_kBlue, BlendMode.srcIn)),
            const SizedBox(width: 6),
            const Text(
              'الدعم و المساعدة',
              style: TextStyle(fontSize: 11.5, color: _kGrey, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(_kShieldIcon, width: 13, height: 13, colorFilter: const ColorFilter.mode(_kBlue, BlendMode.srcIn)),
            const SizedBox(width: 6),
            const Text(
              'اتصال آمن و مشفر وفق أعلى معايير الحماية',
              style: TextStyle(fontSize: 10.5, color: _kGrey),
            ),
          ],
        ),
      ],
    );
  }
}

