import 'dart:async';

// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../auth/presentation/cubit/session_state.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/translation_keys.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/step_tracker.dart';
import '../cubit/phone_verification_cubit.dart';
import '../cubit/phone_verification_state.dart';
import 'phone_verification_failure_message.dart';
import '../widgets/profile_identity.dart';
import '../../../../core/theme/theme_context.dart';

const _kOrange = Color(0xFFFF5810);

/// How many digits the code has — matches the backend's
/// `ConfirmPhoneVerificationDto` (`@Length(6, 6)`). Previously 4: this
/// screen's code boxes never matched the code the backend actually sends,
/// which this wiring (spec 006 FR-006) would otherwise have shipped
/// unnoticed, since nothing here called the backend before.
const int _kCodeLength = 6;

/// Step two of changing the driver's mobile number (spec 006 FR-006) —
/// mirrors `VerifyPhoneScreen` (the client's own version), wired to the
/// same `PhoneVerificationCubit`. Previously static: a hard-coded
/// `'5X XXX XXXX'`, a fixed 45-second countdown, and a confirm button that
/// did nothing (`onTap: () {}`).
class DriverVerifyPhoneScreen extends StatelessWidget {
  const DriverVerifyPhoneScreen({required this.phone, super.key});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneVerificationCubit>(
      create: (_) => getIt<PhoneVerificationCubit>(),
      child: _DriverVerifyPhoneView(phone: phone),
    );
  }
}

class _DriverVerifyPhoneView extends StatefulWidget {
  const _DriverVerifyPhoneView({required this.phone});

  final String phone;

  @override
  State<_DriverVerifyPhoneView> createState() => _DriverVerifyPhoneViewState();
}

