import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/number_formatting.dart';
import '../../../../shared/enums/fuel_grade.dart';
import '../../../../shared/enums/fuel_type.dart';
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
import '../../../../core/widgets/app_calendar.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/theme/theme_context.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key, this.initialGradeBadge});

  /// Badge of the grade to start on ('91', '95', '98', 'D', 'K'), as passed by
  /// the home screen's طلب سريع tiles. Null falls back to the design's default.
  final String? initialGradeBadge;

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  /// Grade index → litres on order. Every value comes from
  /// [kOrderCounterQuantities]: the quantity row is tiles and a counter, with
  /// no free-typed amount.
  final Map<int, int> _quantities = {};

  DeliveryOption _delivery = DeliveryOption.fastest;

  /// Set only by the calendar behind جدول موعد; null until a day is picked.
  DateTime? _scheduledDate;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _quantities[_initialGradeIndex()] = kOrderQuantities.first;
  }

  /// Falls back to بنزين 98 — the grade selected in the design — when the
  /// screen is opened without a badge or with one that is not in the list.
  int _initialGradeIndex() {
    final badge = widget.initialGradeBadge;
    if (badge == null) return 2;
    final index = FuelGrade.values.indexWhere((g) => g.badge == badge);
    return index == -1 ? 2 : index;
  }

  /// One grade per order: picking another replaces the current one along
  /// with the quantity chosen against it. Tapping the selected grade is a
  /// no-op — the form always has exactly one grade on it.
  void _selectGrade(int index) {
    if (_quantities.containsKey(index)) return;
    setState(() {
      _quantities
        ..clear()
        ..[index] = kOrderQuantities.first;
    });
  }

  /// جدول موعد asks for the day before it counts as chosen. Uses the app's own
  /// calendar — the same dialog the filter sheets open — not Material's
  /// `showDatePicker`, whose chrome does not match these screens.
  Future<void> _pickScheduleDate() async {
    final today = DateTime.now();
    final picked = await showAppDatePicker(
      context,
      selected: _scheduledDate,
      // A delivery cannot be scheduled into the past, and a year ahead is as
      // far as the form allows.
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _scheduledDate = picked;
      _delivery = DeliveryOption.schedule;
    });
  }

  void _onPresetQuantitySelected(int gradeIndex, int litres) {
    setState(() => _quantities[gradeIndex] = litres);
  }

  Future<void> _submit() async {
    if (_quantities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(CreateOrderKeys.selectAtLeastOneFuelType.tr())),
      );
      return;
    }

    // Every quantity comes off [kOrderCounterQuantities], so there is no amount
    // left to validate — a grade having been picked is the only condition.
    final orderPayloads = <(FuelType, int)>[
      for (final entry in _quantities.entries)
        (FuelGrade.values[entry.key].type ?? FuelType.gasoline91, entry.value),
    ];

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
    return Scaffold(
      backgroundColor: context.colors.canvas,
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
                AppTopBar(
                  notificationCount: 3,
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
                  selectedIndex: _quantities.keys.firstOrNull,
                  onSelect: _selectGrade,
                ),
                const SizedBox(height: AppSpacing.lg),
                QuantitySection(
                  quantities: _quantities,
                  onPresetSelected: _onPresetQuantitySelected,
                ),
                const SizedBox(height: AppSpacing.lg),
                DeliverySection(
                  selected: _delivery,
                  scheduledDate: _scheduledDate,
                  onChanged: (value) => setState(() => _delivery = value),
                  onScheduleTap: _pickScheduleDate,
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
                      color: context.colors.surface.withValues(alpha: 0.8),
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
    );
  }

  Widget _buildOrderSummarySection() {
    if (_quantities.isEmpty) return const SizedBox();
    final firstEntry = _quantities.entries.first;

    final grade = FuelGrade.values[firstEntry.key];
    final quantity = firstEntry.value;

    const pricePerLiter = 2.33;
    final fuelTotal = quantity * pricePerLiter;
    const transportFees = 1200.00;
    const vatMock = 6000.00;
    const finalTotal = 46600.00;

    final currency = CommonKeys.riyal.tr();

    return OrderSummaryCard(
      fuelType: grade.titleKey.tr(),
      quantity:
          '${NumberFormatting.thousands(quantity)} ${CommonKeys.litre.tr()}',
      pricePerLiter: '${pricePerLiter.toStringAsFixed(2)} $currency',
      totalWithTax: '${NumberFormatting.currency(fuelTotal)} $currency',
      transportFees: '${NumberFormatting.currency(transportFees)} $currency',
      vat: '${NumberFormatting.currency(vatMock)} $currency',
      finalTotal: '${NumberFormatting.currency(finalTotal)} $currency',
    );
  }
}
