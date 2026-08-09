import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../constants/order_mock_data.dart';
import '../widgets/order_top_bar.dart';
import '../widgets/track_order/driver_card.dart';
import '../widgets/track_order/pickup_code_card.dart';
import '../widgets/track_order/track_order_title.dart';
import '../widgets/track_order/tracking_bottom_bar.dart';
import '../widgets/track_order/tracking_map.dart';
import '../widgets/track_order/tracking_stats_card.dart';
import '../widgets/track_order/tracking_timeline_card.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.xl),
                  children: [
                    _inset(
                      OrderTopBar(
                        notificationCount: OrderMockData.notificationCount,
                        onBack: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(height: AppSizes.orderSectionGap),
                    _inset(const TrackOrderTitle()),
                    const SizedBox(height: AppSpacing.lg),
                    _inset(const TrackingStatsCard()),
                    const SizedBox(height: AppSpacing.lg),
                    // Full-bleed: the map is the only thing that touches the
                    // screen edges.
                    const TrackingMap(),
                    const SizedBox(height: AppSpacing.lg),
                    _inset(const DriverCard()),
                    const SizedBox(height: AppSpacing.lg),
                    _inset(const PickupCodeCard()),
                    const SizedBox(height: AppSpacing.lg),
                    _inset(const TrackingTimelineCard()),
                  ],
                ),
              ),
              const TrackingBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// The page gutter every card sits in — the map alone opts out of it.
  Widget _inset(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
    child: child,
  );
}
