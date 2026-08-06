import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/order_flow.dart';

const _kAppBarLogo = 'assets/HomePage/appBar Logo.svg';
const _kProfileImage = 'assets/HomePage/profile image.png';
const _kNotification = 'assets/Icons/notification.svg';

const _kStationIcon = 'assets/HomePage/green station.svg';
const _kStation1Icon = 'assets/HomePage/green gun.svg';
const _kStation2Icon = 'assets/HomePage/red invoice.svg';
// 'gas .svg' has the grade "95" baked into the artwork, so it can only ever be
// correct for one tile; 'gas station.svg' is the same pump without the number.
const _kGasStationIcon = 'assets/HomePage/gas station.svg';
const _kTruckIcon = 'assets/HomePage/truck.svg';

// Despite its name, 'السائق.svg' is the tanker artwork and 'profile.svg' is the
// person — so the driver row uses profile and the truck row uses السائق.
const _kDriverIcon = 'assets/HomePage/profile.svg';
const _kLorryIcon = 'assets/HomePage/السائق.svg';
const _kDateIcon = 'assets/HomePage/date.svg';
const _kHourIcon = 'assets/HomePage/flow/hour.svg';

// Grey (#9CA3AF) artwork, so it is tinted to the counter's colour at use.
const _kStatTruckIcon = 'assets/Icons/truck.svg';

const _kPhone = 'assets/Icons/phone.svg';
const _kMap = 'assets/HomePage/map.svg';
const _kAdd = 'assets/HomePage/add.svg';

// Pump geometry inside 'gas station.svg', as fractions of the icon box, so the
// fuel grade can be laid on the pump's face rather than the icon's centre.
const _kActionButtonHeight = 40.0;
const _kFuelIconSize = 26.0;
const _kPumpBodyLeft = 0.05;
const _kPumpBodyWidth = 0.63;
const _kPumpFaceTop = 0.42;
const _kPumpFaceHeight = 0.50;

