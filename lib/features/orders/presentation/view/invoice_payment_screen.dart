import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'order_detail_screen.dart';

class InvoicePaymentScreen extends StatelessWidget {
  const InvoicePaymentScreen({super.key});

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
                  _buildTopBar(context),
                  const SizedBox(height: 24),
                  _buildSadadCard(),
                  const SizedBox(height: 12),
                  const Text(
                    'ادفع من تطبيق البنك عبر خدمة سداد بإدخال رقم المؤسسة ورقم الفاتورة، أو من أقرب صراف آلي.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF8A93A6), fontSize: 10),
                  ),
                  const SizedBox(height: 16),
                  _buildInvoiceDetailsCard(),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.file_download_outlined, color: Color(0xFF1E5FFF)),
                      label: const Text(
                        'تنزيل الإيصال',
                        style: TextStyle(color: Color(0xFF1E5FFF), fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 24,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E5FFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              const OrderDetailScreen(orderId: 'mock', mockState: MockOrderState.paid),
                        ),
                      );
                    },
                    child: const Text(
                      'تأكيد و إتمام الطلب',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
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

  Widget _buildTopBar(BuildContext context) {
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
                boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 2))],
              ),
              child: const Icon(Icons.notifications_none, color: Color(0xFF0F1B2E)),
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
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        SvgPicture.asset('assets/HomePage/appBar Logo.svg', height: 20),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 2))],
            ),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF0F1B2E)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSadadCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF97316)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'بيانات الفاتورة',
                    style: TextStyle(color: Color(0xFF0F1B2E), fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text('# 889241035', style: TextStyle(color: Color(0xFF8A93A6), fontSize: 12)),
                ],
              ),
              SvgPicture.asset('assets/Order/Sadaad.svg', height: 32),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'رقم الفاتورة',
                    style: TextStyle(color: Color(0xFF8A93A6), fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '40521',
                          style: TextStyle(
                            color: Color(0xFF0F1B2E),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/Icons/copy.svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(Color(0xFF17A34A), BlendMode.srcIn),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'رقم المؤسسة',
                    style: TextStyle(color: Color(0xFF8A93A6), fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        '889241035',
                        style: TextStyle(color: Color(0xFF0F1B2E), fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/Icons/copy.svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(Color(0xFF17A34A), BlendMode.srcIn),
                      ),
                    ],
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
                'صالحة حتى',
                style: TextStyle(color: Color(0xFF8A93A6), fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const Text(
                'اليوم 06:30 صباحاً',
                style: TextStyle(color: Color(0xFF17A34A), fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildBreakdownRow('بنزين 95 • 20,000 لتر', '450,000.00 ر.س', isMain: true),
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
                  colorFilter: const ColorFilter.mode(Color(0xFF1E5FFF), BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'فاتورة مؤجلة',
                    style: TextStyle(color: Color(0xFFF97316), fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  const Text(
                    'يجب دفع الفاتورة المؤجلة لاستكمال العملية الحالية',
                    style: TextStyle(color: Color(0xFF17A34A), fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBreakdownRow('بنزين 95 • 20,000 لتر', '450,000.00 ر.س'),
          const SizedBox(height: 8),
          _buildBreakdownRow('رسوم التوصيل', '30.00 ر.س'),
          const SizedBox(height: 8),
          _buildBreakdownRow('رسوم خدمة', '30.00 ر.س'),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0xFFE6E9F0))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Text(
                      'إخفاء التفاصيل',
                      style: TextStyle(color: Color(0xFF17A34A), fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.visibility_off_outlined, color: Color(0xFF17A34A), size: 14),
                  ],
                ),
              ),
              const Expanded(child: Divider(color: Color(0xFFE6E9F0))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الإجمالي',
                style: TextStyle(color: Color(0xFF0F1B2E), fontSize: 16, fontWeight: FontWeight.w800),
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '600,120.00 ',
                      style: TextStyle(color: Color(0xFF17A34A), fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    TextSpan(
                      text: 'ر.س',
                      style: TextStyle(color: Color(0xFF17A34A), fontSize: 14),
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

  Widget _buildBreakdownRow(String title, String value, {bool isMain = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF8A93A6),
            fontSize: isMain ? 11 : 10,
            fontWeight: isMain ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF0F1B2E),
            fontSize: isMain ? 13 : 12,
            fontWeight: isMain ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
