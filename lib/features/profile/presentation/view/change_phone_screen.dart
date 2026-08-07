import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/step_tracker.dart';
import '../widgets/profile_identity.dart';

import '../../../auth/domain/entities/country_dial_code.dart';
import '../../../auth/presentation/widgets/phone_field.dart';

const _kSupportIcon = 'assets/more/customer service.svg';

const _kNavy = Color(0xFF162155);
const _kGrey = Color(0xFF6B7280);
const _kBlue = Color(0xFF1E5FFF);
const _kGreen = Color(0xFF12A150);
const _kCanvas = Color(0xFFF4F6FA);
const _kBorder = Color(0xFFE7E9EF);

/// Step one of changing the account's mobile number: entering the new one.
///
/// Static UI — the field is a mock-up of the design's empty state and the
/// country code is fixed; nothing is wired to a backend yet.
class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final _phoneController = TextEditingController();
  CountryDialCode _country = CountryDialCode.fallback;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
                const SizedBox(height: 32),
                const ProfileIdentity(),
                const SizedBox(height: 32),
                const StepTracker(
                  steps: [
                    StepItem('تغيير الرقم', TrackerStepState.current),
                    StepItem('رمز التحقق', TrackerStepState.pending),
                    StepItem('إعادة التوثيق', TrackerStepState.pending),
                  ],
                ),
                const SizedBox(height: 36),
                const Text(
                  'تغيير رقم الجوال',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _kNavy,
                  ),
                ),
                const SizedBox(height: 12),
                _buildNotice(),
                const SizedBox(height: 28),
                PhoneField(
                  controller: _phoneController,
                  country: _country,
                  onCountryChanged: (c) => setState(() => _country = c),
                ),
                const SizedBox(height: 24),
                _buildSendCodeButton(context),
                const SizedBox(height: 40),
                _buildContactDivider(),
                const SizedBox(height: 16),
                _buildSupportButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The warning about being signed out, with its info mark on the left.
  Widget _buildNotice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Text(
            'برجاء العلم أنه بعد تغيير رقم الهاتف، سيتم تسجيل خروجك من الحساب '
            'و إنتظار إعادة توثيق الحساب مرة إخري.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.7, color: _kGrey),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _kBlue, width: 1.5),
          ),
          child: const Center(
            child: Text(
              'i',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _kBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildSendCodeButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kBlue,
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
          onTap: () => context.push(AppRoutes.clientVerifyPhone),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: Text(
                'إرسل رمز التحقق',
                style: TextStyle(
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

  Widget _buildContactDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(height: 1, thickness: 1, color: _kBorder)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'تواصل معنا',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _kBlue,
            ),
          ),
        ),
        Expanded(child: Divider(height: 1, thickness: 1, color: _kBorder)),
      ],
    );
  }

  Widget _buildSupportButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push(AppRoutes.support, extra: true),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Grey artwork, so it is tinted to the button's green.
              SvgPicture.asset(
                _kSupportIcon,
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(_kGreen, BlendMode.srcIn),
              ),
              const SizedBox(width: 10),
              const Text(
                'الدعم',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _kGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

