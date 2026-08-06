import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/widgets/order_card.dart';
import '../../../../core/widgets/fuel_pump_icon.dart';
import '../../../../core/widgets/order_flow.dart';

const _kBlue = Color(0xFF1E5FFF);
const _kGreen = Color(0xFF17A34A);
const _kNavy = Color(0xFF0F1B2E);
const _kGrey = Color(0xFF8A93A6);
const _kBackground = Color(0xFFF5F6F8);
const _kItemBorder = Color(0xFFE6E9F0);
const _kGreenTint = Color(0xFFE4F7EC);

const _kAppBarLogo = 'assets/HomePage/appBar Logo.svg';
const _kNotification = 'assets/icons/notification.svg';
const _kCopy = 'assets/icons/copy.svg';
const _kQrCode = 'assets/icons/QR Code.png';
const _kTruck = 'assets/HomePage/truck.svg';
const _kGreenStation = 'assets/HomePage/green station.svg';
const _kDriverPhoto = 'assets/Order/driver image.png';
// The map is a flat image until a maps SDK is wired in; its zoom and locate
// controls are part of the artwork.
const _kMap = 'assets/Order/map.png';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _kBackground,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 16, bottom: 24),
                  children: [
                    _inset(_buildTopBar(context)),
                    const SizedBox(height: 20),
                    _inset(const _Title()),
                    const SizedBox(height: 16),
                    _inset(_buildStatsCard()),
                    const SizedBox(height: 16),
                    // Full-bleed: the map is the only thing that touches the
                    // screen edges.
                    _buildMap(),
                    const SizedBox(height: 16),
                    _inset(_buildDriverCard()),
                    const SizedBox(height: 16),
                    _inset(_buildReceiptCodeCard()),
                    const SizedBox(height: 16),
                    _inset(_buildTimelineCard()),
                  ],
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// The page gutter every card sits in — the map alone opts out of it.
  Widget _inset(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: child,
  );

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // First child is right-most in RTL, so the bell leads and the back
        // button lands on the left, as designed.
        Stack(
          clipBehavior: Clip.none,
          children: [
            _IconCard(
              onTap: () {},
              child: SvgPicture.asset(
                _kNotification,
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(_kNavy, BlendMode.srcIn),
              ),
            ),
            Positioned(
              right: -4,
              top: -6,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF3F3F),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        SvgPicture.asset(_kAppBarLogo, height: 20),
        _IconCard(
          onTap: () => Navigator.of(context).pop(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Icon(Icons.arrow_back_ios, size: 20, color: _kNavy),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    // Measured off the design: the status and ETA groups need about half again
    // the room of the distance one.
    return OrderCard(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Row(
                children: [
                  SvgPicture.asset(_kGreenStation, width: 36, height: 36),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'حالة الطلب',
                          style: TextStyle(color: _kGrey, fontSize: 8),
                        ),
                        Row(
                          children: [
                            _Dot(),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'قيد التوصيل',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _kGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'علي الطريق إليك',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: _kGrey, fontSize: 7),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 14, thickness: 1, color: _kItemBorder),
            const Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'المسافة المتبقية',
                    style: TextStyle(color: _kGrey, fontSize: 8),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '12.7 كم',
                    maxLines: 1,
                    style: TextStyle(
                      color: _kNavy,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 14, thickness: 1, color: _kItemBorder),
            const Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'وقت الوصول المتوقع',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _kGrey, fontSize: 8),
                  ),
                  Text(
                    '04:35 م',
                    maxLines: 1,
                    style: TextStyle(
                      color: _kGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '02/05/2024 اليوم',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _kGrey, fontSize: 7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset(_kMap, fit: BoxFit.cover)),
          Positioned(
            left: 16,
            top: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _MapButton('assets/Order/reload.svg'),
                const SizedBox(height: 10),
                const _MapButton('assets/Order/zoom_in.svg'),
                const SizedBox(height: 10),
                const _MapButton('assets/Order/zoom_out.svg'),
                const SizedBox(height: 10),
                const _MapButton('assets/Order/share.svg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    // Right to left: the consignment, the truck, the driver, and their photo
    // on the far edge. Flexes measured off the design.
    return OrderCard(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Field(label: 'نوع الوقود', value: 'بنزين 95'),
                        SizedBox(height: 6),
                        _Field(label: 'الكمية', value: '20,000 لتر'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const FuelPumpIcon(
                      grade: '95',
                      color: Color(0xFF9333EA),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 14, thickness: 1, color: _kItemBorder),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _Field(
                    label: 'المركبة',
                    value: 'ABC-1234',
                    center: true,
                  ),
                  const Text(
                    'شاحنة نقل وقود',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _kGrey, fontSize: 7),
                  ),
                  const SizedBox(height: 4),
                  Image.asset(
                    'assets/Order/tank_truck.png',
                    width: 60,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 14, thickness: 1, color: _kItemBorder),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _Field(label: 'السائق', value: 'أحمد السبيعي'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: _kItemBorder),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.phone_outlined,
                      color: _kNavy,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ClipOval(
              child: Image.asset(
                _kDriverPhoto,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptCodeCard() {
    return OrderCard(
      child: Column(
        children: [
          const Text(
            'طريقة الاستلام عند وصول الطلب',
            style: TextStyle(
              color: _kNavy,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'لضمان إستلام أمن و سريع، أعرض علي السائق التالي لإستكمال عملية الاستلام.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _kGrey, fontSize: 10),
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kItemBorder),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'QR',
                        style: TextStyle(
                          color: _kNavy,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Image.asset(_kQrCode, width: 72, height: 72),
                      const SizedBox(height: 4),
                      const Text(
                        'اعرض هذا للسائق',
                        style: TextStyle(color: _kGrey, fontSize: 8),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Text(
                      'أو',
                      style: TextStyle(
                        color: _kNavy,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _kItemBorder),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'كود الإستلام',
                          style: TextStyle(
                            color: _kNavy,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: '8 6 3 5 6 4'
                              .split(' ')
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      color: _kGreen,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'صالح لمدة',
                          style: TextStyle(color: _kGrey, fontSize: 10),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'د 05:00',
                              style: TextStyle(
                                color: _kGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.timer_outlined,
                              color: _kGreen,
                              size: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: _kGreenTint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'لا تقم بمشاركة الكود مع أي شخص غير السائق الخاص بالطلب',
                  style: TextStyle(color: _kGreen, fontSize: 10),
                ),
                SizedBox(width: 6),
                Icon(Icons.verified_user_outlined, color: _kGreen, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard() {
    return OrderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'مراحل الطلب',
            style: TextStyle(
              color: _kNavy,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          const OrderFlow(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 65,
            child: SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: _kBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text(
                  'تم الاستلام',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 35,
            child: SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _kItemBorder),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.support_agent, color: _kBlue, size: 16),
                label: const Text(
                  'تواصل مع الدعم',
                  maxLines: 1,
                  style: TextStyle(
                    color: _kBlue,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'تتبع الطلب',
          style: TextStyle(
            color: _kNavy,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              _kCopy,
              width: 13,
              height: 13,
              colorFilter: const ColorFilter.mode(_kNavy, BlendMode.srcIn),
            ),
            const SizedBox(width: 6),
            const Text(
              'رقم الطلب : ORD-2024-256',
              style: TextStyle(color: _kGrey, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}

class _IconCard extends StatelessWidget {
  const _IconCard({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// The small green disc the tracking header sets before قيد التوصيل.
class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(color: _kGreen, shape: BoxShape.circle),
    );
  }
}

/// A muted label over its value, as the tracking cards stack every fact.
class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value, this.center = false});

  final String label;
  final String value;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _kGrey, fontSize: 8),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _kNavy,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SvgPicture.asset(asset, width: 48, height: 48),
    );
  }
}
