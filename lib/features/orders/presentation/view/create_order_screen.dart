import 'dart:ui';

// `easy_localization` re-exports intl, whose own `TextDirection` would
// otherwise shadow the `dart:ui` one this screen sets RTL with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/enums/fuel_grade.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/payment_method.dart';
import '../../domain/usecases/create_order.dart';
import '../constants/order_formatting.dart';
import '../constants/order_mock_data.dart';
import '../widgets/create_order/confirm_button.dart';
import '../widgets/create_order/create_order_data.dart';
import '../widgets/create_order/delivery_section.dart';
import '../widgets/create_order/grade_section.dart';
import '../widgets/create_order/notes_section.dart';
import '../widgets/create_order/order_title.dart';
import '../widgets/create_order/payment_section.dart';
import '../widgets/create_order/quantity_section.dart';
import '../widgets/create_order/station_section.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/order_top_bar.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key, this.initialGradeBadge});

  /// Badge of the grade to start on ('91', '95', '98', 'D', 'K'), as passed by
  /// the home screen's طلب سريع tiles. Null falls back to the design's default.
  final String? initialGradeBadge;

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final Map<int, TextEditingController> _customQuantityControllers = {};
  final Map<int, int?> _quantities = {};
  final CreateOrder _createOrder = getIt<CreateOrder>();

  DeliveryOption _delivery = DeliveryOption.fastest;
  PaymentMethod _paymentMethod = PaymentMethod.direct;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final initial = _initialGradeIndex();
    _quantities[initial] = kOrderQuantities.first;
    _customQuantityControllers[initial] = TextEditingController();
  }

  /// Falls back to بنزين 98 — the grade selected in the design — when the
  /// screen is opened without a badge or with one that is not in the list.
  int _initialGradeIndex() {
    final badge = widget.initialGradeBadge;
    if (badge == null) return 2;
    final index = FuelGrade.values.indexWhere((g) => g.badge == badge);
    return index == -1 ? 2 : index;
  }

  @override
  void dispose() {
    for (final controller in _customQuantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleGrade(int index) {
    setState(() {
      if (_quantities.containsKey(index)) {
        _quantities.remove(index);
        _customQuantityControllers.remove(index)?.dispose();
      } else {
        _quantities[index] = kOrderQuantities.first;
        _customQuantityControllers[index] = TextEditingController();
      }
    });
  }

  void _onCustomQuantityChanged(int gradeIndex, String text) {
    setState(() => _quantities[gradeIndex] = null);
  }

  void _onPresetQuantitySelected(int gradeIndex, int litres) {
    setState(() {
      _quantities[gradeIndex] = litres;
      _customQuantityControllers[gradeIndex]!.clear();
    });
  }

  Future<void> _submit() async {
    if (_quantities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(CreateOrderKeys.selectAtLeastOneFuelType.tr()),
        ),
      );
      return;
    }

    final orderPayloads = <(FuelType, int)>[];
    for (final entry in _quantities.entries) {
      final grade = FuelGrade.values[entry.key];
      final controller = _customQuantityControllers[entry.key]!;
      final quantity = entry.value ?? int.tryParse(controller.text.trim());

      if (quantity == null || quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              CreateOrderKeys.enterValidQuantityFor.tr(
                namedArgs: {'grade': grade.title},
              ),
            ),
          ),
        );
        return;
      }

      final type = grade.type ?? FuelType.gasoline91;

      orderPayloads.add((type, quantity));
    }

    setState(() => _submitting = true);

    // Selecting several grades places one order per grade (the backend's
    // `POST /orders` is single-fuel-type, spec 004's routing/billing all
    // operate per order) — sequential, so a mid-batch failure still leaves
    // every order placed before it intact rather than raced against each other.
    final createdOrderIds = <String>[];
    Failure? failure;
    for (final (fuelType, quantity) in orderPayloads) {
      final result = await _createOrder(
        fuelType: fuelType,
        quantityLiters: quantity,
        paymentMethod: _paymentMethod,
      );
      final shouldStop = result.fold((f) {
        failure = f;
        return true;
      }, (order) {
        createdOrderIds.add(order.id);
        return false;
      });
      if (shouldStop) break;
    }

    if (!mounted) return;
    setState(() => _submitting = false);

    if (failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_messageFor(failure!))),
      );
      return;
    }

    if (createdOrderIds.isNotEmpty) {
      if (createdOrderIds.length == 1) {
        context.push(AppRoutes.clientOrderDetail(createdOrderIds.first));
      } else {
        context.go(AppRoutes.clientOrders);
      }
    }
  }

  /// A [ValidationFailure] already carries a specific, human-readable
  /// backend message (e.g. a credit shortfall naming the amount, FR-025) —
  /// surfaced directly rather than replaced with a generic string. Every
  /// other failure kind is deliberately generic (Constitution Principle III:
  /// no internal detail reaches the UI).
  String _messageFor(Failure failure) => switch (failure) {
    ValidationFailure(:final message) => message,
    _ => CreateOrderKeys.orderFailed.tr(),
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.lg,
                  AppSpacing.gutter,
                  AppSpacing.orderScreenBottomPadding,
                ),
                children: [
                  OrderTopBar(
                    notificationCount: OrderMockData.notificationCount,
                    onNotificationTap: () =>
                        context.push(AppRoutes.notifications),
                    onBack: () => context.canPop()
                        ? context.pop()
                        : context.go(AppRoutes.clientHome),
                  ),
                  const SizedBox(height: AppSizes.orderSectionGap),
                  const OrderTitle(),
                  const SizedBox(height: AppSizes.orderSectionGap),
                  const StationSection(),
                  const SizedBox(height: AppSpacing.lg),
                  GradeSection(
                    selectedIndices: _quantities.keys.toSet(),
                    onToggle: _toggleGrade,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  QuantitySection(
                    quantities: _quantities,
                    controllers: _customQuantityControllers,
                    onCustomQuantityChanged: _onCustomQuantityChanged,
                    onPresetSelected: _onPresetQuantitySelected,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DeliverySection(
                    selected: _delivery,
                    onChanged: (value) => setState(() => _delivery = value),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PaymentSection(
                    selected: _paymentMethod,
                    onChanged: (value) =>
                        setState(() => _paymentMethod = value),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildOrderSummarySection(),
                  const SizedBox(height: AppSpacing.lg),
                  const NotesSection(),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: AppSizes.orderActionBarBlur,
                      sigmaY: AppSizes.orderActionBarBlur,
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.gutter,
                        AppSpacing.lg,
                        AppSpacing.gutter,
                        AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: AppSizes.orderActionBarOpacity,
                        ),
                      ),
                      child: ConfirmButton(
                        submitting: _submitting,
                        onPressed: _submit,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    if (_quantities.isEmpty) return const SizedBox();
    final firstEntry = _quantities.entries.first;

    final grade = FuelGrade.values[firstEntry.key];
    final controller = _customQuantityControllers[firstEntry.key]!;
    final quantity =
        firstEntry.value ?? int.tryParse(controller.text.trim()) ?? 0;

    return OrderSummaryCard(
      fuelType: grade.title,
      quantity: OrderFormatting.litres(quantity),
      pricePerLiter: OrderFormatting.moneyLong(OrderMockData.pricePerLitre),
      totalWithTax: OrderFormatting.moneyLong(
        quantity * OrderMockData.pricePerLitre,
      ),
      transportFees: OrderFormatting.moneyLong(OrderMockData.transportFees),
      vat: OrderFormatting.moneyLong(OrderMockData.vat),
      finalTotal: OrderFormatting.moneyLong(OrderMockData.summaryTotal),
    );
  }
}
