import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/app_logo.dart';
import '../cubit/delivery_cubit.dart';

class DriverScanScreen extends StatefulWidget {
  const DriverScanScreen({super.key});

  @override
  State<DriverScanScreen> createState() => _DriverScanScreenState();
}

class _DriverScanScreenState extends State<DriverScanScreen> {
  // 0 = Scan QR, 1 = Enter Code
  int _selectedIndex = 0;
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();

  /// The handover OTP's length — the client's card shows exactly this many
  /// digits, and the QR encodes the same string.
  static const _codeLength = 6;

  bool _submitting = false;

  /// Sends the code the client is showing. Which transition it completes —
  /// "I have arrived" or "the fuel is handed over" — follows the order's own
  /// status inside the cubit; the driver just presents the code either way.
  Future<void> _confirm() async {
    final code = _codeController.text.trim();
    setState(() => _submitting = true);
    final failure = await getIt<DeliveryCubit>().confirmHandover(code);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (failure == null) {
      // The order has moved on; the driver's own screen reloads behind this.
      Navigator.of(context).pop(true);
      return;
    }

    // A wrong or expired code is the common case, and the backend's message
    // is the only thing that distinguishes them — surface it rather than a
    // generic failure.
    final message = switch (failure) {
      ValidationFailure(:final message) => message,
      NotFoundFailure() => DriverNavigationKeys.codeNotRecognised.tr(),
      ThrottledFailure() => DriverNavigationKeys.codeTooManyAttempts.tr(),
      _ => DriverNavigationKeys.codeConfirmFailed.tr(),
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    // The confirm button's enabled state is derived from the code's length,
    // so it has to rebuild as the driver types — and when a scan fills the
    // field for them.
    _codeController.addListener(_onCodeChanged);
  }

  void _onCodeChanged() => setState(() {});

  @override
  void dispose() {
    _codeController.removeListener(_onCodeChanged);
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  String _getChar(int index) {
    if (_codeController.text.length > index) {
      return _codeController.text[index];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6), // Light gray background to match design
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const AppLogo(),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconCard(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 2.0),
                child: Icon(Icons.arrow_back_ios_new, size: 20, color: context.colors.textPrimary),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Segmented Control
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Container(
                height: 56,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Enter Code Tab (Left in RTL)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedIndex = 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedIndex == 1 ? context.colors.brandBlue : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/driverOrderPage/keypad_gray.svg',
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  _selectedIndex == 1 ? Colors.white : const Color(0xFF9CA3AF),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DriverNavigationKeys.enterCode.tr(),
                                style: TextStyle(
                                  color: _selectedIndex == 1 ? Colors.white : context.colors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Scan QR Tab (Right in RTL - first visually)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedIndex = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedIndex == 0 ? context.colors.brandBlue : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/driverOrderPage/scan_qr_white.svg',
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  _selectedIndex == 0 ? Colors.white : const Color(0xFF9CA3AF),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DriverNavigationKeys.scanQr.tr(),
                                style: TextStyle(
                                  color: _selectedIndex == 0 ? Colors.white : context.colors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content Area
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedIndex == 0 ? _buildScanQrView(context) : _buildEnterCodeView(context),
              ),
            ),
            
            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: FilledButton(
                // Disabled until six digits are present, so a half-typed code
                // is never sent — a failed attempt counts against the OTP's
                // five-try lockout.
                onPressed: _submitting || _codeController.text.trim().length != _codeLength
                    ? null
                    : _confirm,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: context.colors.brandBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/driverOrderPage/arrow_forward_white.svg', width: 20, height: 20),
                          const SizedBox(width: 8),
                          Text(
                            DriverNavigationKeys.confirmDelivery.tr(),
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
              ),
            ),
            // SafeArea Bottom spacing
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildScanQrView(BuildContext context) {
    return Padding(
      key: const ValueKey('scan_qr_view'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Stack(
        children: [
          // Camera
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  debugPrint('Barcode found! ${barcode.rawValue}');
                  if (barcode.rawValue != null && _selectedIndex == 0) {
                    setState(() {
                      _codeController.text = barcode.rawValue!;
                      _selectedIndex = 1;
                    });
                  }
                }
              },
            ),
          ),
          // Dark Overlay with Cutout
          CustomPaint(
            size: Size.infinite,
            painter: _ScannerOverlayPainter(
              borderRadius: 16,
            ),
          ),
          // Scanner Frame
          Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                children: [
                  // Blue Scanner Frame Lines (Corners)
                  Positioned(
                    top: -4,
                    left: -4,
                    right: -4,
                    bottom: -4,
                    child: CustomPaint(
                      size: const Size(248, 248),
                      painter: _ScannerCornerPainter(
                        color: context.colors.brandBlue,
                        cornerLength: 20,
                        strokeWidth: 3,
                        borderRadius: 20,
                      ),
                    ),
                  ),
                  // Scanning Line
                  Positioned(
                    top: 120,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: context.colors.brandBlue,
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.brandBlue.withValues(alpha: 0.6),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Helper Pill
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: context.colors.brandBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DriverNavigationKeys.pointCamera.tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterCodeView(BuildContext context) {
    return Padding(
      key: const ValueKey('enter_code_view'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: context.colors.brandBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/driverOrderPage/keypad_gray.svg',
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(context.colors.brandBlue, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            DriverNavigationKeys.enterDeliveryCode.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary, // Or brandBlue? Design shows dark blue (textPrimary)
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            // spec 007 T030: this used to say "4-digit" and cap input at 4
            // characters, while the backend's handover code is 6 digits
            // (`OtpPrimitivesService.generateCode`) — typing a code could
            // never actually submit it. Same bug class spec 006 already
            // fixed once in driver_verify_phone_screen.dart.
            DriverNavigationKeys.enter6DigitCode.tr(),
            style: TextStyle(
              fontSize: 14,
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 48),
          
          // PIN Input Area
          // PIN Input Area
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(_codeFocusNode);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Hidden text field
                SizedBox(
                  width: 1,
                  height: 1,
                  child: TextField(
                    controller: _codeController,
                    focusNode: _codeFocusNode,
                    keyboardType: TextInputType.number,
                    maxLength: _codeLength,
                    autofocus: true,
                    showCursor: false,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(color: Colors.transparent, fontSize: 1),
                    onChanged: (v) {
                      setState(() {});
                    },
                  ),
                ),
                // Visual boxes (Always LTR for numbers)
                Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _codeLength; i++) ...[
                        if (i > 0) const SizedBox(width: _pinBoxSpacing),
                        _buildPinBox(
                          context,
                          _getChar(i),
                          _codeController.text.length == i,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // spec 007 T030: shrunk from the original 56/16 (sized for 4 boxes) so
  // six boxes fit a phone-width screen without overflowing — verified by
  // the RTL sweep alongside every other screen this feature touches.
  static const _pinBoxWidth = 44.0;
  static const _pinBoxHeight = 56.0;
  static const _pinBoxSpacing = 8.0;

  Widget _buildPinBox(BuildContext context, String text, bool isActive) {
    final bool hasText = text.isNotEmpty;
    return Container(
      width: _pinBoxWidth,
      height: _pinBoxHeight,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        border: Border.all(
          color: isActive ? context.colors.brandBlue : context.colors.borderHairline,
          width: isActive ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (hasText)
            Text(
              text,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
          if (isActive)
            Positioned(
              left: _pinBoxWidth / 2,
              child: Container(
                width: 1.5,
                height: 28,
                color: context.colors.textPrimary,
              ),
            ),
          Positioned(
            bottom: 12,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasText ? context.colors.brandBlue : context.colors.borderHairline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double borderRadius;

  _ScannerOverlayPainter({this.borderRadius = 16});

  @override
  void paint(Canvas canvas, Size size) {
    final scanWindowSize = 240.0;
    final scanWindow = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanWindowSize,
      height: scanWindowSize,
    );
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(scanWindow, Radius.circular(borderRadius)));

    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final path = Path.combine(PathOperation.difference, backgroundPath, cutoutPath);
    canvas.drawPath(path, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScannerCornerPainter extends CustomPainter {
  final Color color;
  final double cornerLength;
  final double strokeWidth;
  final double borderRadius;

  _ScannerCornerPainter({
    required this.color,
    required this.cornerLength,
    required this.strokeWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Top-Left
    path.moveTo(0, cornerLength);
    path.lineTo(0, borderRadius);
    path.arcToPoint(Offset(borderRadius, 0), radius: Radius.circular(borderRadius));
    path.lineTo(cornerLength, 0);

    // Top-Right
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width - borderRadius, 0);
    path.arcToPoint(Offset(size.width, borderRadius), radius: Radius.circular(borderRadius));
    path.lineTo(size.width, cornerLength);

    // Bottom-Left
    path.moveTo(0, size.height - cornerLength);
    path.lineTo(0, size.height - borderRadius);
    path.arcToPoint(Offset(borderRadius, size.height), radius: Radius.circular(borderRadius), clockwise: false);
    path.lineTo(cornerLength, size.height);

    // Bottom-Right
    path.moveTo(size.width - cornerLength, size.height);
    path.lineTo(size.width - borderRadius, size.height);
    path.arcToPoint(Offset(size.width, size.height - borderRadius), radius: Radius.circular(borderRadius), clockwise: false);
    path.lineTo(size.width, size.height - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
