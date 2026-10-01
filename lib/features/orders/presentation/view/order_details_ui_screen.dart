import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Provide the SVGs as strings from the prompt
const String _cardIconSvg = '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M20 14H4L10 20M4 10H20L14 4" stroke="#E7EEFF" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>''';
const String _bookmarkIconSvg = '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M7 14H12M20.9058 10H3.09424M20.9058 10C20.7376 8.24663 20.3688 6.91254 20 6.66667C19.5 6.33333 16 6 12 6C8 6 4.5 6.33333 4 6.66667C3.63118 6.91254 3.26238 8.24663 3.09424 10M20.9058 10C20.9656 10.6237 21 11.3004 21 12C21 14.6667 20.5 17 20 17.3333C19.5 17.6667 16 18 12 18C8 18 4.5 17.6667 4 17.3333C3.5 17 3 14.6667 3 12C3 11.3004 3.03443 10.6237 3.09424 10" stroke="#1E5FFF" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>''';
const String _creditIconSvg = '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.83333 11.6667H10M17.4215 8.33333H2.57853M17.4215 8.33333C17.2814 6.87219 16.974 5.76045 16.6667 5.55556C16.25 5.27778 13.3333 5 10 5C6.66667 5 3.75 5.27778 3.33333 5.55556C3.02599 5.76045 2.71865 6.87219 2.57853 8.33333M17.4215 8.33333C17.4713 8.85304 17.5 9.41696 17.5 10C17.5 12.2222 17.0833 14.1667 16.6667 14.4444C16.25 14.7222 13.3333 15 10 15C6.66667 15 3.75 14.7222 3.33333 14.4444C2.91667 14.1667 2.5 12.2222 2.5 10C2.5 9.41696 2.52869 8.85304 2.57853 8.33333" stroke="#FF5810" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>''';

class OrderDetailsScreenUI extends StatelessWidget {
  final bool isPendingInvoice;

  const OrderDetailsScreenUI({super.key, this.isPendingInvoice = false});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {},
          ),
          title: const Text(
            'CIRO FUEL',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const CustomStepper(currentStep: 1),
            const SizedBox(height: 24),
            const OrderSummaryCard(),
            const SizedBox(height: 16),
            OrderStatusCard(isPendingInvoice: isPendingInvoice),
            const SizedBox(height: 16),
            const CreditLimitCard(),
          ],
        ),
      ),
    );
  }
}

class CustomStepper extends StatelessWidget {
  final int currentStep;

  const CustomStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['تأكيد الطلب', 'الدفع', 'التوصيل', 'التسليم'];
    
    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;
        
        Color dotColor = const Color(0xFFE5E7EB);
        if (isCompleted) dotColor = const Color(0xFF10B981);
        if (isActive) dotColor = const Color(0xFF3B82F6);
        
        return Expanded(
          child: Column(
            children: [
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 12,
                  color: (isActive || isCompleted) ? Colors.black87 : Colors.black54,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      color: index == 0 ? Colors.transparent : (isCompleted || isActive ? const Color(0xFF10B981) : const Color(0xFFE5E7EB)),
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 4,
                      color: index == steps.length - 1 ? Colors.transparent : (isCompleted ? const Color(0xFF10B981) : const Color(0xFFE5E7EB)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: Color(0xFF1E3A8A)),
              const SizedBox(width: 8),
              const Text('ملخص الطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryColumn('نوع الوقود', 'بنزين 98'),
              _buildSummaryColumn('الكمية', '20,000 لتر'),
              _buildSummaryColumn('سعر اللتر', '2.33 ريال'),
              _buildSummaryColumn('الإجمالي\n(شامل الضريبة)', '46,600.00 ريال', color: Colors.blue),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFE5E7EB)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryColumn('رسوم النقل', '1,200.00 ريال'),
              const Text('+', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              _buildSummaryColumn('ضريبة القيمة المضافة\n(15%)', '6,060.00 ريال'),
              const Text('=', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              _buildSummaryColumn('الإجمالي النهائي', '46,600.00 ريال', color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryColumn(String title, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color ?? Colors.black87)),
      ],
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  final bool isPendingInvoice;

  const OrderStatusCard({super.key, required this.isPendingInvoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('حالة الطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('ORD-2024-256 · 9 صفر 1448', style: TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPendingInvoice ? Colors.blue.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isPendingInvoice ? 'فاتورة معلقة' : 'تم التأكيد',
                  style: TextStyle(
                    color: isPendingInvoice ? Colors.blue : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.payment, size: 18),
                  label: Text(isPendingInvoice ? 'إكمال الدفع' : 'إدفع'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue.shade600,
                    side: BorderSide(color: Colors.blue.shade200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('إلغاء'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_border, size: 18),
              label: const Text('إدفع المرة القادمة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.credit_card, size: 18),
              label: const Text('أطلب حد إئتماني', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class CreditLimitCard extends StatelessWidget {
  const CreditLimitCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
                    child: SvgPicture.string(_creditIconSvg, width: 24, height: 24),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الحد الإئتماني', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('صالح حتى 9 صفر 1446', style: TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('نشط', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المتاح للدفع الآن', style: TextStyle(color: Colors.black54)),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(text: '120,000.00', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                    TextSpan(text: ' ر.س', style: TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('من 200,000.00 ر.س', style: TextStyle(color: Colors.black54, fontSize: 12)),
              Text('مستخدم 200,000.00 ر.س (37.5%)', style: TextStyle(color: Colors.black54, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.375, // (200000-120000)/200000 = 80000/200000 = 0.4
              backgroundColor: Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF97316)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green.shade600,
                side: BorderSide(color: Colors.green.shade200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.green.shade50,
              ),
              child: const Text('هذا الطلب ضمن حدك الإئتماني'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF97316),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('أدفع من الحد الإئتماني'),
            ),
          ),
        ],
      ),
    );
  }
}
