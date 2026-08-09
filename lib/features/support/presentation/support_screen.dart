import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_top_bar.dart';

const _kLogo = 'assets/Logo/Logo.svg';
const _kPhoneIcon = 'assets/icons/phone.svg';

const _kFacebook = 'assets/Social Media/facebook.svg';
const _kTelegram = 'assets/Social Media/telegram.svg';
const _kWhatsapp = 'assets/Social Media/whatsapp.svg';

const _kGas = 'assets/Help Screen/gas.svg';
const _kTruck = 'assets/Help Screen/truck.svg';
const _kContract = 'assets/Help Screen/contract.svg';
const _kProfile = 'assets/Help Screen/profile.svg';

const _kBlue = Color(0xFF1E5FFF);
const _kGreen = Color(0xFF17A34A);
const _kNavy = Color(0xFF0F1B2E);
const _kGrey = Color(0xFF8A93A6);
const _kBackground = Color(0xFFF5F6F8);
const _kItemBorder = Color(0xFFE6E9F0);

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key, this.showTopBar = false});

  /// Reached from inside the app rather than from the login screen, so the
  /// full header — back, logo and the notification bell — belongs here. Signed
  /// out there is no notifications screen to reach, so the plain back arrow and
  /// the standalone logo stay.
  final bool showTopBar;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _kBackground,
        appBar: showTopBar
            ? null
            : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
                      SvgPicture.asset(_kLogo, height: 24),
                      const SizedBox(width: 8),
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(
                          'FUEL',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _kGreen,
                            letterSpacing: 1.2,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: showTopBar ? 32 : 48),
                const Text(
                  'تواصل معنا فوراً',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _kNavy,
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
                      color: const Color(0xFFEDF2FA), // Light blue background
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text(
                          'اتصال مباشر',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _kBlue,
                          ),
                        ),
                        Positioned(
                          right: 16,
                          child: SvgPicture.asset(
                            _kPhoneIcon,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              _kBlue,
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
                    const Text(
                      'او من خلال',
                      style: TextStyle(
                        fontSize: 14,
                        color: _kGreen,
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
                const SizedBox(height: 48),
                const Text(
                  'أكثر المواضيع بحثاً',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _kNavy,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kItemBorder),
                  ),
                  child: Column(
                    children: [
                      _TopicItem(title: 'طلبيات الوقود', icon: _kGas),
                      const Divider(height: 1, color: _kItemBorder),
                      _TopicItem(title: 'تأخير التوصيل', icon: _kTruck),
                      const Divider(height: 1, color: _kItemBorder),
                      _TopicItem(title: 'طرق الدفع', icon: _kContract),
                      const Divider(height: 1, color: _kItemBorder),
                      _TopicItem(
                        title: 'الحساب و تسجيل الدخول',
                        icon: _kProfile,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                const Center(
                  child: Text(
                    'فريق الدعم متاح يوميًا من 8 ص إلى 12 م',
                    style: TextStyle(fontSize: 12, color: _kGrey),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicItem extends StatelessWidget {
  const _TopicItem({required this.title, required this.icon});

  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(icon, width: 20, height: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _kNavy,
                ),
              ),
            ),
            const Icon(Icons.add, color: _kGrey, size: 20),
          ],
        ),
      ),
    );
  }
}
