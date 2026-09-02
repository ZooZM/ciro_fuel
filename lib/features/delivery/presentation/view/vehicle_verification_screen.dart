import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../domain/usecases/confirm_loading.dart';
import '../cubit/vehicle_verification_cubit.dart';
import '../cubit/vehicle_verification_state.dart';

/// spec 008 US3/US4: one screen for both verification stages — departure
/// (`isLoadingStage: false`) and the loading-stage re-verification
/// (`isLoadingStage: true`). Only the copy and the post-success action
/// differ; the credential flow itself (tap-card primary when NFC is
/// available, scan-code otherwise) is identical, matching FR-036a's
/// requirement that either method reach the same outcome.
///
/// `nfcAvailable == false` is a normal state on iOS without the paid-account
/// entitlement, or any device with no NFC hardware — the code path is
/// presented plainly, never as a broken button (research R5, FR-036a).
///
/// The QR code is presentable **only** through this screen's own live
/// camera preview (`MobileScanner`) — never a stored image. No
/// `image_picker` import exists anywhere in this file or the cubit it
/// drives (FR-036i/FR-036j).
class VehicleVerificationScreen extends StatelessWidget {
  const VehicleVerificationScreen({
    super.key,
    required this.orderId,
    required this.isLoadingStage,
  });

  final String orderId;

  /// `false`: this is the departure verification (ASSIGNED_TO_DRIVER ->
  /// LOADING) — a matched attempt already advances the order, nothing else
  /// to do here. `true`: the loading-stage re-verification (FR-030) — a
  /// matched attempt does NOT itself advance the order, so this screen also
  /// calls `confirm-loading` before reporting success back to the caller.
  final bool isLoadingStage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VehicleVerificationCubit>(
      create: (_) =>
          getIt<VehicleVerificationCubit>(param1: orderId)..checkAvailability(),
      child: _VehicleVerificationView(isLoadingStage: isLoadingStage),
    );
  }
}

class _VehicleVerificationView extends StatefulWidget {
  const _VehicleVerificationView({required this.isLoadingStage});

  final bool isLoadingStage;

  @override
  State<_VehicleVerificationView> createState() => _VehicleVerificationViewState();
}

class _VehicleVerificationViewState extends State<_VehicleVerificationView> {
  bool _showScanner = false;
  bool _finishing = false;

  Future<void> _onVerified(VehicleVerificationVerified state) async {
    if (!widget.isLoadingStage) {
      if (mounted) Navigator.of(context).pop(true);
      return;
    }

    setState(() => _finishing = true);
    final result = await getIt<ConfirmLoading>()(state.order.id);
    if (!mounted) return;
    setState(() => _finishing = false);
    result.fold(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(DriverLoadingKeys.confirmLoadingFailed.tr())),
      ),
      (_) => Navigator.of(context).pop(true),
    );
  }

  void _onStateChange(BuildContext context, VehicleVerificationState state) {
    if (state case VehicleVerificationVerified()) {
      unawaited(_onVerified(state));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VehicleVerificationCubit, VehicleVerificationState>(
      listener: _onStateChange,
      builder: (context, state) {
        final cubit = context.read<VehicleVerificationCubit>();
        final busy =
            _finishing ||
            state is VehicleVerificationSubmitting ||
            state is VehicleVerificationReading;

        return Scaffold(
          backgroundColor: context.colors.canvas,
          appBar: AppBar(
            backgroundColor: context.colors.canvas,
            elevation: 0,
            title: Text(
              (widget.isLoadingStage
                      ? DriverVerificationKeys.loadingTitle
                      : DriverVerificationKeys.departureTitle)
                  .tr(),
            ),
          ),
          body: SafeArea(
            child: _showScanner
                ? _QrScannerView(
                    busy: busy,
                    onDetected: (code) {
                      setState(() => _showScanner = false);
                      unawaited(cubit.verifyCode(code));
                    },
                    onUseCardInstead: () => setState(() => _showScanner = false),
                  )
                : _TapCardView(
                    state: state,
                    busy: busy,
                    onTapCard: () => unawaited(cubit.readTagAndVerify()),
                    onScanInstead: () => setState(() => _showScanner = true),
                  ),
          ),
        );
      },
    );
  }
}

