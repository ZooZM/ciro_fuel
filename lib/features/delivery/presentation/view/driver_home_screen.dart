import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
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
        appBar: AppBar(title: const Text('My delivery')),
        body: BlocBuilder<DeliveryCubit, DeliveryState>(
          builder: (context, state) => switch (state) {
            DeliveryNoActiveOrder() => Center(
              child: TextButton(
                onPressed: () => context.read<DeliveryCubit>().load(),
                child: const Text('No active delivery. Tap to check again.'),
              ),
            ),
            DeliveryFailureState() => Center(
              child: TextButton(
                onPressed: () => context.read<DeliveryCubit>().load(),
                child: const Text('Could not load your delivery. Tap to retry.'),
              ),
            ),
            DeliveryActive(:final order, :final streaming) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('${order.quantityLiters} L · ${order.fuelType.name}'),
                const SizedBox(height: 8),
                Text('Status: ${order.status.wire}'),
                const SizedBox(height: 8),
                if (!streaming)
                  const Text(
                    'Location sharing is off — enable location permission to continue.',
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.push(AppRoutes.driverOrderDetail(order.id)),
                  child: const Text('Open delivery'),
                ),
              ],
            ),
          },
        ),
      ),
    );
  }
}
