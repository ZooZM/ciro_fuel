// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'order_detail_screen.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/theme/theme_context.dart';

class InvoicePaymentScreen extends StatelessWidget {
  const InvoicePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              children: [
                _buildTopBar(context),
                const SizedBox(height: 24),
                _buildSadadCard(context),
                const SizedBox(height: 12),
                Text(
                  InvoicePaymentKeys.sadadNote.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInvoiceDetailsCard(context),
                const SizedBox(height: 24),
                Center(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.file_download_outlined,
                      color: context.colors.brandBlue,
                    ),
                    label: Text(
                      InvoicePaymentKeys.downloadReceipt.tr(),
                      style: TextStyle(
                        color: context.colors.brandBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.brandBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const OrderDetailScreen(
                          orderId: 'mock',
                          mockState: MockOrderState.paid,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    InvoicePaymentKeys.confirmAndComplete.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return const AppTopBar();
  }

  Widget _buildSadadCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.brandOrange),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    InvoicePaymentKeys.invoiceData.tr(),
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '# 889241035',
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              SvgPicture.asset('assets/Order/Sadaad.svg', height: 32),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  InvoicePaymentKeys.invoiceNumber.tr(),
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.blueTint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '405213578926401',
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      AppAssets.copyIcon,
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                        context.colors.brandGreen,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                InvoicePaymentKeys.validUntil.tr(),
                style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${CommonKeys.today.tr()} 06:30 صباحاً',
                style: TextStyle(
                  color: context.colors.brandGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetailsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildBreakdownRow(
            context,
            '${FuelKeys.gasoline95.tr()} • 20,000 ${CommonKeys.litre.tr()}',
            '450,000.00 ${CommonKeys.currencySymbol.tr()}',
            isMain: true,
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            context,
            InvoicePaymentKeys.deliveryFee.tr(),
            '30.00 ${CommonKeys.currencySymbol.tr()}',
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            context,
            InvoicePaymentKeys.serviceFee.tr(),
            '30.00 ${CommonKeys.currencySymbol.tr()}',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.colors.blueTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  AppAssets.copyIcon,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    context.colors.brandBlue,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      InvoicePaymentKeys.deferredInvoice.tr(),
                      style: TextStyle(
                        color: context.colors.brandOrange,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      InvoicePaymentKeys.deferredNote.tr(),
                      style: TextStyle(
                        color: context.colors.brandGreen,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBreakdownRow(
            context,
            '${FuelKeys.gasoline95.tr()} • 20,000 ${CommonKeys.litre.tr()}',
            '450,000.00 ${CommonKeys.currencySymbol.tr()}',
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            context,
            InvoicePaymentKeys.deliveryFee.tr(),
            '30.00 ${CommonKeys.currencySymbol.tr()}',
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            context,
            InvoicePaymentKeys.serviceFee.tr(),
            '30.00 ${CommonKeys.currencySymbol.tr()}',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Divider(color: context.colors.borderHairline)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      InvoicePaymentKeys.hideDetails.tr(),
                      style: TextStyle(
                        color: context.colors.brandGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.visibility_off_outlined,
                      color: context.colors.brandGreen,
                      size: 14,
                    ),
                  ],
                ),
              ),
              Expanded(child: Divider(color: context.colors.borderHairline)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CommonKeys.total.tr(),
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '600,120.00 ',
                      style: TextStyle(
                        color: context.colors.brandGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: CommonKeys.currencySymbol.tr(),
                      style: TextStyle(
                        color: context.colors.brandGreen,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
    BuildContext context,
    String title,
    String value, {
    bool isMain = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: context.colors.textSecondary,
            fontSize: isMain ? 11 : 10,
            fontWeight: isMain ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: isMain ? 13 : 12,
            fontWeight: isMain ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
