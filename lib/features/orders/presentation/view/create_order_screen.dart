import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/fuel_pump_icon.dart';
import '../../../../core/widgets/order_card.dart';
import '../../../../shared/enums/fuel_type.dart';

const _kAppBarLogo = 'assets/HomePage/appBar Logo.svg';
const _kNotification = 'assets/Icons/notification.svg';
// 'station.svg' is a 1024x1024 PNG embedded as base64 and painted through an
// SVG <pattern>. flutter_svg does not rasterise <image> elements, so it draws
// nothing — this is that same bitmap, extracted so it can be shown directly.
const _kStationArt = 'assets/Order/station.png';
const _kPin = 'assets/Order/pin.svg';
const _kBarePin = 'assets/Order/bare pin.svg';
const _kFlash = 'assets/Order/flash.svg';
const _kDate = 'assets/Order/date.svg';
const _kSadad = 'assets/Order/Sadaad.svg';
const _kPumpGlyph = 'assets/HomePage/gas station.svg';

const _kBlue = Color(0xFF1E5FFF);
const _kGreen = Color(0xFF17A34A);
const _kNavy = Color(0xFF0F1B2E);
const _kGrey = Color(0xFF8A93A6);
const _kBackground = Color(0xFFF5F6F8);
const _kItemBorder = Color(0xFFE6E9F0);
const _kGreenTint = Color(0xFFE4F7EC);
const _kBlueTint = Color(0xFFEEF2FF);

/// A selectable fuel grade. [type] is null for grades the backend catalogue
/// does not model yet (بنزين 98، كيروسين) — see the note on [_submit].
typedef _Grade = ({String label, String badge, Color color, FuelType? type});

// Laid out right-to-left in the design: 91 leads and كيروسين trails.
const List<_Grade> _kGrades = [
  (label: 'بنزين 91', badge: '91', color: Color(0xFFDC2626), type: FuelType.gasoline91),
  (label: 'بنزين 95', badge: '95', color: Color(0xFF9333EA), type: FuelType.gasoline95),
  (label: 'بنزين 98', badge: '98', color: Color(0xFF16A34A), type: null),
  (label: 'ديزل', badge: 'D', color: Color(0xFFF97316), type: FuelType.diesel),
  (label: 'كيروسين', badge: 'K', color: Color(0xFF2563EB), type: null),
];

const List<int> _kQuantities = [20000, 25000, 33000];

typedef _Station = ({String name, String area});

const List<_Station> _kFavouriteStations = [
  (name: 'محطة الصفا', area: 'جدة - الصفا'),
  (name: 'محطة الحمدانية', area: 'جدة - الحمدانية'),
  (name: 'محطة الرحاب', area: 'جدة - الرحاب'),
];