const _kBlue = Color(0xFF1E5FFF);
const _kGreen = Color(0xFF17A34A);
const _kNavy = Color(0xFF0F1B2E);
const _kGrey = Color(0xFF8A93A6);
const _kBackground = Color(0xFFF5F6F8);
const _kItemBorder = Color(0xFFE6E9F0);
// نظرة سريعة counters (Light/Brand Red and a warm amber for "in preparation").
const _kStatRed = Color(0xFFEF3F3F);
const _kStatAmber = Color(0xFFF59E0B);

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _kBackground,
        body: SafeArea(
          child: Stack(
            children: [
              // Scrollable Content
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 16.0,
                    bottom: 120.0, // Space for NavBar
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildAppBar(),
                      const SizedBox(height: 24),
                      _buildCurrentStationCard(),
                      const SizedBox(height: 16),
                      _buildFinanceCards(),
                      const SizedBox(height: 24),
                      _buildNewRequestButton(),
                      const SizedBox(height: 32),
                      const Text(
                        'طلبك الحالي',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _kNavy,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCurrentOrderCard(),
                      const SizedBox(height: 32),
                      const Text(
                        'طلب سريع',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _kNavy,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildQuickRequestList(),
                      const SizedBox(height: 32),
                      const Text(
                        'نظرة سريعة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _kNavy,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildQuickGlance(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile Image (RIGHT in RTL). The PNG already draws its own white
        // ring on transparent corners, so it is rendered plain — a circle clip
        // and Border here produced a second ring and shrank the photo.
        Image.asset(_kProfileImage, width: 48, height: 48),

        // Center Logo
        SvgPicture.asset(_kAppBarLogo, height: 20),

        // Notification Icon with Badge (LEFT in RTL)
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () => context.push(AppRoutes.notifications),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  _kNotification,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(_kNavy, BlendMode.srcIn),
                ),
              ),
            ),
            Positioned(
              left: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentStationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // RTL row: the first child renders right-most, so the order
                // here is chevron, icon, then the text block filling the rest.
                // `arrow_back_ios` is mirrored under RTL (matchTextDirection),
                // so it is what actually draws the '>' the design shows.
                const Icon(Icons.arrow_back_ios, color: _kNavy, size: 16),
                const SizedBox(width: 12),
                SvgPicture.asset(_kStationIcon, width: 56, height: 56),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    // In RTL, `end` is the left edge — where the design sits
                    // this block.
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        // Hug the content, otherwise the row spans the full
                        // width and the label snaps back to the right.
                        mainAxisSize: MainAxisSize.min,
                        // Label first so the pin lands to its left, as designed.
                        children: [
                          const Text(
                            'المحطة الحالية',
                            style: TextStyle(
                              color: _kGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.location_on_outlined,
                            color: _kGreen,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'محطة الرحاب',
                        style: TextStyle(
                          color: _kNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'جدة - طريق مكة القديم - حي البوادي',
                        style: TextStyle(color: _kGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _kItemBorder),
          InkWell(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Row(
                // `end` packs the pair against the left edge; label first so
                // the chevron sits to its left. `arrow_forward_ios` is
                // mirrored under RTL, which is what draws the '<' shown.
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'تغيير المحطة',
                    style: TextStyle(
                      color: _kGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, color: _kGreen, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Order-status counters. Listed so that, in RTL, تم التوصيل ends up on the
  /// left and ملغاة on the right — the order shown in the design.
  Widget _buildQuickGlance() {
    // `asset` wins over `icon` where artwork exists; the other three counters
    // have none yet and fall back to the closest Material glyph.
    const List<
      ({String label, String count, Color color, IconData? icon, String? asset})
    >
    stats = [
      (
        label: 'ملغاة',
        count: '0',
        color: _kStatRed,
        icon: Icons.highlight_off,
        asset: null,
      ),
      (
        label: 'قيد التجهيز',
        count: '1',
        color: _kStatAmber,
        icon: Icons.hourglass_empty,
        asset: null,
      ),
      (
        label: 'قيد التوصيل',
        count: '3',
        color: _kBlue,
        icon: Icons.access_time,
        asset: null,
      ),
      (
        label: 'تم التوصيل',
        count: '12',
        color: _kGreen,
        // Uses the truck artwork, so it has no Material fallback.
        icon: null,
        asset: _kStatTruckIcon,
      ),
    ];

    // Four separate cards rather than one bordered strip, as designed.
    return Row(
      children: [
        for (final (index, stat) in stats.indexed) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kItemBorder),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Count first so it sits right-most in RTL, putting the
                      // icon immediately to its left.
                      Text(
                        stat.count,
                        style: TextStyle(
                          color: stat.color,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // SvgPicture keeps the source aspect ratio, so the 17x16
                      // truck would sit 1px wider than the Material glyphs
                      // beside it — the SizedBox pins every icon to 16x16.
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: stat.asset == null
                            ? Icon(stat.icon, size: 16, color: stat.color)
                            : SvgPicture.asset(
                                stat.asset!,
                                fit: BoxFit.contain,
                                colorFilter: ColorFilter.mode(
                                  stat.color,
                                  BlendMode.srcIn,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stat.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _kGrey, fontSize: 9),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFinanceCards() {
    return Row(
      children: [
        // First child renders right-most in RTL.
        Expanded(
          child: _buildFinanceCard(
            label: 'فاتورة مستحقة',
            amount: '128,450',
            asset: _kStation2Icon,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFinanceCard(
            label: 'الرصيد المتاح',
            amount: '128,450',
            asset: _kStation1Icon,
          ),
        ),
      ],
    );
  }

  Widget _buildFinanceCard({
    required String label,
    required String amount,
    required String asset,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kItemBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: _kGrey, fontSize: 10),
                ),
                const SizedBox(height: 4),
                // Text.rich, not RichText: RichText ignores DefaultTextStyle,
                // so the amount would fall back to the platform font instead
                // of the app's Tajawal.
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$amount ',
                        style: const TextStyle(
                          color: _kNavy,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text: 'ريال',
                        style: TextStyle(color: _kGrey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(asset, width: 44, height: 44),
        ],
      ),
    );
  }

  Widget _buildNewRequestButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _kBlue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _kBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.push(AppRoutes.clientCreateOrder),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  _kAdd,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  width: 20,
                  height: 20,
                ),
                const Text(
                  'طلب وقود جديد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SvgPicture.asset(
                  _kGasStationIcon,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentOrderCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top header: fuel type on the right, status badge on the left.
            // In RTL the first child renders right-most.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'بنزين 95',
                      style: TextStyle(color: _kGrey, fontSize: 10),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '20,000 لتر',
                      style: TextStyle(
                        color: _kNavy,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _kGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: _kGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'قيد التوصيل',
                        style: TextStyle(
                          color: _kGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Middle Section
            Row(
              children: [
                // Fuel type + Driver info (RIGHT in RTL = start)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(_kDriverIcon, width: 16, height: 16),
                          const SizedBox(width: 8),
                          // Expanded so a long driver name shrinks instead of
                          // overflowing this half of the order card.
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'السائق',
                                  style: TextStyle(color: _kGrey, fontSize: 10),
                                ),
                                const Text(
                                  'أحمد السبيعي',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: _kNavy,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SvgPicture.asset(_kLorryIcon, width: 16, height: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'الشاحنة',
                                  style: TextStyle(color: _kGrey, fontSize: 10),
                                ),
                                const Text(
                                  'ABC-1234',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: _kNavy,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Center Circular Progress
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: CircularProgressIndicator(
                          value: 0.65,
                          backgroundColor: const Color(0xFFE6E9F0),
                          color: _kGreen,
                          strokeWidth: 5,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            _kTruckIcon,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              _kNavy,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'الوصول خلال',
                            style: TextStyle(color: _kGrey, fontSize: 8),
                          ),
                          const Text(
                            '35',
                            style: TextStyle(
                              color: _kGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                            ),
                          ),
                          const Text(
                            'دقيقة',
                            style: TextStyle(color: _kGreen, fontSize: 8),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Order ID + Date/Time (LEFT in RTL = end)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'ORD-2024-256',
                        style: TextStyle(
                          color: _kNavy,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            '02/05/2024',
                            style: TextStyle(color: _kGrey, fontSize: 10),
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset(_kDateIcon, width: 12, height: 12),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            '04:35 م',
                            style: TextStyle(color: _kGrey, fontSize: 10),
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset(_kHourIcon, width: 12, height: 12),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'وقت الطلب',
                        style: TextStyle(color: _kGrey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            // Stepper
            const OrderFlow(),
            const SizedBox(height: 24),

            // Action Buttons — a shared height and label widget keep the two
            // the same size, since they previously differed in text scale and
            // icon gap and so did not line up.
            SizedBox(
              height: _kActionButtonHeight,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const _ActionButtonLabel(
                        asset: _kMap,
                        label: 'تتبع الطلب على الخريطة',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: _kItemBorder),
                      ),
                      child: const _ActionButtonLabel(
                        asset: _kPhone,
                        label: 'تواصل مع السائق',
                        color: _kNavy,
                        iconColor: _kGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickRequestList() {
    final List<Map<String, dynamic>> items = [
      {'title': 'كيروسين', 'color': const Color(0xFF2563EB), 'icon': 'K'},
      {'title': 'ديزل', 'color': const Color(0xFFF97316), 'icon': 'D'},
      {'title': 'بنزين 98', 'color': const Color(0xFF16A34A), 'icon': '98'},
      {'title': 'بنزين 95', 'color': const Color(0xFF9333EA), 'icon': '95'},
      {'title': 'بنزين 91', 'color': const Color(0xFFDC2626), 'icon': '91'},
    ];

    // A fixed-width scrolling list pushed the last grade (بنزين 91) off the
    // edge, so the five share the available width instead and all stay visible.
    return SizedBox(
      height: 90,
      child: Row(
        children: [
          for (final (index, item) in items.indexed) ...[
            if (index > 0) const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                // Opens the order form already on the grade that was tapped —
                // the badge ('95', 'D', …) is what the form matches on.
                onTap: () => context.push(
                  AppRoutes.clientCreateOrder,
                  extra: item['icon'] as String,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE6E9F0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: item['color'] as Color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SizedBox(
                          width: _kFuelIconSize,
                          height: _kFuelIconSize,
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                _kGasStationIcon,
                                width: _kFuelIconSize,
                                height: _kFuelIconSize,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              // The grade goes on the pump's body, not in the middle
                              // of the icon — the nozzle takes up the right third.
                              // Centring inside the body rect keeps one-character
                              // grades ('K') and two-digit ones ('98') aligned the
                              // same. The white tint makes the body solid white, so
                              // the grade is drawn in the tile colour to stay legible.
                              Positioned(
                                left: _kFuelIconSize * _kPumpBodyLeft,
                                width: _kFuelIconSize * _kPumpBodyWidth,
                                top: _kFuelIconSize * _kPumpFaceTop,
                                height: _kFuelIconSize * _kPumpFaceHeight,
                                child: Center(
                                  child: Text(
                                    item['icon'] as String,
                                    style: TextStyle(
                                      color: item['color'] as Color,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _kNavy,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shared contents for the order card's two action buttons, so they keep the
/// same icon size, gap and text scale. The label is [Flexible] because
/// 'تتبع الطلب على الخريطة' is long enough to overflow at half the card width.
class _ActionButtonLabel extends StatelessWidget {
  const _ActionButtonLabel({
    required this.asset,
    required this.label,
    required this.color,
    this.iconColor,
  });

  final String asset;
  final String label;
  final Color color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          asset,
          width: 14,
          height: 14,
          colorFilter: ColorFilter.mode(iconColor ?? color, BlendMode.srcIn),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
