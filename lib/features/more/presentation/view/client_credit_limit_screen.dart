import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Only NumberFormat: intl also exports a TextDirection that would shadow the
// one this file lays out with.
import 'package:intl/intl.dart' show NumberFormat;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/step_tracker.dart';

// A 16x16 stroked credit card, drawn in Ignition Orange — retinted per use.
const _kCardIcon = 'assets/more/payment.svg';
// The same document glyph the المزيد screen uses for الشروط و الأحكام.
const _kTermsIcon = 'assets/more/order.svg';

// Mirrors of AppColors.light — the palette lives on a const *instance*, whose
// fields Dart will not read inside a const expression, so the values are
// restated here the way the other client screens do.
const _kNavy = Color(0xFF162155);
const _kGrey = Color(0xFF6B7280);
const _kGreyLight = Color(0xFF9CA3AF);
const _kBlue = Color(0xFF1E5FFF);
const _kGreen = Color(0xFF12A150);
const _kGreenTint = Color(0xFFE4F7EC);
const _kOrange = Color(0xFFFF5810);
const _kOrangeTint = Color(0xFFFEEEDF);
const _kRed = Color(0xFFEF3F3F);
const _kRedTint = Color(0xFFFDE9E9);
const _kCanvas = Color(0xFFF4F6FA);
const _kSurface = Color(0xFFFFFFFF);
const _kSurface2 = Color(0xFFF0F2F7);
const _kBorder = Color(0xFFE7E9EF);

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
  // Latin digits and grouping, as in the design — an Arabic locale would print
  // Arabic-Indic numerals instead.
  static final NumberFormat _amountFormat = NumberFormat('#,##0.00', 'en_US');

  double _amount = 200000;
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
      _amount = (_amount + delta).clamp(_kMinAmount, double.maxFinite);
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _kCanvas,
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
                  const Text(
                    'أطلب حدك الإئتماني أو جدده',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _kNavy,
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
      ),
    );
  }

  Widget _buildCurrentLimitCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const _IconTile(
                background: _kOrangeTint,
                color: _kOrange,
                size: 44,
                iconSize: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                'الحد الإئتماني',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _kNavy,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _kRedTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'غير متاح',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _kRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // Empty state — there is no limit to show yet.
          const _IconTile(
            background: _kRedTint,
            color: _kRed,
            size: 52,
            iconSize: 24,
          ),
          const SizedBox(height: 16),
          const Text(
            'لا يوجد حد ائتماني نشط. قدّم طلبك أدناه.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: _kGrey),
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
        color: _kSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طلب الحد الإئتماني',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _kNavy,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '9 ربيع الأول 1448',
                    style: TextStyle(fontSize: 12, color: _kGrey),
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
                  color: _kGreenTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'قيد المراجعة',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _kGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'الحد المطلوب',
            style: TextStyle(fontSize: 13, color: _kGrey),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                _amountFormat.format(_requestedAmount),
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _kOrange,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'ر.س',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _kOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const StepTracker(
            steps: [
              StepItem('تم الإرسال', TrackerStepState.done),
              StepItem('قيد المراجعة', TrackerStepState.current),
              StepItem('القرار', TrackerStepState.pending),
            ],
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'الرد المتوقع خلال 2-3 أيام عمل',
              style: TextStyle(fontSize: 12, color: _kGrey),
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
        color: _kSurface,
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
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _kNavy,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'ر.س',
                  style: TextStyle(
                    fontSize: 12,
                    color: _kGrey,
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإقرار بطلب الحد الائتماني',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _kNavy,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'أقر بأنني أطلب حدًا ائتمانيًا من شركة البترول بصفتها الجهة '
                  'المانحة، وأن هذا الطلب يخضع لمراجعة واعتماد الشركة وفق '
                  'سياساتها الداخلية.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.7,
                    color: _kGrey,
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
          colorFilter: const ColorFilter.mode(
            _kBlue,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'طبق الشروط و الأحكام',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _kBlue,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.info_outline,
          size: 24,
          color: _kBlue,
        ),
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
          color: _kBlue,
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
                  const Text(
                    'اطلب حدك الإئتماني',
                    style: TextStyle(
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
      color: _kSurface2,
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
                ? _kGreyLight
                : _kBlue,
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
        color: _kSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kBorder),
      ),
      child: value
          ? const Icon(
              Icons.check,
              size: 18,
              color: _kBlue,
            )
          : null,
    );
  }
}