enum _Delivery { schedule, today, fastest }

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

  _Delivery _delivery = _Delivery.fastest;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final initial = _initialGradeIndex();
    _quantities[initial] = _kQuantities.first;
    _customQuantityControllers[initial] = TextEditingController();
  }

  /// Falls back to بنزين 98 — the grade selected in the design — when the
  /// screen is opened without a badge or with one that is not in the list.
  int _initialGradeIndex() {
    final badge = widget.initialGradeBadge;
    if (badge == null) return 2;
    final index = _kGrades.indexWhere((g) => g.badge == badge);
    return index == -1 ? 2 : index;
  }

  @override
  void dispose() {
    for (final controller in _customQuantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_quantities.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرجاء اختيار نوع وقود واحد على الأقل')));
      return;
    }

    final orderPayloads = <(FuelType, int)>[];
    for (final entry in _quantities.entries) {
      final grade = _kGrades[entry.key];
      final controller = _customQuantityControllers[entry.key]!;
      final quantity = entry.value ?? int.tryParse(controller.text.trim());

      if (quantity == null || quantity <= 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('أدخل كمية صحيحة لـ ${grade.label}')));
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
    for (int i = 0; i < orderPayloads.length; i++) {
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
        backgroundColor: _kBackground,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 20),
                  const _Title(),
                  const SizedBox(height: 20),
                  _buildStationSection(),
                  const SizedBox(height: 16),
                  _buildGradeSection(),
                  const SizedBox(height: 16),
                  _buildQuantitySection(),
                  const SizedBox(height: 16),
                  _buildDeliverySection(),
                  const SizedBox(height: 16),
                  _buildPaymentSection(),
                  const SizedBox(height: 16),
                  _buildOrderSummarySection(),
                  const SizedBox(height: 16),
                  _buildNotesSection(),
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
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
                      child: _buildConfirmButton(),
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

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // First child is right-most in RTL, so the bell leads and the back
        // button lands on the left, as designed.
        Stack(
          clipBehavior: Clip.none,
          children: [
            _IconCard(
              child: SvgPicture.asset(
                _kNotification,
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(_kNavy, BlendMode.srcIn),
              ),
              onTap: () => context.push(AppRoutes.notifications),
            ),
            Positioned(
              right: -4,
              top: -6,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Color(0xFFEF3F3F), shape: BoxShape.circle),
                child: const Text(
                  '3',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        SvgPicture.asset(_kAppBarLogo, height: 20),
        _IconCard(
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Icon(Icons.arrow_back_ios, size: 20, color: _kNavy),
          ),
          onTap: () => context.canPop() ? context.pop() : context.go(AppRoutes.clientHome),
        ),
      ],
    );
  }

  Widget _buildStationSection() {
    return _Section(
      title: '1. نوع الوقود',
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_back_ios, color: _kNavy, size: 16),
              const SizedBox(width: 8),
              Image.asset(_kStationArt, width: 64, height: 64),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'المحطة الحالية',
                          style: TextStyle(color: _kGreen, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 6),
                        SvgPicture.asset(
                          _kPin,
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(_kGreen, BlendMode.srcIn),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'محطة الرحاب',
                      style: TextStyle(color: _kNavy, fontSize: 18, fontWeight: FontWeight.w700),
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
          const SizedBox(height: 12),
          const Divider(height: 1, color: _kItemBorder),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star_border_rounded, size: 18, color: _kGrey),
              const SizedBox(width: 6),
              const Text('محطاتك المفضلة', style: TextStyle(color: _kGrey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          // Sharing the width rather than scrolling, so the third station is
          // never clipped off the edge.
          Row(
            children: [
              for (final (index, station) in _kFavouriteStations.indexed) ...[
                if (index > 0) const SizedBox(width: 8),
                Expanded(child: _FavouriteStationChip(station: station)),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'تغيير المحطة',
                style: TextStyle(color: _kGreen, fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 4),
              const Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(Icons.arrow_back_ios, size: 14, color: _kGreen),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleGrade(int index) {
    setState(() {
      if (_quantities.containsKey(index)) {
        _quantities.remove(index);
        _customQuantityControllers.remove(index)?.dispose();
      } else {
        _quantities[index] = _kQuantities.first;
        _customQuantityControllers[index] = TextEditingController();
      }
    });
  }

  Widget _buildGradeSection() {
    return _Section(
      title: '2. نوع الوقود',
      child: Row(
        children: [
          for (final (index, grade) in _kGrades.indexed) ...[
            if (index > 0) const SizedBox(width: 8),
            Expanded(
              child: _GradeTile(
                grade: grade,
                selected: _quantities.containsKey(index),
                onTap: () => _toggleGrade(index),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuantitySection() {
    if (_quantities.isEmpty) {
      return _Section(
        title: '3. الكمية',
        child: const Text('الرجاء اختيار نوع الوقود أولاً', style: TextStyle(color: _kGrey, fontSize: 13)),
      );
    }

    return _Section(
      title: '3. الكمية',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final entry in _quantities.entries) ...[
            if (entry.key != _quantities.keys.first) ...[
              const SizedBox(height: 12),
              const Divider(color: _kItemBorder),
              const SizedBox(height: 12),
            ],
            // The design shows a bare row of amounts; the grade only needs
            // naming once more than one is being ordered at a time.
            if (_quantities.length > 1) ...[
              Text(
                _kGrades[entry.key].label,
                style: const TextStyle(color: _kNavy, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Expanded(
                  child: _CustomQuantityField(
                    controller: _customQuantityControllers[entry.key]!,
                    onChanged: (_) => setState(() => _quantities[entry.key] = null),
                  ),
                ),
                for (final litres in _kQuantities.reversed) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuantityTile(
                      litres: litres,
                      selected: _quantities[entry.key] == litres,
                      onTap: () => setState(() {
                        _quantities[entry.key] = litres;
                        _customQuantityControllers[entry.key]!.clear();
                      }),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeliverySection() {
    return _Section(
      title: '4. موعد التوصيل',
      // IntrinsicHeight so the three tiles share the tallest one's height;
      // `stretch` alone would demand infinite height inside the ListView.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _DeliveryTile(
                asset: 'assets/Icons/schedule.svg',
                title: 'جدول موعد',
                subtitle: 'اختر التاريخ و الوقت',
                selected: _delivery == _Delivery.schedule,
                onTap: () => setState(() => _delivery = _Delivery.schedule),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DeliveryTile(
                asset: _kDate,
                title: 'اليوم',
                subtitle: 'توصيل خلال نفس اليوم',
                selected: _delivery == _Delivery.today,
                onTap: () => setState(() => _delivery = _Delivery.today),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DeliveryTile(
                asset: _kFlash,
                title: 'بأسرع وقت',
                subtitle: 'أقرب وقت متاح',
                selected: _delivery == _Delivery.fastest,
                onTap: () => setState(() => _delivery = _Delivery.fastest),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return _Section(
      title: '5. طريقة الدفع',
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kItemBorder),
        ),
        child: SvgPicture.asset(_kSadad, height: 34),
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    if (_quantities.isEmpty) return const SizedBox();
    final firstEntry = _quantities.entries.first;

    final grade = _kGrades[firstEntry.key];
    final controller = _customQuantityControllers[firstEntry.key]!;
    final quantity = firstEntry.value ?? int.tryParse(controller.text.trim()) ?? 0;

    final pricePerLiter = 2.33;
    final fuelTotal = quantity * pricePerLiter;
    final transportFees = 1200.00;
    final vatMock = 6000.00;
    final finalTotal = 46600.00;

    return OrderCard(
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, color: _kNavy, size: 20),
              SizedBox(width: 8),
              Text(
                'ملخص الطلب',
                style: TextStyle(color: _kNavy, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _SummaryColumn(title: 'نوع الوقود', value: grade.label),
              ),
              Expanded(
                child: _SummaryColumn(title: 'الكمية', value: '${_formatNumber(quantity)} لتر'),
              ),
              Expanded(
                child: _SummaryColumn(title: 'سعر اللتر', value: '${pricePerLiter.toStringAsFixed(2)} ريال'),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: 'الإجمالي\n(شامل الضريبة)',
                  value: '${_formatCurrency(fuelTotal)} ريال',
                  valueColor: _kBlue,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: _kItemBorder, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _SummaryColumn(title: 'رسوم النقل', value: '${_formatCurrency(transportFees)} ريال'),
              ),
              const Text(
                '+',
                style: TextStyle(color: _kBlue, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: 'ضريبة القيمة المضافة\n(%15)',
                  value: '${_formatCurrency(vatMock)} ريال',
                ),
              ),
              const Text(
                '=',
                style: TextStyle(color: _kBlue, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: 'الإجمالي النهائي',
                  value: '${_formatCurrency(finalTotal)} ريال',
                  valueColor: _kGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return OrderCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ملاحظات للسائق (اختياري)',
                  style: TextStyle(color: _kGrey, fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                TextField(
                  style: const TextStyle(color: _kNavy, fontSize: 13),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'اكتب أي ملاحظات خاصة بالتوصيل ...',
                    hintStyle: TextStyle(color: _kGrey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/Icons/locked.svg',
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(_kNavy, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  String _formatCurrency(double value) {
    final str = value.toStringAsFixed(2);
    final parts = str.split('.');
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final mathFunc = (Match match) => '${match[1]},';
    return '${parts[0].replaceAllMapped(reg, mathFunc)}.${parts[1]}';
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _submitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _submitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text('تأكيد الطلب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: SvgPicture.asset(
                        _kPumpGlyph,
                        width: 22,
                        height: 22,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'طلب وقود جديد',
          style: TextStyle(color: _kNavy, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 4),
        Text('اطلب الوقود خلال أقل من دقيقة', style: TextStyle(color: _kGrey, fontSize: 12)),
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
          boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 2))],
        ),
        child: child,
      ),
    );
  }
}

/// A numbered white card with its heading on the right, as the design lays out
/// every step of the form.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => OrderCard(title: title, child: child);
}

class _FavouriteStationChip extends StatelessWidget {
  const _FavouriteStationChip({required this.station});

  final _Station station;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kItemBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  station.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _kNavy, fontSize: 11, fontWeight: FontWeight.w700),
                ),
                Text(
                  station.area,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _kGrey, fontSize: 9),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(_kBarePin, width: 14, height: 14),
        ],
      ),
    );
  }
}

class _GradeTile extends StatelessWidget {
  const _GradeTile({required this.grade, required this.selected, required this.onTap});

  final _Grade grade;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          color: selected ? _kGreenTint : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? _kGreen : _kItemBorder, width: selected ? 1.4 : 1),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      FuelPumpIcon(grade: grade.badge, color: grade.color, size: 38),
                      if (selected)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            child: const Icon(Icons.check_circle, size: 18, color: _kGreen),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    grade.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _kNavy, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityTile extends StatelessWidget {
  const _QuantityTile({required this.litres, required this.selected, required this.onTap});

  final int litres;
  final bool selected;
  final VoidCallback onTap;

  static String _format(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _kBlueTint : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? _kBlue : _kItemBorder, width: selected ? 1.4 : 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _format(litres),
              style: TextStyle(color: selected ? _kBlue : _kNavy, fontSize: 14, fontWeight: FontWeight.w700),
            ),
            Text('لتر', style: TextStyle(color: selected ? _kBlue : _kNavy, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _CustomQuantityField extends StatelessWidget {
  const _CustomQuantityField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kItemBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: const TextStyle(color: _kNavy, fontSize: 13, fontWeight: FontWeight.w700),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'لتر',
                hintStyle: TextStyle(color: _kGrey, fontSize: 12),
              ),
            ),
          ),
          const Icon(Icons.edit_outlined, size: 16, color: _kGrey),
        ],
      ),
    );
  }
}

class _DeliveryTile extends StatelessWidget {
  const _DeliveryTile({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.withClock = false,
  });

  final String asset;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  /// Draws the small clock the design hangs off the calendar on جدول موعد,
  /// which the shared date artwork does not carry.
  final bool withClock;

  @override
  Widget build(BuildContext context) {
    final glyphColor = selected ? _kGreen : _kGrey;
    final titleColor = selected ? _kGreen : _kNavy;
    final subtitleColor = selected ? _kGreen : _kGrey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? _kGreenTint : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? _kGreen : _kItemBorder, width: selected ? 1.4 : 1),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(color: titleColor, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(color: subtitleColor, fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          asset,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(glyphColor, BlendMode.srcIn),
                        ),
                        if (withClock)
                          Positioned(
                            left: -2,
                            bottom: -2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: selected ? Colors.white : _kBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.access_time_filled, size: 10, color: glyphColor),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Positioned(top: 6, right: 6, child: Icon(Icons.check_circle, size: 14, color: _kGreen)),
          ],
        ),
      ),
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  const _SummaryColumn({required this.title, required this.value, this.valueColor = const Color(0xFF0F1B2E)});

  final String title;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF8A93A6), fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: valueColor, fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
