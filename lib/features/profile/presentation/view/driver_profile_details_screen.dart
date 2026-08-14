import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/order_card.dart';
import '../widgets/profile_identity.dart';

class DriverProfileDetailsScreen extends StatelessWidget {
  const DriverProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Avatar & Identity
            ProfileIdentity(
              station: 'driver_mock_profile.station_alhamd'.tr(),
              showEditBadge: true,
              onEdit: () {
                // Handle edit
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Contact Info
            Align(
              alignment: Alignment.centerRight,
              child: Text('driver_profile_details.contact_info'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.textSecondary)),
            ),
            const SizedBox(height: AppSpacing.sm),
            OrderCard(
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    value: '5X XXX XXXX',
                    icon: Icons.phone_outlined,
                    trailingIcon: Icons.check,
                    trailingColor: context.colors.brandGreen,
                  ),
                  const Divider(height: 16),
                  _buildDetailRow(
                    context,
                    value: 'mohamed.ahmed@example.com',
                    icon: Icons.email_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Company Info
            Align(
              alignment: Alignment.centerRight,
              child: Text('driver_profile_details.associated_company'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.textSecondary)),
            ),
            const SizedBox(height: AppSpacing.sm),
            OrderCard(
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    value: 'driver_mock_profile.station_alhamd'.tr(),
                    trailingText: 'driver_profile_details.currently'.tr(),
                    trailingIcon: Icons.check,
                    trailingColor: context.colors.brandGreen,
                  ),
                  const Divider(height: 16),
                  _buildDetailRow(
                    context,
                    value: 'driver_mock_profile.company_diesel'.tr(),
                    trailingText: 'driver_profile_details.previously'.tr(),
                    valueColor: context.colors.brandBlue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Account Info
            Align(
              alignment: Alignment.centerRight,
              child: Text('driver_profile_details.account_info'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.textSecondary)),
            ),
            const SizedBox(height: AppSpacing.sm),
            OrderCard(
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    label: 'driver_profile_details.rating'.tr(),
                    value: '4.8',
                    valueIcon: Icons.star_border,
                    valueIconColor: Colors.orange,
                  ),
                  const Divider(height: 16),
                  _buildDetailRow(
                    context,
                    label: 'driver_profile_details.account_code'.tr(),
                    value: 'GS-MA-526',
                  ),
                  const Divider(height: 16),
                  _buildDetailRow(
                    context,
                    label: 'driver_profile_details.join_date'.tr(),
                    value: 'driver_mock_profile.date_sept_12'.tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Change Phone Button
            _buildChangePhoneButton(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildChangePhoneButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.driverChangePhone),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: context.colors.brandGreen.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.colors.borderHairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('driver_profile_details.change_phone'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.colors.brandGreen)),
            const SizedBox(width: 8),
            Icon(Icons.edit_outlined, color: context.colors.brandGreen, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    String? label,
    required String value,
    IconData? icon,
    Color? iconColor,
    IconData? trailingIcon,
    Color? trailingColor,
    String? trailingText,
    Color? valueColor,
    IconData? valueIcon,
    Color? valueIconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Right Side (First child in RTL)
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? context.colors.textSecondary, size: 20),
                const SizedBox(width: 8),
              ],
              if (label == null)
                Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: valueColor ?? context.colors.brandBlue))
              else
                Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
            ],
          ),
          // Left Side (Second child in RTL)
          Row(
            children: [
              if (trailingText != null) ...[
                Text(trailingText, style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
                const SizedBox(width: 4),
              ],
              if (label != null)
                Text(value, style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
              if (valueIcon != null) ...[
                const SizedBox(width: 4),
                Icon(valueIcon, color: valueIconColor ?? context.colors.textSecondary, size: 16),
              ],
              if (trailingIcon != null) ...[
                if (label != null || trailingText != null || valueIcon != null) const SizedBox(width: 8),
                Icon(trailingIcon, color: trailingColor ?? context.colors.textSecondary, size: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
