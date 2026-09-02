// `hide TextDirection`: easy_localization re-exports intl, whose
// TextDirection would shadow the one this screen lays out with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/error_presenter.dart';
import '../../domain/entities/support_request.dart';
import '../cubit/support_cubit.dart';
import '../cubit/support_state.dart';
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
                // spec 005 T120/T121: real submission + history need a
                // session — signed out (no top bar) there is none, so
                // neither is attempted; the phone/messaging channels above
                // stay the responsive path there (FR-039b).
                if (showTopBar) ...[
                  BlocProvider<SupportCubit>(
                    create: (_) => getIt<SupportCubit>()..loadRequests(),
                    child: const Column(
                      children: [
                        SupportOrderProblemCard(),
                        SizedBox(height: AppSpacing.space48),
                        _SupportRequestsSection(),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space48),
                ],
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

/// spec 005 T121 — whether a submitted request has been received, and
/// whether a fuel company admin has since acknowledged it (FR-039). Two
/// states only, no reply thread (FR-039a) — a badge, not a conversation.
class _SupportRequestsSection extends StatelessWidget {
  const _SupportRequestsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportCubit, SupportState>(
      builder: (context, state) {
        return switch (state) {
          SupportLoading() => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          ),
          SupportFailureState(:final failure) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionTitle(SupportKeys.myRequests.tr()),
              const SizedBox(height: AppSpacing.lg),
              Text(
                failureMessage(failure),
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ],
          ),
          SupportLoaded(:final requests) when requests.isEmpty => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionTitle(SupportKeys.myRequests.tr()),
              const SizedBox(height: AppSpacing.lg),
              Text(
                SupportKeys.noRequestsYet.tr(),
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ],
          ),
          SupportLoaded(:final requests) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionTitle(SupportKeys.myRequests.tr()),
              const SizedBox(height: AppSpacing.lg),
              for (final r in requests) ...[
                _SupportRequestRow(request: r),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
        };
      },
    );
  }
}

class _SupportRequestRow extends StatelessWidget {
  const _SupportRequestRow({required this.request});

  final SupportRequest request;

  @override
  Widget build(BuildContext context) {
    final acknowledged = request.isAcknowledged;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.shadowCard,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              request.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: acknowledged ? context.colors.greenTint : context.colors.blueTint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              (acknowledged
                      ? SupportKeys.stateAcknowledged
                      : SupportKeys.stateSubmitted)
                  .tr(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: acknowledged ? context.colors.brandGreen : context.colors.brandBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
