import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/create_order_strings.dart';

/// The sticky "تأكيد الطلب" call-to-action, swapping to a spinner while
/// the (mock) order submission is in flight.
class ConfirmButton extends StatelessWidget {
  const ConfirmButton({required this.submitting, required this.onPressed, super.key});

  final bool submitting;
  final VoidCallback? onPressed;

  static const _pumpIconSize = 22.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.orderConfirmButtonHeight,
      child: ElevatedButton(
        onPressed: submitting ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(OrderCard.radius),
          ),
        ),
        child: submitting
            ? const SizedBox(
                width: AppSizes.progressDiameter,
                height: AppSizes.progressDiameter,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.progressStrokeWidth,
                  color: Colors.white,
                ),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      CreateOrderStrings.confirmOrder,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.lg,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: SvgPicture.asset(
                        AppAssets.dashboardGasStationIcon,
                        width: _pumpIconSize,
                        height: _pumpIconSize,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
