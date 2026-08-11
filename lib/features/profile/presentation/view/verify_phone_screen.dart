// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter/services.dart';

import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/step_tracker.dart';
import '../widgets/profile_identity.dart';
import '../../../../core/theme/theme_context.dart';

const _kOrange = Color(0xFFFF5810);

/// How many digits the code has.
const int _kCodeLength = 4;

/// Step two of changing the account's mobile number: keying in the four-digit
/// code sent to it.
class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

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
              const ProfileIdentity(),
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
                  Text(
                    '5X XXX XXXX',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
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
              Center(
                child: Text(
                  VerifyPhoneKeys.resendIn.tr(namedArgs: {'timer': '00:45'}),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.colors.brandBlue,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildConfirmButton(),
            ],
          ),
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

  Widget _buildConfirmButton() {
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
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: Text(
                CommonKeys.confirm.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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
      onTap: () => focusNode.requestFocus(),
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
