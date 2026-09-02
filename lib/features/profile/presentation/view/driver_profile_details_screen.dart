import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/error_presenter.dart';
import '../../../../core/widgets/order_card.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../auth/presentation/cubit/session_state.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_identity.dart';

/// The driver's own profile (spec 006 FR-001/002/003/005/006/007) — every
/// value here used to be hard-coded (`5X XXX XXXX`,
/// `mohamed.ahmed@example.com`, a fabricated rating and account code, a
/// CLIENT-shaped mock "station" this role doesn't have). Now sourced from
/// `ProfileCubit`, the same one `ProfileScreen` (the client's own version
/// of this screen) already uses — `GET /users/:id` is role-agnostic and
/// this feature only added `companyName` to what it returns.
class DriverProfileDetailsScreen extends StatelessWidget {
  const DriverProfileDetailsScreen({super.key});

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
      child: const _DriverProfileView(),
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

class _DriverProfileView extends StatelessWidget {
  const _DriverProfileView();

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
              // FR-007: a retryable failure, never a fall back to
              // placeholder identity values.
              ProfileFailureState(:final failure) => _ErrorView(
                failure: failure,
                onRetry: () => context.read<ProfileCubit>().load(),
              ),
              ProfileLoaded() => _DriverProfileContent(state: state),
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

class _DriverProfileContent extends StatelessWidget {
  const _DriverProfileContent({required this.state});

  final ProfileLoaded state;

  @override
  Widget build(BuildContext context) {
    final user = state.user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          ProfileIdentity(
            name: user.fullName,
            // A driver belongs to a transport company, not a client
            // station — this line now carries the real company name
            // FR-002 asks for, rather than the CLIENT-shaped mock
            // ("station_alhamd") this screen used to show regardless of
            // role.
            station: user.companyName ?? '',
            showEditBadge: true,
            avatarBytes: state.avatarBytes,
            onEdit: state.isSaving ? null : () => _pickAndUploadPhoto(context),
            onNameTap: state.isSaving
                ? null
                : () => _editName(context, user.fullName),
          ),
          const SizedBox(height: AppSpacing.xl),

          _sectionTitle(context, ProfileKeys.contactInfo.tr()),
          const SizedBox(height: AppSpacing.sm),
          OrderCard(
            child: Column(
              children: [
                _detailRow(context, value: user.phone, icon: Icons.phone_outlined),
                const Divider(height: 16),
                _detailRow(context, value: user.email, icon: Icons.email_outlined),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          _sectionTitle(context, DriverProfileKeys.company.tr()),
          const SizedBox(height: AppSpacing.sm),
          OrderCard(
            child: _detailRow(
              context,
              value: user.companyName ?? '',
              icon: Icons.apartment_outlined,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          _sectionTitle(context, ProfileKeys.accountInfo.tr()),
          const SizedBox(height: AppSpacing.sm),
          OrderCard(
            child: _detailRow(
              context,
              label: ProfileKeys.joinDate.tr(),
              value: DateFormat.yMMMMd(
                context.locale.toString(),
              ).format(user.createdAt),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          _buildChangePhoneButton(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildChangePhoneButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.driverChangePhone),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: context.colors.brandGreen.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.colors.borderHairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ProfileKeys.changePhone.tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.colors.brandGreen,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.edit_outlined, color: context.colors.brandGreen, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: context.colors.textSecondary,
        ),
      ),
    );
  }

  // spec 006 T087 (RTL sweep): `label == null` is what `_truckSection` uses
  // for `companyName` — a real registered company's name is long enough to
  // overflow an unbounded `Text` inside a bare `Row` (a `Row` never wraps
  // its children; a `Column` does). Both branches now bound the value in
  // an `Expanded`/`Flexible` so a long value wraps or ellipsizes instead.
  Widget _detailRow(
    BuildContext context, {
    String? label,
    required String value,
    IconData? icon,
  }) {
    if (label == null) {
      return Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: context.colors.textSecondary, size: 20),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: context.colors.brandBlue,
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: context.colors.textSecondary, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
          ),
        ),
      ],
    );
  }
}
