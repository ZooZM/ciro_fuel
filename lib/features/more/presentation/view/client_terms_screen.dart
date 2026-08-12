// `hide TextDirection`: easy_localization re-exports intl, whose
// TextDirection would shadow the one this screen lays out with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../constants/terms_clauses.dart';
import '../widgets/terms/scroll_to_top_button.dart';
import '../widgets/terms/terms_clause_card.dart';
import '../widgets/terms/terms_contents_card.dart';

/// الشروط والأحكام — a contents list followed by the clauses themselves.
///
/// Static content: the copy is fixed and the contents rows are inert, so the
/// only thing the screen tracks is the scroll position.
class ClientTermsScreen extends StatefulWidget {
  const ClientTermsScreen({super.key});

  @override
  State<ClientTermsScreen> createState() => _ClientTermsScreenState();
}

class _ClientTermsScreenState extends State<ClientTermsScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _controller.animateTo(
      0,
      duration: AppSizes.termsScrollToTopDuration,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilt on every build rather than held in state: the copy is resolved
    // against the current locale, which can change under the screen.
    final clauses = buildTermsClauses();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _controller,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppTopBar(),
                    const SizedBox(height: AppSpacing.space28),
                    Text(
                      TermsKeys.contents.tr(),
                      style: const TextStyle(
                        fontSize: AppFontSizes.title,
                        fontWeight: FontWeight.bold,
                        color: AppColors.disabledInk,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TermsContentsCard(clauses: clauses),
                    const SizedBox(height: AppSpacing.xxl),
                    for (final clause in clauses) ...[
                      TermsClauseCard(clause: clause),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ],
                ),
              ),
              // Sits over the content at the bottom-right, as drawn.
              Positioned(
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: ScrollToTopButton(onTap: _scrollToTop),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
