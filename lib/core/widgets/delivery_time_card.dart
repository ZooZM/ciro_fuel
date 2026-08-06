import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'order_card.dart';

/// The موعد التسليم panel: when and where the load is due, against the station
/// artwork that bleeds off the card's leading edge.
///
/// Every stage of the order shows it, so it lives here rather than in any one
/// screen.
class DeliveryTimeCard extends StatelessWidget {
  const DeliveryTimeCard({
    super.key,
    this.date = '9 صفر 1446',
    this.time = '06.30 صباحاً',
    this.station = 'طريق أنس بن مالك، حي الملقا',
  });

  final String date;
  final String time;

  /// Address only — the word محطة is part of the layout.
  final String station;

  static const _art = 'assets/Order/station_icon.svg';
  static const _navy = Color(0xFF0F1B2E);
  static const _grey = Color(0xFF8A93A6);
  static const _green = Color(0xFF17A34A);
  static const _border = Color(0xFFE6E9F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(OrderCard.radius),
        border: Border.all(color: _border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Overhangs the card so the forecourt runs to the edges.
          Positioned(left: -4, top: 14, bottom: 10, child: SvgPicture.asset(_art, fit: BoxFit.fitHeight)),
          Padding(
            padding: const EdgeInsets.all(OrderCard.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'موعد التسليم',
                    style: TextStyle(color: _navy, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 24),
                _Line(icon: Icons.calendar_today_outlined, text: date),
                const SizedBox(height: 12),
                _Line(icon: Icons.access_time, text: time),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(color: _navy, fontSize: 14),
                    children: [
                      const TextSpan(
                        text: 'محطة ',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: station,
                        style: const TextStyle(color: _grey),
                      ),
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
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: DeliveryTimeCard._green),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: DeliveryTimeCard._navy, fontSize: 13)),
      ],
    );
  }
}
