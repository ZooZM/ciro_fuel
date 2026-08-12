import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../cubit/delivery_cubit.dart';
import '../cubit/delivery_state.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeliveryCubit(
        getActiveOrder: getIt(),
        locationStream: getIt(),
        socket: getIt(),
      )..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(DriverKeys.myDelivery.tr())),
        body: BlocBuilder<DeliveryCubit, DeliveryState>(
          builder: (context, state) => switch (state) {
            DeliveryNoActiveOrder() => Center(
              child: TextButton(
                onPressed: () => context.read<DeliveryCubit>().load(),
                child: Text(DriverKeys.noActiveDeliveryRetry.tr()),
              ),
            ),
            DeliveryFailureState() => Center(
              child: TextButton(
                onPressed: () => context.read<DeliveryCubit>().load(),
                child: Text(DriverKeys.loadFailedRetry.tr()),
              ),
            ),
            DeliveryActive(:final order, :final streaming) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '${order.quantityLiters} ${CommonKeys.litre.tr()} · '
                  '${order.fuelType.name}',
                ),
                const SizedBox(height: 8),
                // `status.wire` is the protocol value, not display copy — it
                // stays as-is inside the translated label.
                Text(
                  DriverKeys.status.tr(
                    namedArgs: {'status': order.status.wire},
                  ),
                ),
                const SizedBox(height: 8),
                if (!streaming)
                  Text(
                    DriverKeys.locationSharingOff.tr(),
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () =>
                      context.push(AppRoutes.driverOrderDetail(order.id)),
                  child: Text(DriverKeys.openDelivery.tr()),
                ),
              ],
            ),
          },
        ),
      ),
    );
  }
}
