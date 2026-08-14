import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/step_tracker.dart';
import '../widgets/profile_identity.dart';

import '../../../auth/domain/entities/country_dial_code.dart';
import '../../../auth/presentation/widgets/phone_field.dart';
import '../../../../core/theme/theme_context.dart';

const _kSupportIcon = 'assets/more/customer service.svg';

/// Step one of changing the account's mobile number: entering the new one.
///
/// Static UI — the field is a mock-up of the design's empty state and the
/// country code is fixed; nothing is wired to a backend yet.
class DriverChangePhoneScreen extends StatefulWidget {
  const DriverChangePhoneScreen({super.key});

  @override
  State<DriverChangePhoneScreen> createState() => _DriverChangePhoneScreenState();
}

class _DriverChangePhoneScreenState extends State<DriverChangePhoneScreen> {
  final _phoneController = TextEditingController();
  CountryDialCode _country = CountryDialCode.fallback;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
              ProfileIdentity(
                station: 'driver_mock_profile.station_alhamd'.tr(),
                showEditBadge: true,
              ),
              const SizedBox(height: 32),
              StepTracker(
                steps: [
                  StepItem(
                    ChangePhoneKeys.stepChangeNumber.tr(),
                    TrackerStepState.current,
                  ),
                  StepItem(
                    ChangePhoneKeys.stepVerifyCode.tr(),
                    TrackerStepState.pending,
                  ),
                  StepItem(
                    ChangePhoneKeys.stepReverify.tr(),
                    TrackerStepState.pending,
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Text(
                ChangePhoneKeys.title.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
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
    );
  }

  /// The warning about being signed out, with its info mark on the left.
  Widget _buildNotice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            ChangePhoneKeys.warning.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.7, color: context.colors.textSecondary),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: context.colors.brandBlue, width: 1.5),
          ),
          child: Center(
            child: Text(
              'i',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: context.colors.brandBlue,
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
          onTap: () => context.push(AppRoutes.driverVerifyPhone),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: Text(
                ChangePhoneKeys.sendCode.tr(),
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

  Widget _buildContactDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(height: 1, thickness: 1, color: context.colors.borderHairline),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            ChangePhoneKeys.contactUs.tr(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.colors.brandBlue,
            ),
          ),
        ),
        Expanded(
          child: Divider(height: 1, thickness: 1, color: context.colors.borderHairline),
        ),
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
            border: Border.all(color: context.colors.borderHairline),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Grey artwork, so it is tinted to the button's green.
              SvgPicture.asset(
                _kSupportIcon,
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(context.colors.brandGreen, BlendMode.srcIn),
              ),
              const SizedBox(width: 10),
              Text(
                CommonKeys.support.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.colors.brandGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
