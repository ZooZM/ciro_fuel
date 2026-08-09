import 'package:flutter/material.dart';

import '../../../../core/widgets/app_top_bar.dart';

const _kNavy = Color(0xFF162155);
const _kGrey = Color(0xFF6B7280);
const _kGreyLight = Color(0xFF9CA3AF);
const _kBlue = Color(0xFF1E5FFF);
const _kCanvas = Color(0xFFF4F6FA);
const _kSurface = Color(0xFFFFFFFF);
const _kBorder = Color(0xFFE7E9EF);
// The clause cards: a pale green field inside a slightly stronger green rule.
const _kClauseFill = Color(0xFFE9F8EF);
const _kClauseBorder = Color(0xFFA8DFC0);
const _kBadgeFill = Color(0xFFF5F8FF);

/// One numbered clause of the terms.
class _Clause {
  const _Clause(this.number, this.title, this.body);

  final String number;
  final String title;
  final String body;
}

/// الشروط والأحكام — a contents list followed by the clauses themselves.
///
/// Static UI: the copy is fixed and the contents rows scroll to nothing yet.
class ClientTermsScreen extends StatefulWidget {
  const ClientTermsScreen({super.key});

  @override
  State<ClientTermsScreen> createState() => _ClientTermsScreenState();
}

class _ClientTermsScreenState extends State<ClientTermsScreen> {
  final ScrollController _controller = ScrollController();

  static const List<_Clause> _clauses = [
    _Clause(
      '01',
      'مقدمة الشروط والأحكام',
      'يرجى قراءة هذه الشروط والأحكام بعناية قبل استخدام المنصة أو الاستمرار '
          'في أي من خدماتها، حيث إن استخدامك للمنصة يُعد موافقة صريحة منك على '
          'الالتزام بجميع البنود الواردة في هذه الصفحة، وكذلك أي تحديثات أو '
          'تعديلات قد تطرأ عليها لاحقًا.',
    ),
    _Clause(
      '02',
      'تحديث الشروط',
      'تحتفظ الجهة المالكة للمنصة بحق تعديل أو تحديث هذه الشروط في أي وقت تراه '
          'مناسبًا، ويُعد استمرارك في استخدام الخدمة بعد نشر التعديلات قبولًا '
          'ضمنيًا بها.',
    ),
    _Clause(
      '03',
      'مسؤولية صحة البيانات',
      'يقر المستخدم بأنه مسؤول مسؤولية كاملة عن صحة ودقة البيانات التي يقوم '
          'بإدخالها أثناء إنشاء الحساب أو أثناء استخدام أي من خدمات المنصة، وأن '
          'أي بيانات غير صحيحة أو مضللة قد تؤدي إلى تعليق الحساب أو رفض الخدمة '
          'أو اتخاذ الإجراءات اللازمة وفقًا لما تراه الجهة المشغلة مناسبًا.',
    ),
    _Clause(
      '04',
      'سرية بيانات الدخول',
      'كما يلتزم المستخدم بالحفاظ على سرية بيانات الدخول الخاصة به، وعدم '
          'مشاركتها مع أي طرف آخر، ويتحمل وحده المسؤولية عن أي استخدام يتم من '
          'خلال حسابه.',
    ),
    _Clause(
      '05',
      'الاستخدام المشروع',
      'ويُمنع استخدام المنصة لأي أغراض غير مشروعة أو مخالفة للأنظمة أو الآداب '
          'العامة أو ما قد يسبب ضررًا مباشرًا أو غير مباشر للمنصة أو '
          'للمستخدمين الآخرين أو لأي طرف ثالث.',
    ),
    _Clause(
      '06',
      'حماية النظام',
      'كما يلتزم المستخدم بعدم محاولة العبث بالنظام أو الوصول غير المصرح به '
          'إلى أي جزء من المنصة أو تعطيل خدماتها أو التأثير على أدائها بأي '
          'وسيلة كانت.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _kCanvas,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _controller,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppTopBar(),
                    const SizedBox(height: 28),
                    const Text(
                      'المحتويات',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _kGreyLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildContentsCard(),
                    const SizedBox(height: 32),
                    for (final clause in _clauses) ...[
                      _ClauseCard(clause: clause),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
              // Sits over the content at the bottom-right, as drawn.
              Positioned(
                right: 16,
                bottom: 16,
                child: _buildScrollTopButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentsCard() {
    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          for (final (index, clause) in _clauses.indexed) ...[
            if (index > 0)
              const Divider(height: 1, thickness: 1, color: _kBorder),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        // The list numbers plainly, unlike the clause badges.
                        '${index + 1}.  ${clause.title}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _kNavy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // chevron_left is a matchTextDirection icon, so it would
                    // mirror and point right on this RTL page.
                    const Directionality(
                      textDirection: TextDirection.ltr,
                      child: Icon(
                        Icons.chevron_left,
                        size: 22,
                        color: _kGreyLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScrollTopButton() {
    return Material(
      color: _kSurface,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: const Color(0x1F000000),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _scrollToTop,
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(Icons.arrow_upward, size: 22, color: _kBlue),
        ),
      ),
    );
  }
}

/// A single clause: its number badge and title, then the text itself.
class _ClauseCard extends StatelessWidget {
  const _ClauseCard({required this.clause});

  final _Clause clause;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kClauseFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kClauseBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Badge first so it sits to the right of the title in RTL.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _kBadgeFill,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _kBlue.withValues(alpha: 0.4)),
                ),
                child: Text(
                  clause.number,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _kBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  clause.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _kNavy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            clause.body,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 13, height: 1.9, color: _kGrey),
          ),
        ],
      ),
    );
  }
}
