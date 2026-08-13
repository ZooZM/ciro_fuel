// `hide TextDirection`: easy_localization re-exports intl, whose
// TextDirection would shadow the one this screen lays out with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../widgets/support_brand_header.dart';
import '../widgets/support_call_button.dart';
import '../widgets/support_channels_row.dart';
import '../widgets/support_topics_card.dart';
import '../widgets/support_order_problem_card.dart';

/// الدعم و المساعدة — how to reach a human, and the answers most people are
/// looking for.
///
/// Reachable from two places, which is what [showTopBar] distinguishes.
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key, this.showTopBar = false});

  /// Reached from inside the app rather than from the login screen, so the
  /// full header — back, logo and the notification bell — belongs here.
  /// Signed out there is no notifications screen to reach, so the plain back
  /// arrow and the standalone logo stay.
  final bool showTopBar;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        appBar: showTopBar ? null : _buildSignedOutAppBar(context),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenGutter,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                // The bar carries its own logo, so the standalone lockup
                // below it would be a second copy.
                if (showTopBar)
                  const AppTopBar()
                else
                  const SupportBrandHeader(),
                SizedBox(
                  height: showTopBar ? AppSpacing.xxl : AppSpacing.space48,
                ),
                _SectionTitle(SupportKeys.contactNow.tr()),
                const SizedBox(height: AppSpacing.lg),
                SupportCallButton(onTap: () {}),
                const SizedBox(height: AppSpacing.xl),
                const SupportChannelsRow(),
                const SizedBox(height: AppSpacing.space48),
                const SupportOrderProblemCard(),
                const SizedBox(height: AppSpacing.space48),
                _SectionTitle(SupportKeys.topTopics.tr()),
                const SizedBox(height: AppSpacing.lg),
                SupportTopicsCard(onTopicTap: (_) {}),
                const SizedBox(height: AppSpacing.space48),
                Center(
                  child: Text(
                    SupportKeys.availability.tr(),
                    style: TextStyle(
                      fontSize: AppFontSizes.footnote,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Signed out there is no notification bell to show, so the header is a
  /// plain back arrow over the transparent canvas.
  PreferredSizeWidget _buildSignedOutAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: context.colors.textPrimary),
        onPressed: () => context.pop(),
      ),
    );
  }
}

/// One of the screen's two headings.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: AppFontSizes.title,
        fontWeight: FontWeight.w700,
        color: AppColors.of(context).textPrimary,
      ),
    );
  }
}
