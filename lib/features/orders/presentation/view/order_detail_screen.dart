import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/delivery_time_card.dart';
import '../../../../core/widgets/order_card.dart';
import '../../../../core/widgets/order_flow.dart';
import 'invoice_payment_screen.dart';
import 'track_order_screen.dart';

enum MockOrderState {
  pendingReview,
  confirmed,
  waitingPayment,

  /// Payment pushed to the next order — the receipt shows, but in the
  /// deferred rather than the settled treatment.
  deferred,
  paid,
  inTransit,
  delivered,
}

const _kBlue = Color(0xFF1E5FFF);
const _kGreen = Color(0xFF17A34A);
const _kOrange = Color(0xFFF97316);
const _kNavy = Color(0xFF0F1B2E);
const _kGrey = Color(0xFF8A93A6);
const _kItemBorder = Color(0xFFE6E9F0);
const _kChipBg = Color(0xFFECEFF4);

/// One step of the order-progress bar, mirroring the five variants in
/// `assets/Order/status/`. Those SVGs bake a placeholder label into their
/// paths, so the bar and dot are redrawn here to their measurements — 110x8
/// track at radius 4, a 3x3 dot 8 above it — with real text for the label.
enum _StepStatus {
  /// Bar filled end to end.
  finished(Color(0xFF12A150), filled: true),

  /// Bar filled to the halfway point.
  onProgress(Color(0xFF1E5FFF)),

  /// Half-filled like [onProgress], in the alert colour.
  warning(Color(0xFFFF5810)),

  /// Filled end to end, in the error colour. No screen in the current
  /// designs reaches it, but it completes the artwork's set.
  // ignore: unused_field
  failed(Color(0xFFEF3F3F), filled: true),

  /// Track only; the dot still shows the journey ahead.
  notFinished(Color(0xFF1E5FFF), fraction: 0);

  const _StepStatus(this.color, {bool filled = false, double? fraction})
    : fraction = fraction ?? (filled ? 1 : 0.5);

  final Color color;

  /// How much of the track the fill covers, measured from the leading edge.
  final double fraction;
}

const _kStepTrack = Color(0xFFE7E9EF);
const _kStepLabel = Color(0xFF6B7280);

const _kOrderReference = 'ORD-2024-256 · 9 صفر 1448';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({
    super.key,
    required this.orderId,
    this.mockState = MockOrderState.pendingReview,
  });

  final String orderId;
  final MockOrderState mockState;

  @override
  Widget build(BuildContext context) {
    // Return the view directly for static UI preview, removing Cubits and APIs
    return _OrderDetailView(orderId: orderId, mockState: mockState);
  }
}

class _OrderDetailView extends StatefulWidget {
  const _OrderDetailView({
    required this.orderId,
    this.mockState = MockOrderState.pendingReview,
  });

  final String orderId;
  final MockOrderState mockState;

