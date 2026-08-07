import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../widgets/profile_identity.dart';

/// The account's own page: photo and name, contact details, the stations tied
/// to the account, and its registration information.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light.canvas,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            children: [
              const AppTopBar(),
              const SizedBox(height: 32),
              const ProfileIdentity(showEditBadge: true),
              const SizedBox(height: 32),
              _buildSectionTitle('بيانات التواصل'),
              const SizedBox(height: 12),
              _buildCard([
                _buildContactItem(
                  text: '5X XXX XXXX',
                  icon: Icons.call_outlined,
                  isVerified: true,
                ),
                _buildDivider(),
                _buildContactItem(
                  text: 'mohamed.ahmed@examlpe.com',
                  iconPath: 'assets/more/message.svg',
                ),
              ]),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('المحطات المرتبطة بحسابك'),
                  Text(
                    '3 محطات',
                    style: TextStyle(
                      color: AppColors.light.brandBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCard([
                _buildStationItem(
                  name: 'طريق أنس بن مالك، حي الملقا',
                  isActive: true,
                ),
                _buildDivider(),
                _buildStationItem(
                  name: 'رفح، الخليج الرياض',
                  isActive: true,
                ),
                _buildDivider(),
                _buildStationItem(
                  name: 'مزايا فيول مكة البيبان',
                  isActive: false,
                ),
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle('معلومات الحساب'),
              const SizedBox(height: 12),
              _buildCard([
                _buildAccountInfoItem('كود الحساب', 'GS-MA-526'),
                _buildDivider(),
                _buildAccountInfoItem('تاريخ الإنضمام', '9 ربيع الأول 1446'),
              ]),
              const SizedBox(height: 24),
              _buildChangeMobileButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.light.textTertiary,
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.light.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildContactItem({
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
            SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
            )
          else if (icon != null)
            Icon(
              icon,
              size: 20,
              color: AppColors.light.textTertiary,
            ),
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
                    color: AppColors.light.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          if (isVerified) ...[
            const SizedBox(width: 16),
            Icon(
              Icons.check,
              color: AppColors.light.brandGreen,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStationItem({
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
              isActive ? AppColors.light.brandGreen : AppColors.errorRed,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.slateCharcoal,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'نشطة',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.light.textTertiary,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            isActive ? Icons.check : Icons.close,
            color: isActive ? AppColors.light.brandGreen : AppColors.errorRed,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoItem(String title, String value) {
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
              color: AppColors.light.textPrimary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.light.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.light.borderHairline,
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
          border: Border.all(color: AppColors.light.borderHairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_outlined,
              color: AppColors.light.brandGreen,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'تغيير رقم الجوال',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.light.brandGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
