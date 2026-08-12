// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/scroll_top_button.dart';
import '../../../../core/theme/theme_context.dart';

// The clause cards: a pale green field inside a slightly stronger green rule.

/// One numbered clause of the terms. Holds translation keys rather than copy
/// so the clause list can stay `const`; both are resolved where they're drawn.
class _Clause {
  const _Clause(this.number, this.titleKey, this.bodyKey);

  final String number;
  final String titleKey;
  final String bodyKey;
}

/// الشروط والأحكام — a contents list followed by the clauses themselves.
///
/// The copy is fixed; the contents rows scroll to the clause they name.
class ClientTermsScreen extends StatefulWidget {
  const ClientTermsScreen({super.key});

  @override
  State<ClientTermsScreen> createState() => _ClientTermsScreenState();
}

class _ClientTermsScreenState extends State<ClientTermsScreen> {
  final ScrollController _controller = ScrollController();

  static const List<_Clause> _clauses = [
    _Clause('01', TermsKeys.introTitle, TermsKeys.introBody),
    _Clause('02', TermsKeys.updatesTitle, TermsKeys.updatesBody),
    _Clause('03', TermsKeys.dataAccuracyTitle, TermsKeys.dataAccuracyBody),
    _Clause('04', TermsKeys.credentialsTitle, TermsKeys.credentialsBody),
    _Clause('05', TermsKeys.lawfulUseTitle, TermsKeys.lawfulUseBody),
    _Clause(
      '06',
      TermsKeys.systemProtectionTitle,
      TermsKeys.systemProtectionBody,
    ),
  ];

  /// One per clause card, so a contents row can find the card it names.
  late final List<GlobalKey> _clauseKeys = [
    for (final _ in _clauses) GlobalKey(),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Brings a clause into view from its contents row.
  ///
  /// `ensureVisible` rather than an offset computed from the cards' heights:
  /// they are as tall as their copy, which changes with the locale and the
  /// text scale, so no arithmetic here would survive either.
  void _scrollToClause(int index) {
    final target = _clauseKeys[index].currentContext;
    if (target == null) return;

    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      // Lands the card just below the top edge rather than flush against it.
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
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
                  Text(
                    TermsKeys.contents.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildContentsCard(),
                  const SizedBox(height: 32),
                  for (final (index, clause) in _clauses.indexed) ...[
                    _ClauseCard(key: _clauseKeys[index], clause: clause),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
            // Sits over the content at the bottom-right, as drawn.
            Positioned(
              right: ScrollTopButton.inset,
              bottom: ScrollTopButton.inset,
              child: ScrollTopButton(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentsCard() {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
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
              Divider(
                height: 1,
                thickness: 1,
                color: context.colors.borderHairline,
              ),
            InkWell(
              onTap: () => _scrollToClause(index),
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
                        '${index + 1}.  ${clause.titleKey.tr()}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // chevron_right is a matchTextDirection icon, so it points right in LTR and flips to point left in RTL.
                    Icon(
                      Icons.chevron_right,
                      size: 22,
                      color: context.colors.textTertiary,
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
}

/// A single clause: its number badge and title, then the text itself.
class _ClauseCard extends StatelessWidget {
  const _ClauseCard({required this.clause, super.key});

  final _Clause clause;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.greenTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.brandGreen),
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
                  color: context.colors.blueTint,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: context.colors.brandBlue.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  clause.number,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: context.colors.brandBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  clause.titleKey.tr(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            clause.bodyKey.tr(),
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 13,
              height: 1.9,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
