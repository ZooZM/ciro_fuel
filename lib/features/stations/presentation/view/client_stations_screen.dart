import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/translation_keys.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/error_presenter.dart';
import '../../../../core/widgets/station_picker.dart';
import '../../domain/entities/station.dart';
import '../cubit/stations_cubit.dart';
import '../cubit/stations_state.dart';

/// The client's own stations, registered by their fuel company (spec 005
/// T110/FR-036). Read + favourite only — no create, rename or delete
/// affordance anywhere on this screen (FR-036b is the absence of those
/// controls, not a disabled state on them).
class ClientStationsScreen extends StatelessWidget {
  const ClientStationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StationsCubit>(
      create: (_) => getIt<StationsCubit>()..load(),
      child: const _StationsView(),
    );
  }
}

class _StationsView extends StatelessWidget {
  const _StationsView();

  Future<void> _toggleFavourite(BuildContext context, Station station) async {
    final ok = await context.read<StationsCubit>().toggleFavourite(
      station.id,
      !station.isFavourite,
    );
    if (!ok && context.mounted) {
      presentFailure(context, const Failure.server());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppTopBar(),
              const SizedBox(height: 24),
              Text(
                StationsKeys.title.tr(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<StationsCubit, StationsState>(
                  builder: (context, state) => switch (state) {
                    StationsLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    StationsFailureState(:final failure) => _ErrorView(
                      failure: failure,
                      onRetry: () => context.read<StationsCubit>().load(),
                    ),
                    StationsLoaded(:final stations) => stations.isEmpty
                        ? Center(
                            child: Text(
                              ProfileKeys.noStations.tr(),
                              style: TextStyle(color: context.colors.textSecondary),
                            ),
                          )
                        : ListView.separated(
                            itemCount: stations.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, index) => _StationCard(
                              station: stations[index],
                              onToggleFavourite: () =>
                                  _toggleFavourite(context, stations[index]),
                            ),
                          ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              failureMessage(failure),
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(CommonKeys.retry.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _StationCard extends StatelessWidget {
  const _StationCard({required this.station, required this.onToggleFavourite});

  final Station station;
  final VoidCallback onToggleFavourite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.shadowCard,
      ),
      child: Row(
        children: [
          FavouriteStar(
            isFavourite: station.isFavourite,
            onTap: onToggleFavourite,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        station.name?.isNotEmpty == true
                            ? station.name!
                            : station.addressText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    if (station.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: context.colors.greenTint,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          StationsKeys.defaultStation.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: context.colors.brandGreen,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (station.addressText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    station.addressText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
