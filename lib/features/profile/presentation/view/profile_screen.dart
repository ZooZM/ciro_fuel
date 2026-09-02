// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/error_presenter.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../auth/presentation/cubit/session_state.dart';
import '../../../stations/domain/entities/station.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_identity.dart';

/// The account's own page: photo and name, contact details, the stations tied
/// to the account, and its registration information (spec 005 T100).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionCubit>().state;
    final userId = session is SessionAuthenticated ? session.user.id : null;

    if (userId == null) {
      // Unreachable in practice — this route only exists behind the
      // authenticated shell — but fails loudly rather than silently
      // rendering a broken screen if that ever changes.
      return const Scaffold(body: SizedBox.shrink());
    }

    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>(param1: userId)..load(),
      child: const _ProfileView(),
    );
  }
}

Future<void> _editName(BuildContext context, String currentName) async {
  final cubit = context.read<ProfileCubit>();
  final controller = TextEditingController(text: currentName);
  final newName = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(CommonKeys.editName.tr()),
      content: TextField(controller: controller, autofocus: true),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(CommonKeys.cancel.tr()),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(dialogContext).pop(controller.text.trim()),
          child: Text(CommonKeys.save.tr()),
        ),
      ],
    ),
  );
  if (newName != null && newName.isNotEmpty && newName != currentName) {
    await cubit.updateFullName(newName);
  }
}

Future<void> _pickAndUploadPhoto(BuildContext context) async {
  final cubit = context.read<ProfileCubit>();
  final picked = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: 1024,
    imageQuality: 85,
  );
  if (picked == null) return;
  await cubit.uploadProfilePicture(picked.path);
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          current is ProfileLoaded && current.saveError != null,
      listener: (context, state) {
        final failure = (state as ProfileLoaded).saveError;
        if (failure != null) {
          presentFailure(context, failure);
          context.read<ProfileCubit>().clearSaveError();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colors.canvas,
          body: SafeArea(
            child: switch (state) {
              ProfileLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              ProfileFailureState(:final failure) => _ErrorView(
                failure: failure,
                onRetry: () => context.read<ProfileCubit>().load(),
              ),
              ProfileLoaded() => _ProfileContent(state: state),
            },
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              failureMessage(failure),
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(CommonKeys.retry.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.state});

  final ProfileLoaded state;

  @override
  Widget build(BuildContext context) {
    final user = state.user;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      children: [
        const AppTopBar(),
        const SizedBox(height: 32),
        ProfileIdentity(
          name: user.fullName,
          station: state.stations.isNotEmpty
              ? (state.stations.firstWhere(
                      (s) => s.isDefault,
                      orElse: () => state.stations.first,
                    ).name ??
                    '')
              : '',
          showEditBadge: true,
          avatarBytes: state.avatarBytes,
          onEdit: state.isSaving ? null : () => _pickAndUploadPhoto(context),
          onNameTap: state.isSaving
              ? null
              : () => _editName(context, user.fullName),
        ),
        const SizedBox(height: 32),
        _buildSectionTitle(context, ProfileKeys.contactInfo.tr()),
        const SizedBox(height: 12),
        _buildCard(context, [
          _buildContactItem(
            context,
            text: user.phone,
            icon: Icons.call_outlined,
            // No verified badge: neither the user record nor any endpoint
            // carries a phone-verified flag, so `isVerified: true` here was
            // asserting something the platform has never established. The
            // number set at registration by the fuel company was never
            // confirmed by OTP at all.
            isVerified: false,
          ),
          _buildDivider(context),
          _buildContactItem(
            context,
            text: user.email,
            iconPath: 'assets/more/message.svg',
          ),
        ]),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(context, ProfileKeys.linkedStations.tr()),
            Text(
              ProfileKeys.stationsCount.tr(
                namedArgs: {'count': '${state.stations.length}'},
              ),
              style: TextStyle(
                color: context.colors.brandBlue,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        state.stations.isEmpty
            ? _buildCard(context, [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    ProfileKeys.noStations.tr(),
                    style: TextStyle(color: context.colors.textSecondary),
                  ),
                ),
              ])
            : _buildCard(context, [
                for (var i = 0; i < state.stations.length; i++) ...[
                  if (i > 0) _buildDivider(context),
                  _buildStationItem(context, station: state.stations[i]),
                ],
              ]),
        const SizedBox(height: 24),
        _buildSectionTitle(context, ProfileKeys.accountInfo.tr()),
        const SizedBox(height: 12),
        _buildCard(context, [
          _buildAccountInfoItem(
            context,
            ProfileKeys.joinDate.tr(),
            DateFormat.yMMMMd(context.locale.toString()).format(user.createdAt),
          ),
        ]),
        const SizedBox(height: 24),
        _buildChangeMobileButton(context),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: context.colors.textTertiary,
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required String text,
    IconData? icon,
    String? iconPath,
    bool isVerified = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          if (iconPath != null)
            SvgPicture.asset(iconPath, width: 20, height: 20)
          else if (icon != null)
            Icon(icon, size: 20, color: context.colors.textTertiary),
          const SizedBox(width: 16),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          if (isVerified) ...[
            const SizedBox(width: 16),
            Icon(Icons.check, color: context.colors.brandGreen, size: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildStationItem(BuildContext context, {required Station station}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/more/station.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              context.colors.brandGreen,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              station.name?.isNotEmpty == true
                  ? station.name!
                  : station.addressText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          if (station.isFavourite) ...[
            const SizedBox(width: 16),
            Icon(Icons.star, color: context.colors.brandOrange, size: 18),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountInfoItem(
    BuildContext context,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: context.colors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.colors.borderHairline,
    );
  }

  /// Entry point to the phone-change flow, whose first stop is the code the
  /// new number is sent.
  Widget _buildChangeMobileButton(BuildContext context) {
    return InkWell(
      onTap: () => context.push(AppRoutes.clientChangePhone),
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
            Icon(
              Icons.edit_outlined,
              color: context.colors.brandGreen,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              ProfileKeys.changePhone.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.colors.brandGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
