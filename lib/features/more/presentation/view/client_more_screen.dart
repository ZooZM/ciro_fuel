// `hide TextDirection`: easy_localization re-exports intl, whose
// TextDirection would shadow the one this screen lays out with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/localization/app_locales.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/domain/usecases/sign_out.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../constants/client_more_mock_data.dart';
import '../widgets/more/logout_confirmation_dialog.dart';
import '../widgets/more/more_card.dart';
import '../widgets/more/more_divider.dart';
import '../widgets/more/more_language_item.dart';
import '../widgets/more/more_list_item.dart';
import '../widgets/more/more_logout_button.dart';
import '../widgets/more/more_notification_toggle.dart';
import '../widgets/more/more_profile_card.dart';
import '../widgets/more/more_section_title.dart';

/// المزيد — the client's settings list: their profile, the account and app
/// preferences, and the way out of the session.
class ClientMoreScreen extends StatefulWidget {
  const ClientMoreScreen({super.key});

  @override
  State<ClientMoreScreen> createState() => _ClientMoreScreenState();
}

class _ClientMoreScreenState extends State<ClientMoreScreen> {
  bool _isNotificationsEnabled = true;
  bool _isLanguageExpanded = false;
  Locale _selectedLanguage = AppLocales.arabic;
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            children: [
              MoreProfileCard(
                name: ClientMoreMockData.clientName,
                stationCountLabel: MoreKeys.stationCount.tr(
                  namedArgs: {'count': ClientMoreMockData.stationCount},
                ),
                code: ClientMoreMockData.clientCode,
                onTap: () => context.push(AppRoutes.clientProfile),
              ),
              const SizedBox(height: AppSpacing.xxl),
              MoreSectionTitle(MoreKeys.sectionAccount.tr()),
              const SizedBox(height: AppSpacing.md),
              _buildAccountCard(),
              const SizedBox(height: AppSpacing.xl),
              MoreSectionTitle(MoreKeys.sectionApp.tr()),
              const SizedBox(height: AppSpacing.md),
              _buildAppCard(),
              const SizedBox(height: AppSpacing.xl),
              MoreSectionTitle(MoreKeys.sectionAbout.tr()),
              const SizedBox(height: AppSpacing.md),
              _buildAboutCard(),
              const SizedBox(height: AppSpacing.xl),
              MoreLogoutButton(
                isLoggingOut: _isLoggingOut,
                onTap: _confirmAndLogout,
              ),
              // Clears the floating bottom nav bar this tab sits behind.
              const SizedBox(height: AppSpacing.moreListNavBarClearance),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return MoreCard(
      children: [
        MoreListItem(
          title: MoreKeys.stations.tr(),
          iconPath: AppAssets.moreStationIcon,
          onTap: () => context.push(AppRoutes.clientStations),
        ),
        const MoreDivider(),
        MoreListItem(
          title: MoreKeys.invoicesAndPayments.tr(),
          iconPath: AppAssets.moreInvoiceIcon,
          onTap: () {},
        ),
        const MoreDivider(),
        MoreListItem(
          title: MoreKeys.creditLimit.tr(),
          iconPath: AppAssets.morePaymentIcon,
          onTap: () => context.push(AppRoutes.clientCreditLimit),
        ),
      ],
    );
  }

  Widget _buildAppCard() {
    return MoreCard(
      children: [
        MoreListItem(
          title: MoreKeys.appLock.tr(),
          icon: Icons.lock_outline,
          trailingText: MoreKeys.appLockValue.tr(),
          onTap: () {},
        ),
        const MoreDivider(),
        MoreListItem(
          title: MoreKeys.notifications.tr(),
          icon: Icons.notifications_none,
          trailingWidget: MoreNotificationToggle(
            value: _isNotificationsEnabled,
            onChanged: _setNotificationsEnabled,
          ),
          // The whole row is a target for the switch, not just the switch.
          onTap: () => _setNotificationsEnabled(!_isNotificationsEnabled),
        ),
        const MoreDivider(),
        MoreLanguageItem(
          isExpanded: _isLanguageExpanded,
          selectedLanguage: _selectedLanguage,
          onToggleExpanded: () =>
              setState(() => _isLanguageExpanded = !_isLanguageExpanded),
          onLanguageSelected: (locale) =>
              setState(() => _selectedLanguage = locale),
        ),
        const MoreDivider(),
        MoreListItem(
          title: MoreKeys.support.tr(),
          iconPath: AppAssets.moreSupportIcon,
          // `extra: true` asks the support screen for its in-app header
          // (back, logo, notification bell) rather than the signed-out one.
          onTap: () => context.push(AppRoutes.support, extra: true),
        ),
      ],
    );
  }

  Widget _buildAboutCard() {
    return MoreCard(
      children: [
        MoreListItem(
          title: MoreKeys.terms.tr(),
          iconPath: AppAssets.moreTermsIcon,
          onTap: () => context.push(AppRoutes.clientTerms),
        ),
        const MoreDivider(),
        MoreListItem(
          title: MoreKeys.about.tr(),
          icon: Icons.info_outline,
          trailingText: MoreKeys.appVersion.tr(),
          onTap: () {},
        ),
      ],
    );
  }

  void _setNotificationsEnabled(bool value) {
    setState(() => _isNotificationsEnabled = value);
  }

  /// Confirms, then ends the session — clearing the persisted tokens first.
  Future<void> _confirmAndLogout() async {
    final confirmed = await showLogoutConfirmationDialog(context);

    // `showDialog` also resolves to null on a barrier tap / back gesture.
    if (confirmed != true || !mounted) return;

    setState(() => _isLoggingOut = true);
    try {
      // Ordered deliberately: clear the persisted tokens FIRST, then drop the
      // session. `signOut()` flips SessionCubit to unauthenticated, which the
      // router reacts to immediately (redirecting to /login and disposing this
      // screen) — so doing it first would leave a window where the app looks
      // signed out while the Keychain/Keystore still holds a usable refresh
      // token.
      await getIt<SignOut>()();
    } catch (_) {
      // Swallowed on purpose. Secure-storage deletion can fail (a locked
      // Keychain, for instance) and there is nothing useful to say about it:
      // the user asked to sign out, the session ends either way (below), and
      // the next launch's `RestoreSession` re-validates whatever is left
      // against `/auth/me` — so a stale token the backend has since rejected
      // cannot resurrect the session. Rethrowing would only surface an
      // unhandled async error from a fire-and-forget tap handler.
    } finally {
      // In a `finally` so the guarantee is structural: however the attempt
      // above ended, the session ends. Being signed out with a stale token
      // on disk is strictly safer than being trapped in an authenticated UI.
      //
      // No `reason` — that copy is reserved for an involuntary expiry
      // surfaced by AuthInterceptor; this sign-out was deliberate.
      //
      // Not guarded by `mounted`: SessionCubit is an app-lifetime singleton
      // resolved from getIt, not this widget's own state, and the sign-out
      // must land even if the screen went away mid-await.
      getIt<SessionCubit>().signOut();
    }
  }
}
