import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

class SupportOrderProblemCard extends StatefulWidget {
  const SupportOrderProblemCard({super.key});

  @override
  State<SupportOrderProblemCard> createState() => _SupportOrderProblemCardState();
}

class _SupportOrderProblemCardState extends State<SupportOrderProblemCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.greenTint,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(_isExpanded ? 0 : 12),
                bottomRight: Radius.circular(_isExpanded ? 0 : 12),
              ),
              border: Border.all(color: context.colors.brandGreen),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssets.supportGasGunIcon,
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 'عندك مشكلة في طلب ؟'
                            : 'Do you have a problem with an order?',
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 'اختر الطلب و بلغ عنه و سيقوم الدعم بالتواصل معك في أقرب وقت'
                            : 'Select the order and report it, and support will contact you as soon as possible',
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: context.colors.brandGreen,
                ),
              ],
            ),
          ),
        ),
        // Expanded Body
        if (_isExpanded)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.blueTint,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border(
                left: BorderSide(color: context.colors.brandBlue),
                right: BorderSide(color: context.colors.brandBlue),
                bottom: BorderSide(color: context.colors.brandBlue),
              ),
            ),
            child: Column(
              children: [
                _buildMockOrderCard(
                  context,
                  status: Localizations.localeOf(context).languageCode == 'ar' ? 'قيد التوصيل' : 'Out for delivery',
                  statusColor: context.colors.brandBlue,
                  address: Localizations.localeOf(context).languageCode == 'ar' ? 'طريق أنس بن مالك، حي الملقا' : 'Anas Ibn Malik Rd, Al Malqa',
                  hasProgress: true,
                  progress: 0.5,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildMockOrderCard(
                  context,
                  status: Localizations.localeOf(context).languageCode == 'ar' ? 'الدفع (مؤجل)' : 'Payment (Deferred)',
                  statusColor: context.colors.brandOrange,
                  address: Localizations.localeOf(context).languageCode == 'ar' ? 'رفح، الخليج الرياض' : 'Rafha, Al Khaleej Riyadh',
                  hasProgress: true,
                  progress: 1.0,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'الطلب غير موجود أو المشكلة في طلب غير حالي ؟'
                      : 'Order not found or the problem is in a different order?',
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'إرسل كود الطلب مع المشكلة'
                      : 'Send the order code with the problem',
                  style: TextStyle(
                    color: context.colors.brandBlue,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.colors.brandBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.supportSendIcon,
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.colors.borderHairline),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? 'أكتب المشكلة بوضوح'
                                : 'Write the problem clearly',
                            style: TextStyle(
                              color: context.colors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMockOrderCard(BuildContext context, {required String status, required Color statusColor, required String address, required bool hasProgress, double progress = 0.5}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.dashboardGasStationIcon,
            width: 40,
            height: 40,
            colorFilter: ColorFilter.mode(context.colors.brandGreen, BlendMode.srcIn),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Localizations.localeOf(context).languageCode == 'ar' ? 'بنزين 95 • 20,000 لتر' : 'Gasoline 95 • 20,000 L',
                      style: TextStyle(
                        color: context.colors.brandBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'ORD-2024-256',
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              status,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: context.colors.textPrimary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          if (hasProgress) ...[
                            const SizedBox(width: 4),
                            Container(
                              width: 32,
                              height: 6,
                              decoration: BoxDecoration(
                                color: context.colors.borderHairline,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Row(
                                children: [
                                  if (progress > 0)
                                    Expanded(
                                      flex: (progress * 100).toInt(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  if (progress < 1.0)
                                    Expanded(
                                      flex: ((1.0 - progress) * 100).toInt(),
                                      child: const SizedBox(),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        address,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.colors.brandBlue,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: SvgPicture.asset(AppAssets.dashboardDateIcon, width: 12, height: 12, colorFilter: ColorFilter.mode(context.colors.brandGreen, BlendMode.srcIn)),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Localizations.localeOf(context).languageCode == 'ar' ? '13 أغسطس 2024' : '13 August 2024',
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: SvgPicture.asset(AppAssets.dashboardHourIcon, width: 12, height: 12, colorFilter: ColorFilter.mode(context.colors.brandGreen, BlendMode.srcIn)),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Localizations.localeOf(context).languageCode == 'ar' ? '06:30 صباحاً' : '06:30 AM',
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
