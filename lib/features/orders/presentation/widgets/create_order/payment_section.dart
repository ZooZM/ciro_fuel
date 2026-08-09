import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';

/// "5. طريقة الدفع" — the Sadaad payment-method badge.
class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      title: CreateOrderKeys.sectionPayment.tr(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(color: AppColors.itemBorder),
        ),
        child: SvgPicture.asset(
          AppAssets.sadaadLogo,
          height: AppSizes.orderPaymentLogoHeight,
        ),
      ),
    );
  }
}
