import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/enums/stop_reason.dart';
import '../cubit/delivery_cubit.dart';
import '../cubit/stop_reason_cubit.dart';
import '../cubit/stop_reason_state.dart';

/// spec 011 US2 (T039/T040): the driver's stop sheet, in both its modes.
///
/// One sheet for answering a detected stop and for declaring one, because
/// they are the same interaction — the only differences are the heading, the
/// duration row, and which call the answer goes to.
///
/// **The reasons are one-tap buttons, not a dropdown** (SC-003). This is a
/// deliberate constraint, not a styling preference: the driver using this is
/// stopped at the roadside, possibly outside the cab dealing with whatever
/// stopped them, and the requirement is that they can answer without typing
/// and without a second interaction to open a list. A dropdown would satisfy
/// every functional requirement here and fail the one that matters.
Future<void> showStopReasonSheet(
  BuildContext context, {
  required String orderId,
  String? stopId,
}) {
  assert(
    stopId != null || true,
    'stopId is required when answering a detected stop; absent when declaring',
  );
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => StopReasonCubit(
        submitStopReason: getIt(),
        declareStop: getIt(),
      ),
      child: _StopReasonSheet(orderId: orderId, stopId: stopId),
    ),
  );
}

class _StopReasonSheet extends StatefulWidget {
  const _StopReasonSheet({required this.orderId, this.stopId});

  final String orderId;

  /// Null when the driver is declaring a stop nobody asked about.
  final String? stopId;

  @override
  State<_StopReasonSheet> createState() => _StopReasonSheetState();
}

class _StopReasonSheetState extends State<_StopReasonSheet> {
  final TextEditingController _textController = TextEditingController();

  /// Offered as fixed choices for the same reason the reasons are: a driver
  /// should not have to operate a number field at the roadside. Twenty
  /// minutes is the default because it covers the most common declared stop
  /// (a prayer break) without being long enough to matter if it is wrong.
  static const List<int> _durations = [10, 20, 30, 60];
  int _duration = 20;

  bool get _isDeclaring => widget.stopId == null;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StopReasonCubit, StopReasonState>(
      listener: (context, state) {
        if (state is StopReasonSent) {
          Navigator.of(context).pop();
          // feature 013 FR-006: whichever entry point opened this sheet — a
          // notification tap, the delivery screen's outstanding-stop banner,
          // or the declare button — the driver's active delivery reloads so
          // the question clears without a manual refresh. `DeliveryCubit` is
          // the app-scoped singleton in production; guarded for the widget
          // tests that pump this sheet without the full DI graph.
          if (getIt.isRegistered<DeliveryCubit>()) {
            unawaited(getIt<DeliveryCubit>().load());
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isDeclaring
                    ? DriverKeys.declareStopSent.tr()
                    : DriverKeys.stopReasonSent.tr(),
              ),
            ),
          );
        }
        if (state is StopReasonFailed) {
          // Never dismissed on failure: the driver's answer did not reach
          // the transport office, and closing the sheet would leave them
          // believing it had while the escalation timer kept running.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isDeclaring
                    ? DriverKeys.declareStopFailed.tr()
                    : DriverKeys.stopReasonFailed.tr(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<StopReasonCubit>();
        final busy = state is StopReasonSubmitting;
        final editing = state is StopReasonEditing ? state : null;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isDeclaring
                      ? DriverKeys.declareStopTitle.tr()
                      : DriverKeys.stopPromptTitle.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _isDeclaring
                      ? DriverKeys.declareStopSubtitle.tr()
                      : DriverKeys.stopPromptSubtitle.tr(),
                  style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),

                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final reason in StopReason.values)
                      _ChoiceChip(
                        label: reason.labelKey.tr(),
                        selected: cubit.selectedReason == reason,
                        onTap: busy ? null : () => cubit.select(reason),
                      ),
                  ],
                ),

                // FR-006: revealed only for OTHER — every other reason is
                // complete on its own.
                if (editing?.needsText ?? false) ...[
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: _textController,
                    onChanged: cubit.setText,
                    maxLength: 500,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: DriverKeys.stopReasonOtherHint.tr(),
                      errorText: (editing?.textMissing ?? false)
                          ? DriverKeys.stopReasonOtherRequired.tr()
                          : null,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],

                if (_isDeclaring) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    DriverKeys.declareStopDuration.tr(),
                    style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      for (final minutes in _durations)
                        _ChoiceChip(
                          label: DriverKeys.declareStopMinutes.tr(
                            namedArgs: {'minutes': '$minutes'},
                          ),
                          selected: _duration == minutes,
                          onTap: busy ? null : () => setState(() => _duration = minutes),
                        ),
                    ],
                  ),
                ],

                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: busy || cubit.selectedReason == null
                        ? null
                        : () => unawaited(
                            _isDeclaring
                                ? cubit.declare(
                                    orderId: widget.orderId,
                                    expectedDurationMinutes: _duration,
                                  )
                                : cubit.submit(
                                    orderId: widget.orderId,
                                    stopId: widget.stopId!,
                                  ),
                          ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: context.colors.brandBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _isDeclaring
                                ? DriverKeys.declareStopSubmit.tr()
                                : DriverKeys.stopReasonSubmit.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? context.colors.brandBlue : Colors.transparent,
          border: Border.all(
            color: selected ? context.colors.brandBlue : context.colors.borderHairline,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : context.colors.textPrimary,
          ),
        ),
      ),
    );
  }
}
