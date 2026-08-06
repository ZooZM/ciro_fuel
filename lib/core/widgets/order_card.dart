import 'package:flutter/material.dart';

/// The white card every step of the order flow sits in.
///
/// The order form set the house style — 16pt padding, a 16pt radius, and 14pt
/// between a heading and its content — so the detail and tracking screens draw
/// from the same definition rather than repeating the decoration each time.
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.trailing,
    this.titleGap = titleGapDefault,
    this.dashed = false,
    this.border,
  });

  final Widget child;

  /// Heading in the card's leading corner. Omit for cards the design leaves
  /// untitled.
  final String? title;

  /// Muted line under [title] — the order reference, on the status cards.
  final String? subtitle;

  /// Sits opposite [title] — a status pill, in practice.
  final Widget? trailing;

  /// Space below the heading. A few cards in the design run tighter than
  /// [titleGapDefault] because the line under the heading is a subtitle rather
  /// than the start of the content.
  final double titleGap;

  /// Draws the dashed outline the design gives cards that are awaiting an
  /// action from the customer.
  final bool dashed;

  /// Hairline around the card, for the few that carry one.
  final Color? border;

  static const double padding = 16;
  static const double radius = 16;
  static const double titleGapDefault = 14;

  static const _titleStyle = TextStyle(color: Color(0xFF0F1B2E), fontSize: 15, fontWeight: FontWeight.w700);
  static const _subtitleStyle = TextStyle(color: Color(0xFF8A93A6), fontSize: 12);

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: border == null ? null : Border.all(color: border!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title!, style: _titleStyle),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(subtitle!, style: _subtitleStyle),
                      ],
                    ],
                  ),
                ),
                // Centres against the whole heading block, not just its first
                // line, so the pill sits level with a title+reference pair.
                if (trailing != null) trailing!,
              ],
            ),
            SizedBox(height: titleGap),
          ],
          child,
        ],
      ),
    );

    if (!dashed) return card;
    return CustomPaint(painter: const DashedCardBorderPainter(), child: card);
  }
}

/// The dashed blue outline traced around an [OrderCard] at [OrderCard.radius].
class DashedCardBorderPainter extends CustomPainter {
  const DashedCardBorderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E5FFF)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(OrderCard.radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 6), paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedCardBorderPainter oldDelegate) => false;
}
