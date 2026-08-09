import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../constants/order_formatting.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit(getOrders: getIt())..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(OrdersKeys.listTitle.tr())),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.clientCreateOrder),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) => switch (state) {
            OrdersLoading() => const Center(child: CircularProgressIndicator()),
            OrdersLoadFailure() => Center(
              child: TextButton(
                onPressed: () => context.read<OrdersCubit>().load(),
                child: Text(OrdersKeys.loadFailed.tr()),
              ),
            ),
            OrdersLoaded(:final orders) when orders.isEmpty => Center(
              child: Text(OrdersKeys.empty.tr()),
            ),
            OrdersLoaded(:final orders) => RefreshIndicator(
              onRefresh: () => context.read<OrdersCubit>().load(),
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text(
                      '${OrderFormatting.litres(order.quantityLiters)} · '
                      '${order.fuelType.name}',
                    ),
                    subtitle: Text(order.status.wire),
                    onTap: () =>
                        context.push(AppRoutes.clientOrderDetail(order.id)),
                  );
                },
              ),
            ),
          },
        ),
      ),
    );
  }
}
