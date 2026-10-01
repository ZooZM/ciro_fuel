import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String _unseenIconSvg = '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.76404 5.29519C10.4664 5.10724 11.2123 5 12 5C15.7574 5 18.564 7.4404 20.2326 9.43934C21.4848 10.9394 21.4846 13.0609 20.2324 14.5609C20.0406 14.7907 19.8337 15.0264 19.612 15.2635M12.5 9.04148C13.7563 9.25224 14.7478 10.2437 14.9585 11.5M3 3L21 21M11.5 14.9585C10.4158 14.7766 9.52884 14.0132 9.17072 13M4.34914 8.77822C4.14213 9.00124 3.94821 9.22274 3.76762 9.43907C2.51542 10.9391 2.51523 13.0606 3.76739 14.5607C5.43604 16.5596 8.24263 19 12 19C12.8021 19 13.5608 18.8888 14.2744 18.6944" stroke="#1E5FFF" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

// State Management
enum PaymentMethodType { bankTransfer, sadad }

class PaymentMethodCubit extends Cubit<PaymentMethodType?> {
  PaymentMethodCubit() : super(null);

  void selectMethod(PaymentMethodType method) => emit(method);
}

class PaymentMethodScreenUI extends StatelessWidget {
  const PaymentMethodScreenUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentMethodCubit(),
      child: const _PaymentMethodView(),
    );
  }
}

class _PaymentMethodView extends StatelessWidget {
  const _PaymentMethodView();

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
            const _TotalAmountCard(),
            const SizedBox(height: 24),
            const Text(
              'اختر طريقة الدفع',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 16),
            BlocBuilder<PaymentMethodCubit, PaymentMethodType?>(
              builder: (context, selectedMethod) {
                return Row(
                  children: [
                    Expanded(
                      child: _PaymentOptionCard(
                        title: 'سداد',
                        subtitle: 'كود الفاتورة للدفع',
                        iconPath: 'assets/paymentPage/bluePayment.svg',
                        isSadad: true,
                        isSelected: selectedMethod == PaymentMethodType.sadad,
                        onTap: () => context.read<PaymentMethodCubit>().selectMethod(PaymentMethodType.sadad),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _PaymentOptionCard(
                        title: 'تحويل بنكي',
                        subtitle: 'إرفاق الإيصال',
                        iconPath: 'assets/paymentPage/blueExchange.svg',
                        selectedIconPath: 'assets/paymentPage/whiteExchange.svg',
                        isSelected: selectedMethod == PaymentMethodType.bankTransfer,
                        onTap: () => context.read<PaymentMethodCubit>().selectMethod(PaymentMethodType.bankTransfer),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            BlocBuilder<PaymentMethodCubit, PaymentMethodType?>(
              builder: (context, selectedMethod) {
                if (selectedMethod == PaymentMethodType.sadad) {
                  return const _SadadDetailsSection();
                } else if (selectedMethod == PaymentMethodType.bankTransfer) {
                  return const _BankTransferSection();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalAmountCard extends StatefulWidget {
  const _TotalAmountCard();

  @override
  State<_TotalAmountCard> createState() => _TotalAmountCardState();
}

class _TotalAmountCardState extends State<_TotalAmountCard> {
  bool isExpanded = false;

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
          if (isExpanded) _buildExpandedDetails(),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              children: [
                const Expanded(
                  child: Divider(color: Color(0xFFE5E7EB), endIndent: 16),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isExpanded ? 'إخفاء' : 'إظهار',
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    if (isExpanded)
                      SvgPicture.string(
                        _unseenIconSvg.replaceAll('#1E5FFF', '#4CAF50'),
                        width: 16,
                        height: 16,
                      )
                    else
                      SvgPicture.asset(
                        'assets/paymentPage/seen.svg',
                        width: 16,
                        height: 16,
                      ),
                    const SizedBox(width: 4),
                    const Text('التفاصيل', style: TextStyle(color: Colors.green, fontSize: 12)),
                  ],
                ),
                const Expanded(
                  child: Divider(color: Color(0xFFE5E7EB), indent: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(text: '600,120.00', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
                    TextSpan(text: ' ر.س', style: TextStyle(color: Colors.green, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('بنزين 95 - 20,000 لتر', '450,000.00 ر.س'),
        const SizedBox(height: 8),
        _buildDetailRow('رسوم التوصيل', '30.00 ر.س'),
        const SizedBox(height: 8),
        _buildDetailRow('رسوم خدمة', '30.00 ر.س'),
        
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.link, color: Colors.blue, size: 16),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('فاتورة مؤجلة', style: TextStyle(color: Color(0xFFF97316), fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 2),
                Text('يجب دفع الفاتورة المؤجلة لاستكمال العملية الحالية', style: TextStyle(color: Colors.green, fontSize: 10)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildDetailRow('بنزين 95 - 20,000 لتر', '450,000.00 ر.س'),
        const SizedBox(height: 8),
        _buildDetailRow('رسوم التوصيل', '30.00 ر.س'),
        const SizedBox(height: 8),
        _buildDetailRow('رسوم خدمة', '30.00 ر.س'),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        Text(value, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final String? selectedIconPath;
  final bool isSadad;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.selectedIconPath,
    this.isSadad = false,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? null : const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 16, color: Colors.white),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        (isSelected && selectedIconPath != null) ? selectedIconPath! : iconPath,
                        width: 32,
                        height: 32,
                        colorFilter: (isSelected && isSadad) || (isSelected && selectedIconPath == null) 
                            ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) 
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isSadad)
                      Image.asset(
                        'assets/paymentPage/Sadaad.png',
                        height: 24,
                      )
                    else
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B)),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SadadDetailsSection extends StatelessWidget {
  const _SadadDetailsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF97316)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/paymentPage/Sadaad.png', height: 24),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('بيانات الفاتورة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('889241035 #', style: TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCopyField('رقم المؤسسة', '889241035'),
                  _buildCopyField('رقم الفاتورة', '40521'),
                ],
              ),
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('صالحة حتى', style: TextStyle(color: Colors.black54, fontSize: 12)),
                  Text('اليوم 06:30 صباحاً', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'ادفع عن طريق البنك عبر خدمة سداد بإدخال رقم المؤسسة ورقم الفاتورة، أو من أقرب صراف آلي.',
          style: TextStyle(color: Colors.black54, fontSize: 10),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('تأكيد و إتمام الطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 8),
            SvgPicture.asset('assets/paymentPage/copy.svg', width: 16, height: 16),
          ],
        ),
      ],
    );
  }
}

class _BankTransferSection extends StatelessWidget {
  const _BankTransferSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          painter: _DashedRectPainter(color: Colors.blue.shade200, strokeWidth: 2, gap: 5),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SvgPicture.asset('assets/paymentPage/Images.svg', width: 48, height: 48),
                const SizedBox(height: 16),
                const Text('أضغط هنا للرفع', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                const Text('JPG, JPEG, PNG, PDF', style: TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('إرسال الإيصال للمراجعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedRectPainter({required this.color, required this.strokeWidth, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(16),
    );
    
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

