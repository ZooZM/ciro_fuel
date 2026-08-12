// `hide TextDirection`: easy_localization re-exports intl, whose
// TextDirection would shadow the one this screen lays out with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../home/presentation/widgets/current_order_card.dart';
import '../../../home/presentation/widgets/current_station_card.dart';
import '../../../home/presentation/widgets/new_request_button.dart';
import '../../../home/presentation/widgets/quick_glance_row.dart';
import '../../../home/presentation/widgets/section_header.dart';
import '../constants/client_stations_mock_data.dart';
import '../widgets/last_order_card.dart';
import '../widgets/stations_top_bar.dart';

/// محطاتك — the client's station, what they can order from it, and how their
/// last two orders went.
///
/// Built from the dashboard's cards rather than its own: this is the same
/// information, reached from the settings list instead of the home tab.
class ClientStationsScreen extends StatelessWidget {
  const ClientStationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: AppSpacing.gutter,
              right: AppSpacing.gutter,
              top: AppSpacing.lg,
              bottom: AppSpacing.space40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StationsTopBar(onBack: () => context.pop()),
                const SizedBox(height: AppSpacing.xl),
                CurrentStationCard(
                  name: ClientStationsMockData.stationName,
                  address: ClientStationsMockData.stationAddress,
                  onChangeStation: () {},
                ),
                const SizedBox(height: AppSpacing.xl),
                NewRequestButton(
                  onPressed: () => context.push(AppRoutes.clientCreateOrder),
                ),
                const SizedBox(height: AppSpacing.xxl),
                SectionHeader(StationsKeys.currentOrder.tr()),
                const SizedBox(height: AppSpacing.md),
                CurrentOrderCard(
                  order: ClientStationsMockData.currentOrder,
                  onTrackOrder: () {},
                  onContactDriver: () {},
                ),
                const SizedBox(height: AppSpacing.xxl),
                SectionHeader(StationsKeys.lastOrder.tr()),
                const SizedBox(height: AppSpacing.md),
                const LastOrderCard(),
                const SizedBox(height: AppSpacing.xxl),
                SectionHeader(StationsKeys.quickGlance.tr()),
                const SizedBox(height: AppSpacing.md),
                const QuickGlanceRow(stats: defaultOrderCountStats),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
