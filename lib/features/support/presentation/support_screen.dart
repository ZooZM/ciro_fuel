// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/widgets/app_logo.dart';
import '../../orders/presentation/widgets/order_list_card.dart';


const _kFacebook = 'assets/Social Media/facebook.svg';
const _kTelegram = 'assets/Social Media/telegram.svg';
const _kWhatsapp = 'assets/Social Media/whatsapp.svg';

const _kGas = 'assets/Help Screen/gas.svg';
const _kTruck = 'assets/Help Screen/truck.svg';
const _kContract = 'assets/Help Screen/contract.svg';
const _kProfile = 'assets/Help Screen/profile.svg';


class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key, this.showTopBar = false});

  /// Reached from inside the app rather than from the login screen, so the
  /// full header — back, logo and the notification bell — belongs here. Signed
  /// out there is no notifications screen to reach, so the plain back arrow and
  /// the standalone logo stay.
  final bool showTopBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      appBar: showTopBar
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => context.pop(),
              ),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // The bar carries its own logo, so the standalone one below it
              // would be a second copy.
              if (showTopBar)
                const AppTopBar()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: TextDirection.ltr,
                  children: [
                    const AppLogoMark(height: 24),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        'FUEL',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: context.colors.brandGreen,
                          letterSpacing: 1.2,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: showTopBar ? 32 : 48),
              Text(
                SupportKeys.contactNow.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: context.colors.blueTint, // Light blue background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        SupportKeys.directCall.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.colors.brandBlue,
                        ),
                      ),
                      Positioned(
                        right: 16,
                        child: SvgPicture.asset(
                          AppAssets.phoneIcon,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            context.colors.brandBlue,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    SupportKeys.orVia.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: context.colors.brandGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SvgPicture.asset(_kWhatsapp, width: 24, height: 24),
                  const SizedBox(width: 16),
                  SvgPicture.asset(_kTelegram, width: 24, height: 24),
                  const SizedBox(width: 16),
                  SvgPicture.asset(_kFacebook, width: 24, height: 24),
                ],
              ),
              const SizedBox(height: 32),
              const _OrderIssueCard(),
              const SizedBox(height: 48),
              Text(
                SupportKeys.topTopics.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.colors.borderHairline),
                ),
                child: Column(
                  children: [
                    _TopicItem(
                      title: SupportKeys.topicFuelOrders.tr(),
                      icon: _kGas,
                    ),
                    Divider(height: 1, color: context.colors.borderHairline),
                    _TopicItem(
                      title: SupportKeys.topicDeliveryDelay.tr(),
                      icon: _kTruck,
                    ),
                    Divider(height: 1, color: context.colors.borderHairline),
                    _TopicItem(
                      title: SupportKeys.topicPaymentMethods.tr(),
                      icon: _kContract,
                    ),
                    Divider(height: 1, color: context.colors.borderHairline),
                    _TopicItem(
                      title: SupportKeys.topicAccountLogin.tr(),
                      icon: _kProfile,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: Text(
                  SupportKeys.availability.tr(),
                  style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// "عندك مشكلة في طلب ؟" — the green header between the contact block and the
/// topic list, and the report-an-order panel it folds open.
class _OrderIssueCard extends StatefulWidget {
  const _OrderIssueCard();

  @override
  State<_OrderIssueCard> createState() => _OrderIssueCardState();
}

class _OrderIssueCardState extends State<_OrderIssueCard> {
  bool _isExpanded = false;
  final TextEditingController _problem = TextEditingController();

  @override
  void dispose() {
    _problem.dispose();
    super.dispose();
  }

  /// The orders offered for reporting. Static mock data, like the rest of this
  /// screen — the real list comes from the orders feature once it is wired.
  List<_IssueOrder> _orders(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return [
      // The bar is either full or halfway, never an in-between figure — the
      // same rule the orders list follows.
      _IssueOrder(
        statusKey: OrdersListKeys.statusInDelivery,
        statusColor: context.colors.brandBlue,
        statusProgress: 0.5,
        address: isAr
            ? 'طريق أنس بن مالك، حي الملقا'
            : 'Anas Bin Malik Road, Al Malqa District',
        date: isAr ? '9 صفر 1446' : '9 Safar 1446',
        time: isAr ? '06.30 صباحاً' : '06.30 AM',
      ),
      _IssueOrder(
        statusKey: OrdersListKeys.statusPaymentDeferred,
        statusColor: context.colors.brandOrange,
        statusProgress: 1.0,
        address: isAr ? 'رفح, الخليج الرياض' : 'Rafha, Al Khaleej Riyadh',
        date: isAr ? '9 صفر 1446' : '9 Safar 1446',
        time: isAr ? '06.30 صباحاً' : '06.30 AM',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        // Folded away rather than kept off-screen: the panel is the whole
        // reporting flow, so it only earns its space once asked for.
        if (_isExpanded) _buildPanel(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.greenTint,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.brandGreen),
        ),
        // Artwork first and the chevron last, so the pair mirrors with the
        // locale — nozzle on the right and chevron on the left under Arabic,
        // as the design has it.
        child: Row(
          children: [
            // Two-colour artwork (green body, orange drips), so no colorFilter.
            SvgPicture.asset(AppAssets.supportGasGunIcon, width: 32, height: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SupportKeys.orderIssueTitle.tr(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    SupportKeys.orderIssueBody.tr(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 24,
                color: colors.brandGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      decoration: BoxDecoration(
        color: colors.blueTint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final order in _orders(context))
            OrderListCard(
              orderId: 'ORD-2024-256',
              statusLabel: order.statusKey.tr(),
              statusColor: order.statusColor,
              statusProgress: order.statusProgress,
              address: order.address,
              date: order.date,
              time: order.time,
              // Picking an order is what the report is filed against; the
              // filing itself is not built yet.
              onTap: () {},
            ),
          const SizedBox(height: 4),
          Text(
            SupportKeys.orderIssueNotListed.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            SupportKeys.orderIssueSendCode.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 12, color: colors.brandBlue),
          ),
          const SizedBox(height: 16),
          // Field first, so the send button lands on the far side of it in
          // either locale — left under Arabic, as the design has it.
          Row(
            children: [
              Expanded(
                child: Container(
                  height: AppSizes.supportProblemFieldHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _problem,
                    minLines: 1,
                    maxLines: 3,
                    style: TextStyle(fontSize: 13, color: colors.textPrimary),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: SupportKeys.orderIssueHint.tr(),
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                // Nothing to send to yet, as with the topic rows below.
                onTap: () {},
                child: Container(
                  width: AppSizes.supportProblemFieldHeight,
                  height: AppSizes.supportProblemFieldHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.brandBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // The glyph ships in the pale blue the design draws on the
                  // button, and the button is blue in both themes, so it is
                  // left as it is rather than recoloured.
                  child: SvgPicture.asset(
                    AppAssets.supportSendIcon,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One row in the report-an-order picker.
class _IssueOrder {
  const _IssueOrder({
    required this.statusKey,
    required this.statusColor,
    required this.statusProgress,
    required this.address,
    required this.date,
    required this.time,
  });

  final String statusKey;
  final Color statusColor;
  final double statusProgress;
  final String address;
  final String date;
  final String time;
}

/// One topic in the FAQ list: a header that toggles, and the question/answer
/// pairs it folds open.
class _TopicItem extends StatefulWidget {
  const _TopicItem({required this.title, required this.icon});

  final String title;
  final String icon;

  @override
  State<_TopicItem> createState() => _TopicItemState();
}

class _TopicItemState extends State<_TopicItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                SvgPicture.asset(widget.icon, width: 20, height: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                // The design swaps the glyph outright rather than rotating it:
                // '+' closed, '−' open.
                Icon(
                  _isExpanded ? Icons.remove : Icons.add,
                  color: _isExpanded ? colors.brandBlue : colors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            width: double.infinity,
            color: colors.blueTint,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            // The same placeholder pair twice, as the design shows it, with the
            // dashed rule between them.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _FaqEntry(),
                const SizedBox(height: 12),
                _DashedRule(color: colors.brandGreen),
                const SizedBox(height: 12),
                const _FaqEntry(),
              ],
            ),
          ),
      ],
    );
  }
}

/// A question with its answer underneath, as the topics list draws them.
class _FaqEntry extends StatelessWidget {
  const _FaqEntry();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SupportKeys.faqQuestion.tr(),
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colors.brandBlue,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          SupportKeys.faqAnswer.tr(),
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 11,
            height: 1.5,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// The dashed rule between two FAQ entries. Drawn rather than assembled from
/// boxes so the dash run adapts to whatever width it is given.
class _DashedRule extends StatelessWidget {
  const _DashedRule({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: CustomPaint(painter: _DashedRulePainter(color)),
    );
  }
}

class _DashedRulePainter extends CustomPainter {
  const _DashedRulePainter(this.color);

  /// Handed in from the widget above — a painter has no [BuildContext].
  final Color color;

  static const double _dash = 6;
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    for (var x = 0.0; x < size.width; x += _dash + _gap) {
      final end = (x + _dash).clamp(0.0, size.width);
      canvas.drawLine(Offset(x, 0), Offset(end, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_DashedRulePainter oldDelegate) =>
      oldDelegate.color != color;
}