class _TapCardView extends StatelessWidget {
  const _TapCardView({
    required this.state,
    required this.busy,
    required this.onTapCard,
    required this.onScanInstead,
  });

  final VehicleVerificationState state;
  final bool busy;
  final VoidCallback onTapCard;
  final VoidCallback onScanInstead;

  @override
  Widget build(BuildContext context) {
    final nfcAvailable = switch (state) {
      VehicleVerificationIdle(:final nfcAvailable) => nfcAvailable,
      _ => true,
    };

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            nfcAvailable ? Icons.nfc : Icons.qr_code_scanner,
            size: 96,
            color: context.colors.brandBlue,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (!nfcAvailable)
            Text(
              DriverVerificationKeys.nfcUnavailable.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary),
            )
          else
            Text(
              DriverVerificationKeys.tapCardHint.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary),
            ),
          const SizedBox(height: AppSpacing.lg),
          _StatusMessage(state: state),
          const SizedBox(height: AppSpacing.lg),
          if (nfcAvailable)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: busy ? null : onTapCard,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: context.colors.brandBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        DriverVerificationKeys.tapCard.tr(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: busy ? null : onScanInstead,
            child: Text(
              (nfcAvailable
                      ? DriverVerificationKeys.scanCodeInstead
                      : DriverVerificationKeys.verifyVehicle)
                  .tr(),
            ),
          ),
        ],
      ),
    );
  }
}

class _QrScannerView extends StatelessWidget {
  const _QrScannerView({
    required this.busy,
    required this.onDetected,
    required this.onUseCardInstead,
  });

  final bool busy;
  final ValueChanged<String> onDetected;
  final VoidCallback onUseCardInstead;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Text(
            DriverVerificationKeys.pointCamera.tr(),
            style: TextStyle(color: context.colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              // Live camera preview only — no gallery/file picker path
              // exists anywhere near this widget (FR-036i/FR-036j).
              child: MobileScanner(
                onDetect: (capture) {
                  if (busy) return;
                  for (final barcode in capture.barcodes) {
                    final value = barcode.rawValue;
                    if (value != null) {
                      onDetected(value);
                      return;
                    }
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: onUseCardInstead,
            child: Text(DriverVerificationKeys.useCardInstead.tr()),
          ),
        ],
      ),
    );
  }
}

/// FR-037: every refusal cause renders as its own message, never one
/// generic failure string. FR-030a/FR-030c add two more that a driver acts
/// on completely differently — "drive to the depot" and "turn your location
/// on" have nothing to do with each other, and neither is "wrong truck".
class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.state});

  final VehicleVerificationState state;

  /// One decimal of a kilometre is all a driver can act on. Below 100 m the
  /// number stops meaning anything useful — that is inside GPS's own error
  /// bar — so the distance-free wording says the same thing without
  /// pretending to a precision the fix does not have.
  static String _distanceMessage(double? meters) {
    if (meters == null || meters < 100) {
      return DriverVerificationKeys.notAtWarehouseUnknownDistance.tr();
    }
    return DriverVerificationKeys.notAtWarehouse.tr(
      namedArgs: {'distance': (meters / 1000).toStringAsFixed(1)},
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = switch (state) {
      VehicleVerificationMismatch() => DriverVerificationKeys.mismatch.tr(),
      VehicleVerificationThrottled() => DriverVerificationKeys.tooManyAttempts.tr(),
      VehicleVerificationNotAtWarehouse(:final distanceMeters) =>
        _distanceMessage(distanceMeters),
      VehicleVerificationLocationUnavailable() =>
        DriverVerificationKeys.locationUnavailable.tr(),
      VehicleVerificationFailure(:final unreachable) =>
        (unreachable ? DriverVerificationKeys.unreachable : DriverVerificationKeys.failed).tr(),
      _ => null,
    };
    if (text == null) return const SizedBox.shrink();
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: context.colors.brandRed, fontWeight: FontWeight.w600),
    );
  }
}