  @override
  State<_OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<_OrderDetailView> {
  late MockOrderState _currentState;

  /// The receipt breakdown starts open, except once the order is delivered —
  /// by then the total is all the design keeps on screen.
  late bool _detailsExpanded;

  @override
  void initState() {
    super.initState();
    _currentState = widget.mockState;
    _detailsExpanded = _currentState != MockOrderState.delivered;
  }

  bool get _deferred => _currentState == MockOrderState.deferred;

  /// Green once the invoice is settled, orange while it is still owed.
  Color get _receiptAccent => _deferred ? _kOrange : _kGreen;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 32),
                  _buildStepper(),
                  const SizedBox(height: 24),
                  if (_currentState == MockOrderState.paid ||
                      _currentState == MockOrderState.deferred ||
                      _currentState == MockOrderState.delivered) ...[
                    _buildSettledOrderStatus(),
                    const SizedBox(height: 16),
                    const DeliveryTimeCard(),
                    const SizedBox(height: 16),
                    _buildReceiptCard(),
                  ] else if (_currentState == MockOrderState.inTransit) ...[
                    _buildInTransitOrderStatus(),
                    const SizedBox(height: 16),
                    _buildReceiptCodeCard(),
                    const SizedBox(height: 16),
                    const DeliveryTimeCard(),
                  ] else ...[
                    _buildOrderSummary(),
                    const SizedBox(height: 16),
                    if (_currentState == MockOrderState.pendingReview)
                      _buildPendingOrderStatus()
                    else
                      _buildPayableOrderStatus(),
                    const SizedBox(height: 16),
                    if (_currentState != MockOrderState.pendingReview) ...[
                      _buildCreditLimit(),
                      const SizedBox(height: 16),
                    ],
                    const DeliveryTimeCard(),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          const order = MockOrderState.values;
                          _currentState =
                              order[(_currentState.index + 1) % order.length];
                          _detailsExpanded =
                              _currentState != MockOrderState.delivered;
                        });
                      },
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('تغيير الحالة (Mock)'),
                    ),
                  ),
                ],
              ),
              Positioned(bottom: 24, right: 20, child: _buildSupportFab()),
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
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
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
              child: const Icon(
                Icons.notifications_none,
                color: Color(0xFF0F1B2E),
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
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        SvgPicture.asset('assets/HomePage/appBar Logo.svg', height: 20),
        GestureDetector(
          onTap: () => context.pop(),
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
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Color(0xFF0F1B2E),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Status of each of the four steps, right-to-left:
  /// تأكيد الطلب، الدفع، التوصيل، التسليم.
  List<_StepStatus> _stepStatuses() {
    const done = _StepStatus.finished;
    const todo = _StepStatus.notFinished;
    switch (_currentState) {
      case MockOrderState.pendingReview:
        return const [_StepStatus.onProgress, todo, todo, todo];
      case MockOrderState.confirmed:
        return const [done, _StepStatus.onProgress, todo, todo];
      case MockOrderState.waitingPayment:
      case MockOrderState.deferred:
        return const [done, _StepStatus.warning, todo, todo];
      case MockOrderState.paid:
        return const [done, done, todo, todo];
      case MockOrderState.inTransit:
        return const [done, done, _StepStatus.onProgress, todo];
      case MockOrderState.delivered:
        return const [done, done, done, done];
    }
  }

  Widget _buildStepper() {
    final statuses = _stepStatuses();
    const titles = ['تأكيد الطلب', 'الدفع', 'التوصيل', 'التسليم'];
    // التوصيل runs about four times the length of the other three, which are
    // all of a size — measured off the design.
    const flexes = [1, 1, 4, 1];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < titles.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(flex: flexes[i], child: _buildStep(titles[i], statuses[i])),
        ],
      ],
    );
  }

  Widget _buildStep(String title, _StepStatus status) {
    return Column(
      children: [
        Text(
          title,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: const TextStyle(color: _kStepLabel, fontSize: 10),
        ),
        const SizedBox(height: 6),
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            color: status.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        // The Column hands out loose constraints, so without this the bar would
        // shrink-wrap its fill: the track would never show and the fill would
        // sit centred instead of against the leading edge.
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 8,
              color: _kStepTrack,
              // Fills from the leading (right) edge under RTL, as the artwork does.
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: status.fraction,
                child: ColoredBox(color: status.color),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return OrderCard(
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, color: _kNavy, size: 20),
              SizedBox(width: 8),
              Text(
                'ملخص الطلب',
                style: TextStyle(
                  color: _kNavy,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _SummaryColumn(title: 'نوع الوقود', value: 'بنزين 98'),
              ),
              Expanded(
                child: _SummaryColumn(title: 'الكمية', value: '20,000 لتر'),
              ),
              Expanded(
                child: _SummaryColumn(title: 'سعر اللتر', value: '2.33 ريال'),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: 'الإجمالي\n(شامل الضريبة)',
                  value: '46,600.00 ريال',
                  valueColor: Color(0xFF1E5FFF),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFE6E9F0), height: 1),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _SummaryColumn(
                  title: 'رسوم النقل',
                  value: '1,200.00 ريال',
                ),
              ),
              Text(
                '+',
                style: TextStyle(
                  color: Color(0xFF1E5FFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: 'ضريبة القيمة المضافة\n(%15)',
                  value: '6,060.00 ريال',
                ),
              ),
              Text(
                '=',
                style: TextStyle(
                  color: Color(0xFF1E5FFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: 'الإجمالي النهائي',
                  value: '46,600.00 ريال',
                  valueColor: Color(0xFF17A34A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// The plain status card carried by every state that already has a receipt.
  /// Only delivery adds a follow-up action.
  Widget _buildSettledOrderStatus() {
    const headlines = {
      MockOrderState.deferred: 'مؤجلة للمرة القادمة',
      MockOrderState.paid: 'تم السداد',
      MockOrderState.delivered: 'تم التسليم',
    };

    return OrderCard(
      title: 'حالة الطلب',
      subtitle: _kOrderReference,
      trailing: Text(
        headlines[_currentState]!,
        style: TextStyle(
          color: _currentState == MockOrderState.deferred ? _kOrange : _kBlue,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentState == MockOrderState.delivered) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _kItemBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh, color: _kGreen, size: 18),
                label: const Text(
                  'طلب أخر',
                  style: TextStyle(
                    color: _kGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kItemBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // The accent reads across the top edge only. It is a strip rather
          // than a Border side because a rounded box needs one uniform colour.
          Container(height: 3, color: _receiptAccent),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.share_outlined, color: _kBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_deferred) const _DeferredSeal() else const _SuccessSeal(),
                const SizedBox(height: 8),
                Text(
                  _deferred ? 'مؤجلة للمرة القادمة' : 'تم الدفع بنجاح',
                  style: TextStyle(
                    color: _receiptAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                _buildBreakdownRow(
                  'الرقم المرجعي',
                  '#889241035',
                  isRightGray: true,
                ),
                const SizedBox(height: 8),
                _buildBreakdownRow('اليوم', '9 صفر 1446', isRightGray: true),
                const SizedBox(height: 8),
                _buildBreakdownRow('الساعة', '06.30 صباحاً', isRightGray: true),
                const SizedBox(height: 16),
                _buildReceiptBreakdown(),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, color: _kBlue),
                  label: const Text(
                    'تنزيل الإيصال',
                    style: TextStyle(
                      color: _kBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SvgPicture.asset('assets/Order/Sadaad.svg', height: 26),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The line-by-line receipt, boxed and collapsible as in the design: open it
  /// shows both invoices, closed it keeps only the total.
  Widget _buildReceiptBreakdown() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kItemBorder),
      ),
      child: Column(
        children: [
          if (_detailsExpanded) ...[
            _buildBreakdownRow(
              'بنزين 95 • 20,000 لتر',
              '450,000.00 ر.س',
              isMain: true,
            ),
            const SizedBox(height: 8),
            _buildBreakdownRow('رسوم التوصيل', '30.00 ر.س'),
            const SizedBox(height: 8),
            _buildBreakdownRow('رسوم خدمة', '30.00 ر.س'),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    'assets/Icons/copy.svg',
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF1E5FFF),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'فاتورة مؤجلة',
                        style: TextStyle(
                          color: _kOrange,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'يجب دفع الفاتورة المؤجلة لأستكمال العملية الحالية',
                        style: TextStyle(color: _kGreen, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBreakdownRow(
              'بنزين 95 • 20,000 لتر',
              '450,000.00 ر.س',
              isMain: true,
            ),
            const SizedBox(height: 8),
            _buildBreakdownRow('رسوم التوصيل', '30.00 ر.س'),
            const SizedBox(height: 8),
            _buildBreakdownRow('رسوم خدمة', '30.00 ر.س'),
            const SizedBox(height: 16),
          ],
          _DetailsToggle(
            expanded: _detailsExpanded,
            onTap: () => setState(() => _detailsExpanded = !_detailsExpanded),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الإجمالي',
                style: TextStyle(
                  color: _kNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '600,120.00 ',
                      style: TextStyle(
                        color: _kGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: 'ر.س',
                      style: TextStyle(color: _kGreen, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
    String title,
    String value, {
    bool isMain = false,
    bool isRightGray = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: _kGrey,
            fontSize: isMain ? 11 : 10,
            fontWeight: isMain ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isRightGray ? _kGrey : _kNavy,
            fontSize: isMain ? 13 : 12,
            fontWeight: isMain ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildInTransitOrderStatus() {
    return OrderCard(
      dashed: true,
      title: 'حالة الطلب',
      subtitle: _kOrderReference,
      trailing: const _StatusChip('قيد التوصيل', color: _kBlue),
      child: Column(
        children: [
          // The journey — gauge, consignment details and the flow — is boxed
          // off from the card's heading and actions.
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(OrderCard.radius),
              border: Border.all(color: _kItemBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        children: [
                          _TransitDetailRow(
                            label: 'بنزين 95',
                            value: '20,000 لتر',
                          ),
                          SizedBox(height: 12),
                          _TransitDetailRow(
                            label: 'السائق',
                            value: 'أحمد السبيعي',
                            icon: Icons.person_outline,
                          ),
                          SizedBox(height: 12),
                          _TransitDetailRow(
                            label: 'الشاحنة',
                            value: 'ABC-1234',
                            icon: Icons.local_shipping_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const _EtaGauge(minutes: 35, progress: 0.75),
                  ],
                ),
                const SizedBox(height: 24),
                const OrderFlow(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 55,
                child: SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const TrackOrderScreen(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _kBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.map_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'تتبع الطلب علي الخريطة',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 45,
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _kItemBorder),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.phone_outlined,
                      color: _kNavy,
                      size: 16,
                    ),
                    label: const Text(
                      'تواصل مع السائق',
                      maxLines: 1,
                      style: TextStyle(
                        color: _kNavy,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _buildReceiptCodeCard() {
    return OrderCard(
      child: Column(
        children: [
          const Text(
            'طريقة الاستلام عند وصول الطلب',
            style: TextStyle(
              color: Color(0xFF0F1B2E),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'لضمان إستلام أمن و سريع، أعرض علي السائق التالي لاستكمال عملية الاستلام.',
            style: TextStyle(color: Color(0xFF8A93A6), fontSize: 10),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6E9F0)),
                ),
                child: Column(
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
                    Image.asset(
                      'assets/Icons/QR Code.png',
                      width: 72,
                      height: 72,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'اعرض هذا للسائق',
                      style: TextStyle(color: Color(0xFF8A93A6), fontSize: 8),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'أو',
                  style: TextStyle(
                    color: Color(0xFF0F1B2E),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE6E9F0)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'كود الإستلام',
                        style: TextStyle(
                          color: Color(0xFF0F1B2E),
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
                                    color: Color(0xFF17A34A),
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
                        style: TextStyle(
                          color: Color(0xFF8A93A6),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'د 05:00',
                            style: TextStyle(
                              color: Color(0xFF17A34A),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.timer_outlined,
                            color: Color(0xFF17A34A),
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
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE4F7EC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'لا تقم بمشاركة الكود مع أي شخص غير السائق الخاص بالطلب',
                  style: TextStyle(color: Color(0xFF17A34A), fontSize: 10),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFF17A34A),
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The card the order sits in once it can be paid — identical either side of
  /// the invoice being raised, bar the badge and the pay button's wording.
  Widget _buildPayableOrderStatus() {
    final invoicePending = _currentState == MockOrderState.waitingPayment;

    return OrderCard(
      dashed: true,
      title: 'حالة الطلب',
      subtitle: _kOrderReference,
      trailing: _StatusChip(invoicePending ? 'الفاتورة معلقة' : 'تم التأكيد'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const InvoicePaymentScreen(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _kBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.credit_card,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: Text(
                      invoicePending ? 'إكمال الدفع' : 'إدفع',
                      style: const TextStyle(
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
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _kItemBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(
                        color: _kBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton.icon(
              onPressed: () => setState(() {
                _currentState = MockOrderState.deferred;
                _detailsExpanded = true;
              }),
              style: FilledButton.styleFrom(
                backgroundColor: _kGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.bookmark_outline,
                size: 18,
                color: Colors.white,
              ),
              label: const Text(
                'إدفع المرة القادمة',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.credit_card_outlined,
                color: _kNavy,
                size: 18,
              ),
              label: const Text(
                'أطلب حد إئتماني',
                style: TextStyle(
                  color: _kNavy,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingOrderStatus() {
    return OrderCard(
      title: 'حالة الطلب',
      subtitle: _kOrderReference,
      trailing: const Text(
        'قيد المراجعة',
        style: TextStyle(
          color: _kBlue,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE6E9F0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Color(0xFF1E5FFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditLimit() {
    return OrderCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الحد الإئتماني',
                    style: TextStyle(
                      color: Color(0xFF0F1B2E),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'صالح حتى 9 صفر 1446',
                    style: TextStyle(color: Color(0xFF1E5FFF), fontSize: 10),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4F7EC),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'نشط',
                      style: TextStyle(
                        color: Color(0xFF17A34A),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.credit_card_outlined,
                      color: Color(0xFFF97316),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المتاح للدفع الآن',
                style: TextStyle(
                  color: _kNavy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              const Flexible(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '120,000.00 ',
                        style: TextStyle(
                          color: _kNavy,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: 'ر.س',
                        style: TextStyle(color: _kGrey, fontSize: 12),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Expanded(
                  flex: 63,
                  child: Container(height: 6, color: const Color(0xFFF97316)),
                ),
                Expanded(
                  flex: 37,
                  child: Container(height: 6, color: const Color(0xFFE6E9F0)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'من 200,000.00 ر.س',
                  style: TextStyle(
                    color: _kNavy,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Flexible(
                child: Text(
                  'مستخدم 200,000.00 ر.س (37.5%)',
                  textAlign: TextAlign.end,
                  style: TextStyle(color: _kGrey, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE4F7EC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'هذا الطلب ضمن حدك الإئتماني',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF17A34A),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF97316),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'أدفع من الحد الإئتماني',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportFab() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1E5FFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x331E5FFF),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.push(AppRoutes.support),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'الدعم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.headset_mic_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The muted pill the design uses for an order's headline state.
class _StatusChip extends StatelessWidget {
  const _StatusChip(this.label, {this.color = _kNavy});

  final String label;

  /// Ink for the label. Most states read navy; قيد التوصيل is called out.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _kChipBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// A label/value pair with its glyph on the trailing side, as the in-transit
/// card stacks the fuel, driver and truck.
class _TransitDetailRow extends StatelessWidget {
  const _TransitDetailRow({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;

  /// Omitted on the consignment line, which the design leaves unglyphed.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Icon(icon, color: _kGreen, size: 20)
        else
          const SizedBox(width: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _kGrey, fontSize: 10),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _kNavy,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The deferred counterpart of [_SuccessSeal] — same dashed ring, drawn in the
/// alert colour around a clock. Swap in an artwork asset if one lands.
class _DeferredSeal extends StatelessWidget {
  const _DeferredSeal();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: _DashedRingPainter(),
        child: const Center(
          child: Icon(Icons.schedule, color: _kOrange, size: 30),
        ),
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final solid = Paint()
      ..color = _kOrange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2 - 1, solid);

    final ring = Path()
      ..addOval(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: size.width / 2 - 6,
        ),
      );

    for (final metric in ring.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), solid);
        distance += 9;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// The "arriving in N minutes" dial: a ring showing how far along the run is,
/// wrapped around the truck and the countdown.
class _EtaGauge extends StatelessWidget {
  const _EtaGauge({required this.minutes, required this.progress});

  final int minutes;

  /// Share of the journey behind the driver. The arc opens at twelve o'clock
  /// and sweeps clockwise, so the gap it leaves sits at the upper left.
  final double progress;

  static const _size = 76.0;
  static const _stroke = 8.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: CustomPaint(
        painter: _GaugePainter(progress: progress, stroke: _stroke),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_shipping, color: _kNavy, size: 16),
              const Text(
                'الوصول خلال',
                style: TextStyle(color: _kNavy, fontSize: 8),
              ),
              Text(
                '$minutes',
                style: const TextStyle(
                  color: _kGreen,
                  fontSize: 19,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'دقيقة',
                style: TextStyle(color: _kGreen, fontSize: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.progress, required this.stroke});

  final double progress;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect =
        Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = _kStepTrack
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      Paint()
        ..color = _kGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.stroke != stroke;
}

/// The animated dashed-ring tick that heads the paid receipt.
class _SuccessSeal extends StatelessWidget {
  const _SuccessSeal();

  /// Side of the seal at rest — the ring the design draws at 64pt.
  static const _size = 64.0;

  /// The resting ring occupies 208 of the GIF's 640px canvas, so the frame is
  /// drawn oversized and the surrounding transparency cropped away; otherwise
  /// the tick would render at a third of its intended size.
  static const _restingArtwork = 208.0;
  static const _canvas = _size * 640 / _restingArtwork;

  /// Mid-animation the ring swells to 253px of that canvas, so the box has to
  /// leave room for it — sized to the resting ring the outer sweep gets cut.
  static const _peakArtwork = 253.0;
  static const _box = _size * _peakArtwork / _restingArtwork;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: _box,
        height: _box,
        child: OverflowBox(
          maxWidth: _canvas,
          maxHeight: _canvas,
          child: Image.asset(
            'assets/Order/Done.gif',
            width: _canvas,
            height: _canvas,
          ),
        ),
      ),
    );
  }
}

/// The `إظهار / إخفاء التفاصيل` control, centred in a hairline rule.
class _DetailsToggle extends StatelessWidget {
  const _DetailsToggle({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: _kItemBorder)),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(
                  expanded ? 'إخفاء التفاصيل' : 'إظهار التفاصيل',
                  style: const TextStyle(
                    color: _kGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  expanded
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: _kGreen,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
        const Expanded(child: Divider(color: _kItemBorder)),
      ],
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  const _SummaryColumn({
    required this.title,
    required this.value,
    this.valueColor = const Color(0xFF0F1B2E),
  });

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
          style: TextStyle(
            color: valueColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
