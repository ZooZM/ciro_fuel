import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../constants/order_detail_strings.dart';

/// The floating "الدعم" pill anchored over the order-detail screen.
class SupportFab extends StatelessWidget {
  const SupportFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.orderPrimaryActionHeight,
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.tile),
          onTap: () => context.push(AppRoutes.support),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Text(
                  OrderDetailStrings.support,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Icon(
                  Icons.headset_mic_outlined,
                  color: Colors.white,
                  size: AppSizes.iconLg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
