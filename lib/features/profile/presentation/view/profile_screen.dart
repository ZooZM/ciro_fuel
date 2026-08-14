// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../widgets/profile_identity.dart';

/// The account's own page: photo and name, contact details, the stations tied
/// to the account, and its registration information.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          children: [
            const AppTopBar(),
            const SizedBox(height: 32),
            const ProfileIdentity(showEditBadge: true),
            const SizedBox(height: 32),
            _buildSectionTitle(context, ProfileKeys.contactInfo.tr()),
            const SizedBox(height: 12),
            _buildCard(context, [
              _buildContactItem(
                context,
                text: '5X XXX XXXX',
                icon: Icons.call_outlined,
                isVerified: true,
              ),
              _buildDivider(context),
              _buildContactItem(
                context,
                text: 'mohamed.ahmed@examlpe.com',
                iconPath: 'assets/more/message.svg',
              ),
            ]),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle(context, ProfileKeys.linkedStations.tr()),
                Text(
                  ProfileKeys.stationsCount.tr(namedArgs: {'count': '3'}),
                  style: TextStyle(
                    color: context.colors.brandBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildCard(context, [
              _buildStationItem(
                context,
                name: context.locale.languageCode == 'ar' ? 'driver_mock_profile.anas_road'.tr() : 'Anas Bin Malik Road, Al Malqa District',
                isActive: true,
              ),
              _buildDivider(context),
              _buildStationItem(
                context,
                name: 'driver_mock_profile.rafah'.tr(),
                isActive: true,
              ),
              _buildDivider(context),
              _buildStationItem(
                context,
                name: 'driver_mock_profile.mazaya'.tr(),
                isActive: false,
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle(context, ProfileKeys.accountInfo.tr()),
            const SizedBox(height: 12),
            _buildCard(context, [
              _buildAccountInfoItem(
                context,
                ProfileKeys.accountCode.tr(),
                'GS-MA-526',
              ),
              _buildDivider(context),
              _buildAccountInfoItem(
                context,
                ProfileKeys.joinDate.tr(),
                'driver_mock_profile.date_sept_9'.tr(),
              ),
            ]),
            const SizedBox(height: 24),
            _buildChangeMobileButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: context.colors.textTertiary,
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required String text,
    IconData? icon,
    String? iconPath,
    bool isVerified = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          if (iconPath != null)
            SvgPicture.asset(iconPath, width: 20, height: 20)
          else if (icon != null)
            Icon(icon, size: 20, color: context.colors.textTertiary),
          const SizedBox(width: 16),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          if (isVerified) ...[
            const SizedBox(width: 16),
            Icon(Icons.check, color: context.colors.brandGreen, size: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildStationItem(
    BuildContext context, {
    required String name,
    required bool isActive,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/more/station.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isActive ? context.colors.brandGreen : AppColors.errorRed,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                // Was AppColors.slateCharcoal, which is all but invisible on
                // the dark surface; this is body text like every other row's.
                color: context.colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            ProfileKeys.active.tr(),
            style: TextStyle(fontSize: 14, color: context.colors.textTertiary),
          ),
          const SizedBox(width: 6),
          Icon(
            isActive ? Icons.check : Icons.close,
            color: isActive ? context.colors.brandGreen : AppColors.errorRed,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoItem(
    BuildContext context,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: context.colors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.colors.borderHairline,
    );
  }

  /// Entry point to the phone-change flow, whose first stop is the code the
  /// new number is sent.
  Widget _buildChangeMobileButton(BuildContext context) {
    return InkWell(
      onTap: () => context.push(AppRoutes.clientChangePhone),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.borderHairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_outlined,
              color: context.colors.brandGreen,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              ProfileKeys.changePhone.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.colors.brandGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
