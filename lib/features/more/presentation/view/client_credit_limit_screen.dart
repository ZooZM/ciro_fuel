// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Only NumberFormat: intl also exports a TextDirection that would shadow the
// one this file lays out with.
import 'package:intl/intl.dart' show NumberFormat;

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/step_tracker.dart';

// A 16x16 stroked credit card, drawn in Ignition Orange — retinted per use.
const _kCardIcon = 'assets/more/payment.svg';
// The same document glyph the المزيد screen uses for الشروط و الأحكام.
const _kTermsIcon = 'assets/more/order.svg';

/// How much a single tap on ‏+‎/‏−‎ moves the requested limit, and the floor it
/// will not go below.
const double _kAmountStep = 10000;
const double _kMinAmount = 10000;

/// The client's credit limit: what they have today (nothing, until the petrol
/// company grants one) and the form for requesting or renewing it.
class ClientCreditLimitScreen extends StatefulWidget {
  const ClientCreditLimitScreen({super.key});

  @override
  State<ClientCreditLimitScreen> createState() =>
      _ClientCreditLimitScreenState();
}

class _ClientCreditLimitScreenState extends State<ClientCreditLimitScreen> {
  double _amount = CreditLimitConstants.initialAmount;
  bool _firstAcknowledged = true;
  bool _secondAcknowledged = true;

  /// Once submitted the form gives way to the request's status card; the
  /// amount is frozen at whatever was asked for.
  bool _submitted = false;
  double _requestedAmount = 0;

  /// The request only goes through once both acknowledgements are ticked.
  bool get _canSubmit => _firstAcknowledged && _secondAcknowledged;

  void _changeAmount(double delta) {
    setState(() {
      _amount = (_amount + delta).clamp(
        CreditLimitConstants.minAmount,
        double.maxFinite,
      );
    });
  }

  void _submit() {
    setState(() {
      _requestedAmount = _amount;
      _submitted = true;
    });
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
              const SizedBox(height: 24),
              _buildCurrentLimitCard(),
              // Once the request is in, the form is replaced by its status —
              // there is nothing left to fill in until the company answers.
              if (_submitted) ...[
                const SizedBox(height: 40),
                _buildRequestStatusCard(),
              ] else ...[
                const SizedBox(height: 32),
                Text(
                  CreditLimitKeys.requestOrRenew.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAmountStepper(),
                const SizedBox(height: 32),
                _buildAcknowledgement(
                  value: _firstAcknowledged,
                  onChanged: (value) =>
                      setState(() => _firstAcknowledged = value),
                ),
                const SizedBox(height: 20),
                _buildAcknowledgement(
                  value: _secondAcknowledged,
                  onChanged: (value) =>
                      setState(() => _secondAcknowledged = value),
                ),
                const SizedBox(height: 24),
                _buildTermsRow(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLimitCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _IconTile(
                background: context.colors.orangeTint,
                color: context.colors.brandOrange,
                size: 44,
                iconSize: 20,
              ),
              const SizedBox(width: 12),
              Text(
                CreditLimitKeys.title.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.colors.redTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  CreditLimitKeys.unavailable.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.colors.brandRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // Empty state — there is no limit to show yet.
          _IconTile(
            background: context.colors.redTint,
            color: context.colors.brandRed,
            size: 52,
            iconSize: 24,
          ),
          const SizedBox(height: 16),
          Text(
            CreditLimitKeys.noActiveLimit.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Where the submitted request stands: what was asked for, and how far it
  /// has got through تم الإرسال ← قيد المراجعة ← القرار.
  Widget _buildRequestStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CreditLimitKeys.requestTitle.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '9 ربيع الأول 1448',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.colors.greenTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  CreditLimitKeys.underReview.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.colors.brandGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            CreditLimitKeys.requestedLimit.tr(),
            style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                _amountFormat.format(_requestedAmount),
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: context.colors.brandOrange,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                CommonKeys.currencySymbol.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.colors.brandOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          StepTracker(
            steps: [
              StepItem(CreditLimitKeys.stepSent.tr(), TrackerStepState.done),
              StepItem(
                CreditLimitKeys.stepReview.tr(),
                TrackerStepState.current,
              ),
              StepItem(
                CreditLimitKeys.stepDecision.tr(),
                TrackerStepState.pending,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              CreditLimitKeys.expectedReply.tr(),
              style: TextStyle(
                fontSize: 12,
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ‏+‎ on the right and ‏−‎ on the left, with the requested figure between
  /// them.
  Widget _buildAmountStepper() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadowCard,
      ),
      child: Row(
        children: [
          _StepperButton(
            icon: Icons.add,
            onTap: () => _changeAmount(_kAmountStep),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _amountFormat.format(_amount),
                  // The grouped figure reads left-to-right even on this
                  // right-to-left page.
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  CommonKeys.currencySymbol.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _StepperButton(
            icon: Icons.remove,
            // Held at the floor rather than hidden, so the row keeps its shape.
            onTap: _amount > _kMinAmount
                ? () => _changeAmount(-_kAmountStep)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildAcknowledgement({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CreditLimitKeys.acknowledgementTitle.tr(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  CreditLimitKeys.acknowledgementBody.tr(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.7,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Nudged down so the box lines up with the title rather than the
          // whole two-paragraph block.
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: _CheckBox(value: value),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsRow() {
    return Row(
      children: [
        SvgPicture.asset(
          _kTermsIcon,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            context.colors.brandBlue,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          CreditLimitKeys.applyTerms.tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.colors.brandBlue,
          ),
        ),
        const Spacer(),
        Icon(Icons.info_outline, size: 24, color: context.colors.brandBlue),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Opacity(
      // Both acknowledgements are ticked by default; untick one and the button
      // dims rather than disappearing.
      opacity: _canSubmit ? 1 : 0.5,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.brandBlue,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _canSubmit ? AppColors.shadowFloating : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _canSubmit ? _submit : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    _kCardIcon,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    CreditLimitKeys.requestYourLimit.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The credit-card glyph on a tinted rounded square, used at two sizes.
class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.background,
    required this.color,
    required this.size,
    required this.iconSize,
  });

  final Color background;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: SvgPicture.asset(
          _kCardIcon,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }
}

/// One of the stepper's two square buttons. A null [onTap] greys the glyph out.
class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 52,
          height: 44,
          child: Icon(
            icon,
            size: 22,
            color: onTap == null
                ? context.colors.textTertiary
                : context.colors.brandBlue,
          ),
        ),
      ),
    );
  }
}

/// The acknowledgement tick — a white box that gains a blue check when set.
class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.borderHairline),
      ),
      child: value
          ? Icon(Icons.check, size: 18, color: context.colors.brandBlue)
          : null,
    );
  }
}
