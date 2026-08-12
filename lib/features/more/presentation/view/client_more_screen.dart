import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/app_locales.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_context.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../auth/domain/usecases/sign_out.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../widgets/app_lock_dialog.dart';

class ClientMoreScreen extends StatefulWidget {
  const ClientMoreScreen({super.key});

  @override
  State<ClientMoreScreen> createState() => _ClientMoreScreenState();
}

class _ClientMoreScreenState extends State<ClientMoreScreen> {
  bool _isNotificationsEnabled = true;
  bool _isLanguageExpanded = false;

  /// How the app is unlocked. Mock state for now, like the rest of this
  /// screen's switches — nothing is persisted yet.
  AppLockMethod _appLock = AppLockMethod.fingerprint;

  String get _appLockLabel => switch (_appLock) {
    AppLockMethod.none => MoreKeys.appLockOff,
    AppLockMethod.fingerprint => LoginKeys.fingerprint,
    AppLockMethod.face => LoginKeys.faceId,
    AppLockMethod.password => MoreKeys.appLockPassword,
  };

  Future<void> _pickAppLock() async {
    final picked = await AppLockDialog.show(context, selected: _appLock);
    if (picked != null) setState(() => _appLock = picked);
  }

  /// Drops the stored token, then the session, then lands on the login screen.
  /// The navigation is explicit because the router's redirect currently lets
  /// `SessionUnauthenticated` stay put — leaving it to the redirect would keep
  /// the user on this screen with no session behind it.
  Future<void> _signOut() async {
    await getIt<SignOut>()();
    if (!mounted) return;
    context.read<SessionCubit>().signOut();
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          children: [
            InkWell(
              onTap: () => context.push(AppRoutes.clientProfile),
              borderRadius: BorderRadius.circular(16),
              child: _buildProfileCard(),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle(MoreKeys.sectionAccount.tr()),
            const SizedBox(height: 12),
            _buildCard([
              _buildListItem(
                title: MoreKeys.yourStations.tr(),
                iconPath: 'assets/more/station.svg',
                iconColor: AppColors.forestGreen,
                onTap: () {
                  context.push(AppRoutes.clientStations);
                },
              ),
              _buildDivider(),
              _buildListItem(
                title: MoreKeys.creditLimit.tr(),
                iconPath: 'assets/more/payment.svg',
                iconColor: colors.brandOrange,
                onTap: () {
                  context.push(AppRoutes.clientCreditLimit);
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle(MoreKeys.sectionApp.tr()),
            const SizedBox(height: 12),
            _buildCard([
              _buildListItem(
                title: MoreKeys.appLock.tr(),
                iconPath: 'assets/more/icon1.svg',
                iconColor: context.colors.textSecondary,
                trailingText: _appLockLabel.tr(),
                onTap: _pickAppLock,
              ),
              _buildDivider(),
              _buildListItem(
                title: MoreKeys.notifications.tr(),
                iconPath: _isNotificationsEnabled
                    ? 'assets/more/icon4.svg'
                    : 'assets/more/icon3.svg',
                iconColor: context.colors.textSecondary,
                trailingWidget: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isNotificationsEnabled = !_isNotificationsEnabled;
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: SvgPicture.asset(
                      _isNotificationsEnabled
                          ? 'assets/more/Toggole Button.svg'
                          : 'assets/more/Toggole Button Pressed.svg',
                      key: ValueKey<bool>(_isNotificationsEnabled),
                      width: 44,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _isNotificationsEnabled = !_isNotificationsEnabled;
                  });
                },
              ),
              _buildDivider(),
              _buildLanguageItem(),
              _buildDivider(),
              _buildListItem(
                title: context.locale.languageCode == 'ar'
                    ? 'سمة الألوان'
                    : 'Color Theme',
                iconPath: 'assets/more/theme_icon.svg',
                iconColor: context.colors.textSecondary,
                trailingWidget: BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    final isDark = themeMode == ThemeMode.dark;
                    return GestureDetector(
                      onTap: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: SvgPicture.asset(
                          isDark
                              ? 'assets/more/theme_toggle_dark.svg'
                              : 'assets/more/theme_toggle_light.svg',
                          key: ValueKey<bool>(isDark),
                          width: 44,
                        ),
                      ),
                    );
                  },
                ),
                onTap: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
              _buildDivider(),
              _buildListItem(
                title: MoreKeys.supportHelp.tr(),
                iconPath: 'assets/more/customer service.svg',
                iconColor: context.colors.textSecondary,
                // No `extra`, so this lands on the same support page the
                // floating support button opens — the plain back arrow and
                // standalone logo, not the full top bar.
                onTap: () => context.push(AppRoutes.support),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle(MoreKeys.sectionAbout.tr()),
            const SizedBox(height: 12),
            _buildCard([
              _buildListItem(
                title: MoreKeys.terms.tr(),
                iconPath: 'assets/more/icon5.svg',
                iconColor: context.colors.textSecondary,
                onTap: () => context.push(AppRoutes.clientTerms),
              ),
              _buildDivider(),
              _buildListItem(
                title: MoreKeys.aboutUs.tr(),
                iconPath: 'assets/more/info-circle.svg',
                iconColor: context.colors.textSecondary,
                trailingText: 'v1.0.0',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),
            _buildLogoutButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colors.greenTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.brandGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Profile image on the right (start in RTL) with rounded rectangle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/more/Image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Name + details in center
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'محمد أحمد',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  MoreKeys.stationsCount.tr(namedArgs: {'count': '2'}),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.forestGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colors.brandGreen.withOpacity(0.3),
                    ),
                  ),
                  child: const Text(
                    'GS-MA-526',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Arrow on the left (end in RTL)
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.forestGreen,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildAppCard() {
    return MoreCard(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isLanguageExpanded = !_isLanguageExpanded;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/more/icon2.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    context.colors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    MoreKeys.language.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                // The active language, written in its own language.
                Text(
                  CommonKeys.languageName.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _isLanguageExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildLanguageChip(
                    label: CommonKeys.arabic.tr(),
                    locale: AppLocales.arabic,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLanguageChip(
                    label: CommonKeys.english.tr(),
                    locale: AppLocales.english,
                  ),
                ),
              ],
            ),
          ),
          crossFadeState: _isLanguageExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  /// Switching the chip switches the app's locale outright — `setLocale`
  /// persists the choice and rebuilds every `.tr()` above this screen, so no
  /// local selection state is kept here.
  Widget _buildLanguageChip({required String label, required Locale locale}) {
    final colors = context.colors;
    final isSelected = context.locale.languageCode == locale.languageCode;
    return GestureDetector(
      onTap: () => context.setLocale(locale),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.blueTint : colors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colors.brandBlue : colors.borderHairline,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colors.brandBlue : colors.textTertiary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.brandBlue,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? colors.brandBlue : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: context.colors.textSecondary,
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListItem({
    required String title,
    String? iconPath,
    IconData? icon,
    Color? iconColor,
    String? trailingText,
    Widget? trailingWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  iconColor ?? AppColors.forestGreen,
                  BlendMode.srcIn,
                ),
              )
            else if (icon != null)
              Icon(icon, size: 24, color: iconColor ?? AppColors.forestGreen),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: TextStyle(
                  fontSize: 14,
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (trailingWidget != null)
              trailingWidget
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: context.colors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    final colors = context.colors;
    return Divider(
      height: 1,
      thickness: 1,
      color: colors.borderHairline,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: _signOut,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.borderHairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: AppColors.errorRed, size: 20),
            const SizedBox(width: 8),
            Text(
              MoreKeys.signOut.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.errorRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
