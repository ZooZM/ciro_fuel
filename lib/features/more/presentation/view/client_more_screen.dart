import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class ClientMoreScreen extends StatefulWidget {
  const ClientMoreScreen({super.key});

  @override
  State<ClientMoreScreen> createState() => _ClientMoreScreenState();
}

class _ClientMoreScreenState extends State<ClientMoreScreen> {
  bool _isNotificationsEnabled = true;
  bool _isLanguageExpanded = false;
  String _selectedLanguage = 'ar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light.canvas,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            children: [
              InkWell(
                onTap: () => context.push(AppRoutes.clientProfile),
                borderRadius: BorderRadius.circular(16),
                child: _buildProfileCard(),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('الحساب'),
              const SizedBox(height: 12),
              _buildCard([
                _buildListItem(
                  title: 'محطاتك',
                  iconPath: 'assets/more/station.svg',
                  onTap: () {
                    context.push(AppRoutes.clientStations);
                  },
                ),
                _buildDivider(),
                _buildListItem(
                  title: 'الفواتير و الدفع',
                  iconPath: 'assets/more/invoice.svg',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildListItem(
                  title: 'الحد الإئتماني',
                  iconPath: 'assets/more/payment.svg',
                  onTap: () {
                    context.push(AppRoutes.clientCreditLimit);
                  },
                ),
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle('التطبيق'),
              const SizedBox(height: 12),
              _buildCard([
                _buildListItem(
                  title: 'قفل التطبيق',
                  icon: Icons.lock_outline,
                  trailingText: 'بصمة إصبع',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildListItem(
                  title: 'الإشعارات',
                  icon: Icons.notifications_none,
                  trailingWidget: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isNotificationsEnabled = !_isNotificationsEnabled;
                      });
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
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
                  title: 'الدعم و المساعدة',
                  iconPath: 'assets/more/customer service.svg',
                  onTap: () => context.push(AppRoutes.support, extra: true),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle('عن التطبيق'),
              const SizedBox(height: 12),
              _buildCard([
                _buildListItem(
                  title: 'الشروط و الأحكام',
                  iconPath: 'assets/more/order.svg',
                  onTap: () => context.push(AppRoutes.clientTerms),
                ),
                _buildDivider(),
                _buildListItem(
                  title: 'من نحن',
                  icon: Icons.info_outline,
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
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.light.greenTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.light.brandGreen.withOpacity(0.3)),
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
                const Text(
                  'محمد أحمد',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slateCharcoal,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'عدد المحطات :  2',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.forestGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.light.brandGreen.withOpacity(0.3)),
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

  Widget _buildLanguageItem() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isLanguageExpanded = !_isLanguageExpanded;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/more/language.svg',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'اللغة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slateCharcoal,
                    ),
                  ),
                ),
                Text(
                  'عربي',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.warmGray,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _isLanguageExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColors.warmGray,
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
                    label: 'اللغة العربية',
                    value: 'ar',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLanguageChip(
                    label: 'English',
                    value: 'en',
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

  Widget _buildLanguageChip({required String label, required String value}) {
    final isSelected = _selectedLanguage == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.light.blueTint : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.light.brandBlue : AppColors.light.borderHairline,
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
                  color: isSelected ? AppColors.light.brandBlue : AppColors.light.textTertiary,
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
                          color: AppColors.light.brandBlue,
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
                color: isSelected ? AppColors.light.brandBlue : AppColors.light.textSecondary,
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
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.warmGray,
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.light.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListItem({
    required String title,
    String? iconPath,
    IconData? icon,
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
              )
            else if (icon != null)
              Icon(
                icon,
                size: 24,
                color: AppColors.light.textSecondary,
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slateCharcoal,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.warmGray,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (trailingWidget != null)
              trailingWidget
            else
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.warmGray,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.light.borderHairline,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.light.borderHairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: AppColors.errorRed,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'تسجيل الخروج',
              style: TextStyle(
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
