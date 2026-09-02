import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/error_presenter.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../orders/domain/usecases/get_orders.dart';
import '../../../orders/presentation/constants/order_presentation.dart';
import '../../domain/entities/support_topic_codes.dart';
import '../cubit/support_cubit.dart';
import '../cubit/support_state.dart';

/// "Do you have a problem with an order?" — submits a real support request
/// with the chosen order attached automatically (spec 005 T120/FR-038).
class SupportOrderProblemCard extends StatefulWidget {
  const SupportOrderProblemCard({super.key});

  @override
  State<SupportOrderProblemCard> createState() => _SupportOrderProblemCardState();
}

class _SupportOrderProblemCardState extends State<SupportOrderProblemCard> {
  bool _isExpanded = false;
  bool _loadingOrders = false;
  List<Order>? _orders;
  String? _selectedOrderId;
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded && _orders == null) {
      setState(() => _loadingOrders = true);
      final result = await getIt<GetOrders>()();
      if (!mounted) return;
      result.fold(
        (_) => setState(() {
          _orders = const [];
          _loadingOrders = false;
        }),
        (page) => setState(() {
          _orders = page.items;
          _loadingOrders = false;
        }),
      );
    }
  }

  Future<void> _submit(BuildContext context) async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final ok = await context.read<SupportCubit>().submit(
      topic: SupportTopicCodes.orderIssue,
      message: message,
      orderId: _selectedOrderId,
    );
    if (!context.mounted) return;
    if (ok) {
      _messageController.clear();
      setState(() {
        _selectedOrderId = null;
        _isExpanded = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(SupportKeys.requestSubmitted.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportCubit, SupportState>(
      listenWhen: (previous, current) =>
          current is SupportLoaded && current.submitError != null,
      listener: (context, state) {
        final failure = (state as SupportLoaded).submitError;
        if (failure != null) {
          presentFailure(context, failure);
          context.read<SupportCubit>().clearSubmitError();
        }
      },
      builder: (context, state) {
        final isSubmitting = state is SupportLoaded && state.isSubmitting;
        return Column(
          children: [
            _buildHeader(context),
            if (_isExpanded) _buildBody(context, isSubmitting),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.greenTint,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(_isExpanded ? 0 : 12),
            bottomRight: Radius.circular(_isExpanded ? 0 : 12),
          ),
          border: Border.all(color: context.colors.brandGreen),
        ),
        child: Row(
          children: [
            SvgPicture.asset(AppAssets.supportGasGunIcon, width: 32, height: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SupportKeys.orderIssueTitle.tr(),
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    SupportKeys.orderIssueBody.tr(),
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: context.colors.brandGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isSubmitting) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.blueTint,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(
          left: BorderSide(color: context.colors.brandBlue),
          right: BorderSide(color: context.colors.brandBlue),
          bottom: BorderSide(color: context.colors.brandBlue),
        ),
      ),
      child: Column(
        children: [
          Text(
            SupportKeys.selectOrder.tr(),
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_loadingOrders)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_orders == null || _orders!.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                SupportKeys.noOrdersToAttach.tr(),
                style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
              ),
            )
          else
            for (final order in _orders!.take(3)) ...[
              _OrderChoiceCard(
                order: order,
                selected: order.id == _selectedOrderId,
                onTap: () => setState(
                  () => _selectedOrderId = _selectedOrderId == order.id ? null : order.id,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              GestureDetector(
                onTap: isSubmitting ? null : () => _submit(context),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colors.brandBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : SvgPicture.asset(
                            AppAssets.supportSendIcon,
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colors.borderHairline),
                  ),
                  child: TextField(
                    controller: _messageController,
                    minLines: 1,
                    maxLines: 3,
                    style: TextStyle(color: context.colors.textPrimary, fontSize: 12),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: SupportKeys.orderIssueHint.tr(),
                      hintStyle: TextStyle(color: context.colors.textSecondary, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderChoiceCard extends StatelessWidget {
  const _OrderChoiceCard({
    required this.order,
    required this.selected,
    required this.onTap,
  });

  final Order order;
  final bool selected;
  final VoidCallback onTap;

  String _fuelTypeLabel() => switch (order.fuelType) {
    FuelType.diesel => FuelKeys.diesel,
    FuelType.gasoline91 => FuelKeys.gasoline91,
    FuelType.gasoline95 => FuelKeys.gasoline95,
    FuelType.kerosene => FuelKeys.kerosene,
  }.tr();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? context.colors.brandBlue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppAssets.dashboardGasStationIcon,
              width: 40,
              height: 40,
              colorFilter: ColorFilter.mode(context.colors.brandGreen, BlendMode.srcIn),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${_fuelTypeLabel()} • ${order.quantityLiters} ${CommonKeys.litre.tr()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: context.colors.brandBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    OrderPresentation.statusLabel(order.status),
                    style: TextStyle(
                      color: OrderPresentation.statusColor(order.status),
                      fontSize: 10,
                    ),
                  ),
                  if (order.deliveryAddressText?.isNotEmpty == true) ...[
                    const SizedBox(height: 4),
                    Text(
                      order.deliveryAddressText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
                    ),
                  ],
                ],
              ),
            ),
            if (selected) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.check_circle, color: context.colors.brandBlue, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