class _DriverVerifyPhoneViewState extends State<_DriverVerifyPhoneView> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  /// Distinguishes a resend's failure from a confirm's failure — both land
  /// as the same [PhoneVerificationFailureState] type, but only a throttled
  /// resend should arm [_resendCountdown].
  bool _lastActionWasResend = false;

  Timer? _countdownTimer;
  Duration? _resendCountdown;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_kCodeLength, (_) => TextEditingController());
    _nodes = List.generate(_kCodeLength, (_) => FocusNode());
    // The boxes repaint on focus (outline) as well as on content (the dot).
    for (final node in _nodes) {
      node.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (final node in _nodes) {
      node.removeListener(_onFocusChanged);
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  String get _code => _controllers.map((c) => c.text).join();

  void _clearCode() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _nodes.first.requestFocus();
  }

  void _startResendCountdown(Duration retryAfter) {
    _countdownTimer?.cancel();
    setState(() => _resendCountdown = retryAfter);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = _resendCountdown;
      if (remaining == null || remaining.inSeconds <= 1) {
        timer.cancel();
        setState(() => _resendCountdown = null);
        return;
      }
      setState(() => _resendCountdown = remaining - const Duration(seconds: 1));
    });
  }

  /// Typing a digit carries the caret to the next box; clearing one carries it
  /// back. The last digit closes the keyboard rather than trapping focus.
  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < _kCodeLength - 1) {
      _nodes[index + 1].requestFocus();
    } else if (value.isNotEmpty) {
      _nodes[index].unfocus();
    } else if (index > 0) {
      _nodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  /// Backspace on a box that is already empty steps back and clears the one
  /// before it, which `onChanged` alone never sees.
  KeyEventResult _onKey(int index, KeyEvent event) {
    final isBackspace =
        event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace;
    if (isBackspace && _controllers[index].text.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _nodes[index - 1].requestFocus();
      setState(() {});
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneVerificationCubit, PhoneVerificationState>(
      listener: (context, state) {
        switch (state) {
          case PhoneVerificationConfirmed():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(VerifyPhoneKeys.phoneVerified.tr())),
            );
            context.go(AppRoutes.driverProfileDetails);
          case PhoneVerificationCodeSent():
            // Only reachable via resend on this screen — the initial send
            // happened on driver_change_phone_screen, one navigation back.
            _clearCode();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(VerifyPhoneKeys.codeResent.tr())),
            );
          case PhoneVerificationFailureState(:final failure):
            if (_lastActionWasResend && failure is ThrottledFailure) {
              final retryAfter = failure.retryAfter;
              if (retryAfter != null) _startResendCountdown(retryAfter);
            } else if (!_lastActionWasResend) {
              // A wrong/expired code — clear the boxes for another attempt
              // rather than leaving stale digits behind.
              _clearCode();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(phoneVerificationFailureMessageKey(failure).tr()),
              ),
            );
          case PhoneVerificationIdle() || PhoneVerificationSending() || PhoneVerificationConfirming():
            break;
        }
      },
      builder: (context, state) {
        final isConfirming = state is PhoneVerificationConfirming;
        final canConfirm = _code.length == _kCodeLength && !isConfirming;

        return Scaffold(
          backgroundColor: context.colors.canvas,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppTopBar(),
                  const SizedBox(height: 32),
                  ProfileIdentity(name: _sessionName()),
                  const SizedBox(height: 32),
                  StepTracker(
                    steps: [
                      StepItem(
                        ChangePhoneKeys.stepChangeNumber.tr(),
                        TrackerStepState.done,
                      ),
                      StepItem(
                        ChangePhoneKeys.stepVerifyCode.tr(),
                        TrackerStepState.current,
                      ),
                      StepItem(
                        ChangePhoneKeys.stepReverify.tr(),
                        TrackerStepState.pending,
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Text(
                    VerifyPhoneKeys.title.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    VerifyPhoneKeys.sentTo.tr(),
                    style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          widget.phone,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Text(
                          VerifyPhoneKeys.changeNumber.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _kOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildCodeBoxes(),
                  const SizedBox(height: 16),
                  Center(child: _buildResend(context)),
                  const SizedBox(height: 32),
                  _buildConfirmButton(context, canConfirm, isConfirming),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResend(BuildContext context) {
    final countdown = _resendCountdown;
    if (countdown != null) {
      final minutes = countdown.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = countdown.inSeconds.remainder(60).toString().padLeft(2, '0');
      return Text(
        VerifyPhoneKeys.resendIn.tr(namedArgs: {'timer': '$minutes:$seconds'}),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: context.colors.brandBlue,
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        _lastActionWasResend = true;
        context.read<PhoneVerificationCubit>().requestCode(widget.phone);
      },
      child: Text(
        VerifyPhoneKeys.resendCode.tr(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: context.colors.brandBlue,
        ),
      ),
    );
  }

  Widget _buildCodeBoxes() {
    return Row(
      // A code is keyed left-to-right even on this right-to-left page, so the
      // first box is the left-most one.
      textDirection: TextDirection.ltr,
      children: [
        for (var index = 0; index < _kCodeLength; index++) ...[
          if (index > 0) const SizedBox(width: 12),
          Expanded(
            child: _CodeBox(
              controller: _controllers[index],
              focusNode: _nodes[index],
              autofocus: index == 0,
              onChanged: (value) => _onDigitChanged(index, value),
              onKey: (event) => _onKey(index, event),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConfirmButton(
    BuildContext context,
    bool canConfirm,
    bool isConfirming,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.brandBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x401E5FFF),
            offset: Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: canConfirm
              ? () {
                  _lastActionWasResend = false;
                  context.read<PhoneVerificationCubit>().confirmCode(_code);
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: isConfirming
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      CommonKeys.confirm.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: canConfirm ? Colors.white : Colors.white70,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One digit of the code. The focused box turns white with a blue outline; the
/// rest stay on the sunken chip fill.
class _CodeBox extends StatelessWidget {
  const _CodeBox({
    required this.controller,
    required this.focusNode,
    required this.autofocus,
    required this.onChanged,
    required this.onKey,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final KeyEventResult Function(KeyEvent) onKey;

  @override
  Widget build(BuildContext context) {
    final focused = focusNode.hasFocus;
    final filled = controller.text.isNotEmpty;

    return GestureDetector(
      onTap: focusNode.requestFocus,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: focused ? context.colors.surface : context.colors.surface2,
          borderRadius: BorderRadius.circular(14),
          border: focused ? Border.all(color: context.colors.brandBlue, width: 1.5) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: Focus(
                // Listens in on the field's keys without ever taking focus from
                // it, so backspace on an empty box can be caught.
                canRequestFocus: false,
                skipTraversal: true,
                onKeyEvent: (node, event) => onKey(event),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: autofocus,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  cursorColor: context.colors.textPrimary,
                  cursorWidth: 2,
                  cursorHeight: 22,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                    height: 1.0,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    counterText: '',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onChanged,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // The dot under each box fills in blue once that digit is keyed.
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: filled && !focused ? context.colors.brandBlue : context.colors.borderHairline,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The signed-in driver, off the session — the driver profile screens
/// previously rendered a hardcoded "محمد أحمد" for everyone. A driver
/// belongs to a transport company, not a station, so that line is blank
/// rather than carrying an invented station name.
String _sessionName() {
  final state = getIt<SessionCubit>().state;
  return state is SessionAuthenticated ? state.user.fullName : '';
}
