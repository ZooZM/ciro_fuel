import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../orders/presentation/constants/order_presentation.dart';
import '../widgets/driver_navigation_stats_card.dart';
import '../widgets/driver_navigation_bottom_sheet.dart';
import '../../../../shared/entities/order.dart';

/// spec 007: was a fixed mock-up — station name, address, quantity, fuel
/// type and the "12.7 km / 17 min" stats were all baked into translation
/// strings rather than read off [order], and the destination/contact
/// buttons were `onPressed: () {}` stubs. Fixed to read the real active
/// delivery: distance/ETA are derived from `order.driverLocation` and
/// `order.destination` and are `null` (never a guessed figure) until both
/// are known, matching every other ETA/distance surface in the app.
class DriverNavigationScreen extends StatelessWidget {
  const DriverNavigationScreen({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    // deliveryAddressText is the snapshot taken at order creation (FR-009/
    // FR-030); stationAddressText is only a fallback for an order placed
    // before the station had one on file.
    final stationLabel =
        (order.stationName?.isNotEmpty ?? false) ? order.stationName! : null;
    final addressLabel = order.deliveryAddressText?.isNotEmpty == true
        ? order.deliveryAddressText!
        : (order.stationAddressText ?? OrderPresentation.destinationLabel(order));

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        appBar: AppBar(
          backgroundColor: context.colors.canvas,
          elevation: 0,
          centerTitle: true,
          title: const AppLogo(),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconCard(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 2.0),
                child: Icon(Icons.arrow_back_ios_new, size: 20, color: context.colors.textPrimary),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            // Title + Stats area at top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: context.colors.canvas,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      DriverNavigationKeys.title.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      DriverNavigationKeys.subtitle.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DriverNavigationStatsCard(
                      orderId: order.id,
                      distance: OrderPresentation.distanceLabel(order.driverLocation, order.destination),
                      expectedTime: OrderPresentation.etaLabel(order),
                      fuelType: OrderPresentation.fuelLabel(order.fuelType),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            // feature 013 US5b (FR-041): the fixed screenshot that used to sit
            // here — with four inert zoom/reload/share controls floating over
            // it — presented as a live map and was not one. Removed rather
            // than faked: turn-by-turn stays with the device's own maps app
            // (FR-041a), reached by "Start Navigation" in the sheet below.

            // Bottom Sheet Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DriverNavigationBottomSheet(
                orderId: order.id,
                stationLabel: stationLabel,
                addressLabel: addressLabel,
                phone: order.clientSummary?.phone,
                quantityLiters: order.quantityLiters,
                fuelTypeLabel: OrderPresentation.fuelLabel(order.fuelType),
                etaLabel: OrderPresentation.etaLabel(order),
                destination: order.destination,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

