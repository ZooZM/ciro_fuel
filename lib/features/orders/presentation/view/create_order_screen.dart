import 'dart:async';
import 'dart:ui';

import 'package:dartz/dartz.dart' hide State;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/error_codes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/number_formatting.dart';
import '../../../../core/widgets/error_presenter.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/fuel_grade.dart';
import '../../../../shared/enums/payment_method.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../auth/presentation/cubit/session_state.dart';
import '../../../invoices/domain/entities/credit_standing.dart';
import '../../../invoices/domain/usecases/get_credit_standing.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';
import '../../../stations/domain/entities/station.dart';
import '../../../stations/domain/usecases/get_stations.dart';
import '../../../stations/domain/usecases/set_favourite_station.dart';
import '../../domain/entities/pricing_config.dart';
import '../../domain/entities/price_breakdown.dart' show Quote;
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/get_company_pricing_config.dart';
import '../../domain/usecases/get_fuel_prices.dart';
import '../../domain/usecases/get_quote.dart';
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
import '../../../../shared/models/station_option.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key, this.initialGradeBadge});

  /// Badge of the grade to start on ('91', '95', '98', 'D', 'K'), as passed by
  /// the home screen's طلب سريع tiles. Null falls back to the design's default.
  final String? initialGradeBadge;

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  /// Grade index → litres on order. Never more than one entry: picking a
  /// grade replaces whatever was chosen before (see [_selectGrade]) — the
  /// `Map` shape is kept only because [QuantitySection] is written to key
  /// its rows by grade index.
  final Map<int, int> _quantities = {};

  /// The grade currently on the form. Held separately from [_quantities]
  /// because a grade is selectable whether or not the fleet's tanker ladder
  /// is known: when the company's pricing configuration is missing or
  /// unreadable there are no litres to key the map by, and deriving the
  /// selection from the map alone made every grade tile a silent no-op.
  int? _selectedGradeIndex;

  DeliveryOption _delivery = DeliveryOption.fastest;
  PaymentMethod _paymentMethod = PaymentMethod.direct;

  /// Set only by the calendar behind جدول موعد; null until a day is picked.
  DateTime? _scheduledDate;
  bool _submitting = false;

  bool _loadingFormData = true;

  /// The company's pricing configuration could not be read — either the
  /// platform refused it (PRICING_NOT_CONFIGURED) or it carries no tanker
  /// ladder. The quantity row (FR-017) is sourced from it, so the form
  /// cannot price or submit anything until it loads; the screen says so
  /// rather than rendering a form whose controls do nothing.
  bool _pricingUnavailable = false;
  List<Station> _stations = [];
  Station? _selectedStation;
  List<FuelPrice> _fuelPrices = [];
  PricingConfig? _pricingConfig;

  /// Fetched once alongside the rest of the form's data (FR-028) — only
  /// ever a courtesy warning here; the server-side refusal inside the
  /// order transaction remains the sole authority on whether CREDIT is
  /// actually over limit.
  CreditStanding? _creditStanding;

  Quote? _quote;
  bool _quoteLoading = false;
  Timer? _quoteDebounce;
  int _quoteRequestId = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_loadFormData());
  }

  @override
  void dispose() {
    _quoteDebounce?.cancel();
    super.dispose();
  }

  static String _companyIdOf(SessionCubit cubit) => switch (cubit.state) {
    SessionAuthenticated(:final user) => user.companyId,
    _ => '',
  };

  /// The client's own stations, fuel company prices and pricing
  /// configuration (spec 005 US2, T058–T060) — every input the form needs
  /// before it can show a real price, fetched together so the screen has
  /// one loading window rather than three staggered ones.
  Future<void> _loadFormData() async {
    final companyId = _companyIdOf(context.read<SessionCubit>());
    final results = await Future.wait([
      getIt<GetStations>()(),
      getIt<GetFuelPrices>()(companyId),
      getIt<GetCompanyPricingConfig>()(companyId),
      getIt<GetCreditStanding>()(),
    ]);
    if (!mounted) return;

    final stations = (results[0] as Either<Failure, List<Station>>).fold(
      (_) => const <Station>[],
      (value) => value,
    );
    final fuelPrices = (results[1] as Either<Failure, List<FuelPrice>>).fold(
      (_) => const <FuelPrice>[],
      (value) => value,
    );
    final pricingConfig = (results[2] as Either<Failure, PricingConfig?>)
        .fold((_) => null, (value) => value);
    final creditStanding = (results[3] as Either<Failure, CreditStanding>)
        .fold((_) => null, (value) => value);

    final soldTypes = fuelPrices.map((p) => p.fuelType).toSet();
    final gradeIndex = _initialGradeIndex(soldTypes);
    final capacities = pricingConfig?.tankerCapacitiesLiters;

    setState(() {
      _stations = stations;
      _selectedStation = stations.isEmpty
          ? null
          : stations.firstWhere(
              (s) => s.isDefault,
              orElse: () => stations.first,
            );
      _fuelPrices = fuelPrices;
      _pricingConfig = pricingConfig;
      _creditStanding = creditStanding;
      _loadingFormData = false;
      _pricingUnavailable = capacities == null || capacities.isEmpty;
      _selectedGradeIndex = gradeIndex;
      _quantities.clear();
      if (gradeIndex != null && capacities != null && capacities.isNotEmpty) {
        _quantities[gradeIndex] = capacities.first;
      }
    });

    unawaited(_refreshQuote());
  }

  /// Re-runs [_loadFormData] behind the retry the pricing banner offers —
  /// the whole form's data, since a failed pricing read usually means the
  /// request itself failed, not that this one endpoint is special.
  Future<void> _retryFormData() async {
    setState(() => _loadingFormData = true);
    await _loadFormData();
  }

  /// Falls back to the first grade the company actually sells when the
  /// badge passed in isn't one of them (or none was passed) — never a grade
  /// [soldTypes] doesn't cover, since [GradeSection] won't offer it either.
  int? _initialGradeIndex(Set<FuelType> soldTypes) {
    final badge = widget.initialGradeBadge;
    final badgeIndex = badge == null
        ? -1
        : FuelGrade.values.indexWhere((g) => g.badge == badge);
    if (badgeIndex != -1 && soldTypes.contains(FuelGrade.values[badgeIndex].type)) {
      return badgeIndex;
    }
    final fallbackIndex = FuelGrade.values.indexWhere(
      (g) => g.type != null && soldTypes.contains(g.type),
    );
    return fallbackIndex == -1 ? null : fallbackIndex;
  }

  Set<FuelType> get _soldTypes => _fuelPrices.map((p) => p.fuelType).toSet();

  /// The fleet's own tanker sizes (FR-017), smallest first. The first few —
  /// the sizes ordered often enough to earn a tile of their own — head the
  /// row as [QuantitySection.tileQuantities]; the counter behind the لتر box
  /// steps through the rest via [QuantitySection.counterQuantities].
  static const _tileCount = 3;

  List<int> get _counterQuantities => _pricingConfig?.tankerCapacitiesLiters ?? const [];

  List<int> get _tileQuantities =>
      _counterQuantities.take(_tileCount).toList();

  StationOption _stationOptionOf(Station station) {
    // Real data has one locale, not two — the platform never fabricates a
    // translation of a client's own free-text station name/address.
    final name = station.name?.isNotEmpty == true
        ? station.name!
        : station.addressText;
    return StationOption(
      id: station.id,
      name: name,
      nameEn: name,
      area: station.addressText,
      areaEn: station.addressText,
      isFavourite: station.isFavourite,
    );
  }

  /// One grade per order: picking another replaces the current one along
  /// with the quantity chosen against it. Tapping the selected grade is a
  /// no-op — the form always has exactly one grade on it.
  void _selectGrade(int index) {
    if (_selectedGradeIndex == index) return;
    final capacities = _counterQuantities;
    setState(() {
      _selectedGradeIndex = index;
      // The grade is recorded either way: with no ladder to draw a default
      // litre from, the tile still selects and the quantity row explains
      // why it has nothing to offer.
      _quantities.clear();
      if (capacities.isNotEmpty) _quantities[index] = capacities.first;
    });
    _scheduleQuoteRefresh();
  }

  void _selectPaymentMethod(PaymentMethod method) {
    setState(() => _paymentMethod = method);
  }

  void _selectStation(StationOption option) {
    final station = _stations.firstWhereOrNull((s) => s.id == option.id);
    if (station == null) return;
    setState(() => _selectedStation = station);
    _scheduleQuoteRefresh();
  }

  /// spec 005 T111 — persisted through the backend (FR-037), not the
  /// local-only `setState` this used to be; a failed toggle leaves the star
  /// exactly as it was rather than flipping it optimistically.
  Future<void> _toggleFavourite(StationOption option) async {
    final station = _stations.firstWhereOrNull((s) => s.id == option.id);
    if (station == null) return;
    final result = await getIt<SetFavouriteStation>()(
      station.id,
      !station.isFavourite,
    );
    result.fold((failure) {
      if (mounted) presentFailure(context, failure);
    }, (updated) {
      if (!mounted) return;
      setState(() {
        _stations = [
          for (final s in _stations)
            if (s.id == updated.id) updated else s,
        ];
        if (_selectedStation?.id == updated.id) _selectedStation = updated;
      });
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
    _scheduleQuoteRefresh();
  }

  void _scheduleQuoteRefresh() {
    _quoteDebounce?.cancel();
    _quoteDebounce = Timer(
      const Duration(milliseconds: 400),
      () => unawaited(_refreshQuote()),
    );
  }

  /// Live-prices the current grade/quantity/station selection (spec 005
  /// US2) — every figure the form shows past this point is the platform's
  /// own quote, never computed locally (FR-011b).
  Future<void> _refreshQuote() async {
    final station = _selectedStation;
    final entry = _quantities.entries.firstOrNull;
    final fuelType = entry == null ? null : FuelGrade.values[entry.key].type;

    if (station == null || entry == null || fuelType == null) {
      setState(() {
        _quote = null;
        _quoteLoading = false;
      });
      return;
    }

    final requestId = ++_quoteRequestId;
    setState(() => _quoteLoading = true);
    final result = await getIt<GetQuote>()(
      fuelType: fuelType,
      quantityLiters: entry.value,
      stationId: station.id,
    );
    if (!mounted || requestId != _quoteRequestId) return;
    result.fold(
      (failure) => setState(() {
        _quote = null;
        _quoteLoading = false;
      }),
      (quote) => setState(() {
        _quote = quote;
        _quoteLoading = false;
      }),
    );
  }

  Future<void> _submit() async {
    if (_quantities.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_quantityEmptyMessage)));
      return;
    }
    final station = _selectedStation;
    if (station == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(CreateOrderKeys.selectStation.tr())),
      );
      return;
    }

    final entry = _quantities.entries.first;
    final fuelType = FuelGrade.values[entry.key].type ?? FuelType.gasoline91;

    setState(() => _submitting = true);
    final orderId = await _createOrderWithFreshQuote(
      fuelType: fuelType,
      quantityLiters: entry.value,
      stationId: station.id,
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    if (orderId != null) {
      unawaited(context.push(AppRoutes.clientOrderDetail(orderId)));
    }
  }

  /// Ensures a fresh quote, then submits against it (FR-016/T063). On
  /// QUOTE_EXPIRED (the token's TTL merely lapsed, not a price change) it
  /// re-quotes and retries once without asking. On QUOTE_STALE (T062) it
  /// shows the platform's current total and only retries once the client
  /// explicitly re-confirms it — never silently substituting either figure.
  Future<String?> _createOrderWithFreshQuote({
    required FuelType fuelType,
    required int quantityLiters,
    required String stationId,
    bool alreadyRetried = false,
  }) async {
    var quote = _quote;
    if (quote == null) {
      final quoteResult = await getIt<GetQuote>()(
        fuelType: fuelType,
        quantityLiters: quantityLiters,
        stationId: stationId,
      );
      Failure? quoteFailure;
      quoteResult.fold(
        (failure) => quoteFailure = failure,
        (value) => quote = value,
      );
      if (quoteFailure != null) {
        if (mounted) presentFailure(context, quoteFailure!);
        return null;
      }
    }

    final result = await getIt<CreateOrder>()(
      fuelType: fuelType,
      quantityLiters: quantityLiters,
      stationId: stationId,
      quoteToken: quote!.quoteToken,
      paymentMethod: _paymentMethod,
    );

    String? orderId;
    await result.fold(
      (failure) async {
        if (failure is ValidationFailure &&
            failure.code == ErrorCodes.quoteExpired &&
            !alreadyRetried) {
          await _refreshQuote();
          orderId = await _createOrderWithFreshQuote(
            fuelType: fuelType,
            quantityLiters: quantityLiters,
            stationId: stationId,
            alreadyRetried: true,
          );
          return;
        }
        if (failure is ValidationFailure &&
            failure.code == ErrorCodes.quoteStale &&
            !alreadyRetried) {
          final currentBreakdownJson = failure.extra?['currentBreakdown'];
          if (currentBreakdownJson is Map<String, Object?>) {
            if (!mounted) return;
            final newBreakdown = PriceBreakdown.fromJson(currentBreakdownJson);
            final confirmed = await _confirmNewPrice(newBreakdown);
            if (confirmed == true) {
              await _refreshQuote();
              orderId = await _createOrderWithFreshQuote(
                fuelType: fuelType,
                quantityLiters: quantityLiters,
                stationId: stationId,
                alreadyRetried: true,
              );
            }
            return;
          }
        }
        if (mounted) presentFailure(context, failure);
      },
      (order) async => orderId = order.id,
    );
    return orderId;
  }

  Future<bool?> _confirmNewPrice(PriceBreakdown newBreakdown) {
    final total =
        '${NumberFormatting.currency(newBreakdown.total)} ${CommonKeys.riyal.tr()}';
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(CreateOrderKeys.priceChangedTitle.tr()),
        content: Text(
          CreateOrderKeys.priceChangedMessage.tr(namedArgs: {'total': total}),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(CommonKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(CreateOrderKeys.confirmNewPrice.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedStation = _selectedStation;
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
                  notificationCount:
                      context.watch<NotificationsCubit>().state.unreadBadgeCount,
                  onNotificationTap: () =>
                      context.push(AppRoutes.notifications),
                  onBack: () => context.canPop()
                      ? context.pop()
                      : context.go(AppRoutes.clientHome),
                ),
                const SizedBox(height: AppSizes.orderSectionGap),
                const OrderTitle(),
                const SizedBox(height: AppSizes.orderSectionGap),
                StationSection(
                  stationName: selectedStation == null
                      ? null
                      : _stationOptionOf(selectedStation).name,
                  stationAddress: selectedStation?.addressText,
                  stations: _stations.map(_stationOptionOf).toList(),
                  favouriteStations: _stations
                      .where((s) => s.isFavourite)
                      .map(_stationOptionOf)
                      .toList(),
                  selectedStationId: selectedStation?.id,
                  onSelectStation: _selectStation,
                  onToggleFavourite: _toggleFavourite,
                ),
                const SizedBox(height: AppSpacing.lg),
                GradeSection(
                  selectedIndex: _selectedGradeIndex,
                  onSelect: _selectGrade,
                  soldTypes: _loadingFormData ? null : _soldTypes,
                ),
                const SizedBox(height: AppSpacing.lg),
                QuantitySection(
                  quantities: _quantities,
                  onPresetSelected: _onPresetQuantitySelected,
                  tileQuantities: _tileQuantities,
                  counterQuantities: _counterQuantities,
                  emptyMessage: _quantityEmptyMessage,
                ),
                if (!_loadingFormData && _pricingUnavailable) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _pricingUnavailableBanner,
                ],
                const SizedBox(height: AppSpacing.lg),
                DeliverySection(
                  selected: _delivery,
                  scheduledDate: _scheduledDate,
                  onChanged: (value) => setState(() => _delivery = value),
                  onScheduleTap: _pickScheduleDate,
                ),
                const SizedBox(height: AppSpacing.lg),
                PaymentSection(
                  selected: _paymentMethod,
                  onSelect: _selectPaymentMethod,
                ),
                if (_creditOverLimitWarning case final warning?) ...[
                  const SizedBox(height: AppSpacing.sm),
                  warning,
                ],
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

  /// What the quantity card says when it has no litres to offer. Before a
  /// grade is picked that is simply the next step; once one IS picked, the
  /// only remaining reason is that the tanker ladder never loaded — and
  /// asking for a fuel type there asks for something already done, which is
  /// exactly how an unpriced company reads as a broken screen.
  String get _quantityEmptyMessage => _selectedGradeIndex == null
      ? CreateOrderKeys.chooseFuelTypeFirst.tr()
      : CreateOrderKeys.quantitiesUnavailable.tr();

  /// The retry sitting under that message. The failure is usually the
  /// request, not the endpoint, so it reloads the whole form's data.
  Widget get _pricingUnavailableBanner => Align(
    alignment: AlignmentDirectional.centerStart,
    child: TextButton.icon(
      onPressed: _loadingFormData ? null : () => unawaited(_retryFormData()),
      icon: Icon(
        Icons.refresh,
        size: AppSizes.iconSm,
        color: context.colors.brandBlue,
      ),
      label: Text(
        CommonKeys.retry.tr(),
        style: TextStyle(color: context.colors.brandBlue, fontSize: 13),
      ),
    ),
  );

  /// FR-028: a courtesy check only, shown once a real quote exists — the
  /// order transaction's own credit check remains authoritative regardless
  /// of what this banner says or whether it renders at all.
  Widget? get _creditOverLimitWarning {
    if (_paymentMethod != PaymentMethod.credit) return null;
    final available = _creditStanding?.available;
    final total = _quote?.breakdown.total;
    if (available == null || total == null || total <= available) return null;

    final shortfall = total - available;
    final currency = CommonKeys.riyal.tr();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.orangeTint,
        borderRadius: BorderRadius.circular(AppSizes.orderChipRadius),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: context.colors.brandOrange,
            size: AppSizes.iconSm,
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              CreateOrderKeys.creditOverLimitWarning.tr(
                namedArgs: {
                  'shortfall':
                      '${NumberFormatting.currency(shortfall)} $currency',
                },
              ),
              style: TextStyle(color: context.colors.brandOrange, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    if (_quantities.isEmpty) return const SizedBox();
    final firstEntry = _quantities.entries.first;

    final grade = FuelGrade.values[firstEntry.key];
    final quantity = firstEntry.value;
    final currency = CommonKeys.riyal.tr();

    if (_quoteLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final breakdown = _quote?.breakdown;
    if (breakdown == null) {
      // No fabricated numbers while a quote hasn't been priced yet (or
      // couldn't be) — the fuel type/quantity the client already chose are
      // the only real figures to show.
      return OrderSummaryCard(
        fuelType: grade.titleKey.tr(),
        quantity:
            '${NumberFormatting.thousands(quantity)} ${CommonKeys.litre.tr()}',
      );
    }

    return OrderSummaryCard(
      fuelType: grade.titleKey.tr(),
      quantity:
          '${NumberFormatting.thousands(quantity)} ${CommonKeys.litre.tr()}',
      pricePerLiter: '${NumberFormatting.currency(breakdown.unitPrice)} $currency',
      totalWithTax:
          '${NumberFormatting.currency(breakdown.fuelLineTotal)} $currency',
      // The design's summary card has one slot for "fees" — delivery and
      // service fee combined, since it draws no line between them.
      transportFees:
          '${NumberFormatting.currency(breakdown.deliveryFee + breakdown.serviceFee)} $currency',
      vat: '${NumberFormatting.currency(breakdown.tax)} $currency',
      finalTotal: '${NumberFormatting.currency(breakdown.total)} $currency',
    );
  }
}

extension _FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
