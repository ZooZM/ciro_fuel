import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/date_time_row.dart';

/// One order, as the orders list draws it: the grade and code, a status bar,
/// the address, the date/time row, and the pump artwork down the trailing edge.
///
/// Shared so the support screen's report-an-order picker shows the same card
/// the list does rather than a near-copy of it.
class OrderListCard extends StatelessWidget {
  const OrderListCard({
    required this.fuelLine,
    required this.orderId,
    required this.statusLabel,
    required this.statusColor,
    required this.statusProgress,
    required this.address,
    required this.date,
    required this.time,
    this.onTap,
    super.key,
  });

  /// The consignment line — "Gasoline 91 · 5,000 L".
  ///
  /// Required, with no default: this card used to render a literal
  /// `Gasoline 95 · 20,000 L` for every row, taking no fuel or quantity at
  /// all, so every order in the list was misdescribed.
  final String fuelLine;

  final String orderId;

  /// Already translated — the callers hold their own status vocabulary.
  final String statusLabel;
  final Color statusColor;

  /// 0..1, how far along the status bar fills.
  final double statusProgress;

  final String address;
  final String date;
  final String time;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        // No inset on the trailing edge: the pump artwork runs to it rather
        // than floating short of it, the way the station art does on the
        // delivery card.
        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 0, 12),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.borderHairline),
        ),
        // Keeps the artwork inside the rounded corner now that it reaches it.
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fuelLine,
                        style: TextStyle(
                          color: context.colors.brandBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        orderId,
                        style: TextStyle(
                          color: context.colors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        statusLabel,
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: context.colors.surface2,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                Container(
                                  height: 6,
                                  width: constraints.maxWidth * statusProgress,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    address,
                    style: TextStyle(
                      color: context.colors.brandBlue,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DateTimeRow(date: date, time: time),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // The pump is drawn facing the card's start edge, which is how it
            // reads under Arabic. The row mirrors under English and the
            // artwork does not, so it is flipped there to keep it facing into
            // the card instead of away from it.
            Transform.flip(
              flipX: Directionality.of(context) == TextDirection.ltr,
              child: SvgPicture.asset(
                'assets/OrdersPage/fuel_pump.svg',
                height: 75,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
