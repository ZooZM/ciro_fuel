import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/number_formatting.dart';
import '../../../../shared/enums/fuel_grade.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../constants/create_order_strings.dart';
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

  DeliveryOption _delivery = DeliveryOption.fastest;
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
        const SnackBar(content: Text(CreateOrderStrings.selectAtLeastOneFuelType)),
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
            content: Text(CreateOrderStrings.enterValidQuantityFor(grade.title)),
          ),
        );
        return;
      }

      final type = grade.type ?? FuelType.gasoline91;

      orderPayloads.add((type, quantity));
    }

    setState(() => _submitting = true);

    // Simulating network delay for static UI
    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _submitting = false);

    // Mock order IDs for static navigation
    final orderIds = <String>[];
    for (var i = 0; i < orderPayloads.length; i++) {
      orderIds.add('mock-order-${DateTime.now().millisecondsSinceEpoch}-$i');
    }

    if (orderIds.isNotEmpty) {
      if (orderIds.length == 1) {
        context.push(AppRoutes.clientOrderDetail(orderIds.first));
      } else {
        context.go(AppRoutes.clientOrders);
      }
    }
  }

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
                    notificationCount: 3,
                    onNotificationTap: () => context.push(AppRoutes.notifications),
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
                  const PaymentSection(),
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
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.gutter,
                        AppSpacing.lg,
                        AppSpacing.gutter,
                        AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
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

    const pricePerLiter = 2.33;
    final fuelTotal = quantity * pricePerLiter;
    const transportFees = 1200.00;
    const vatMock = 6000.00;
    const finalTotal = 46600.00;

    return OrderSummaryCard(
      fuelType: grade.title,
      quantity: '${NumberFormatting.thousands(quantity)} ${CreateOrderStrings.litre}',
      pricePerLiter: '${pricePerLiter.toStringAsFixed(2)} ريال',
      totalWithTax: '${NumberFormatting.currency(fuelTotal)} ريال',
      transportFees: '${NumberFormatting.currency(transportFees)} ريال',
      vat: '${NumberFormatting.currency(vatMock)} ريال',
      finalTotal: '${NumberFormatting.currency(finalTotal)} ريال',
    );
  }
}
