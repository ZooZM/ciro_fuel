import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/features/auth/domain/usecases/complete_password_reset.dart';
import 'package:mobile_app/features/auth/domain/usecases/request_password_reset.dart';
import 'package:mobile_app/features/auth/domain/usecases/verify_reset_code.dart';
import 'package:mobile_app/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/auth/presentation/view/forgot_password_screen.dart';
import 'package:mobile_app/features/auth/presentation/view/reset_password_screen.dart';
import 'package:mobile_app/features/profile/domain/entities/profile_user.dart';
import 'package:mobile_app/features/profile/domain/usecases/download_avatar.dart';
import 'package:mobile_app/features/profile/domain/usecases/get_profile.dart';
import 'package:mobile_app/features/profile/domain/usecases/update_full_name.dart';
import 'package:mobile_app/features/profile/domain/usecases/upload_profile_picture.dart';
import 'package:mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mobile_app/features/profile/presentation/view/driver_profile_details_screen.dart';
import 'package:mobile_app/features/stations/domain/entities/station.dart';
import 'package:mobile_app/features/stations/domain/usecases/get_stations.dart';
import 'package:mobile_app/shared/entities/auth_user.dart';
import 'package:mobile_app/shared/enums/user_role.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/localized_harness.dart';

class _MockRequestPasswordReset extends Mock implements RequestPasswordReset {}

class _MockVerifyResetCode extends Mock implements VerifyResetCode {}

class _MockCompletePasswordReset extends Mock implements CompletePasswordReset {}

class _MockGetProfile extends Mock implements GetProfile {}

class _MockGetStations extends Mock implements GetStations {}

class _MockUpdateFullName extends Mock implements UpdateFullName {}

class _MockUploadProfilePicture extends Mock implements UploadProfilePicture {}

class _MockDownloadAvatar extends Mock implements DownloadAvatar {}

const _driver = AuthUser(
  id: 'driver-1',
  role: UserRole.driver,
  companyId: 'company-1',
  fullName: 'سائق تجريبي طويل الاسم لاختبار التفاف النص',
);

/// spec 006 T087 — every screen this feature added, pumped under the
/// default Arabic locale `pumpLocalized` already uses, asserting no
/// exception (Flutter surfaces a `RenderFlex` overflow as one) escapes.
/// `LockScreen` is deliberately not repeated here: `app_lock_gate_test.dart`
/// already pumps it under the same default Arabic locale for its own
/// gating assertions, so it already exercises exactly this.
void main() {
  tearDown(getIt.reset);

  testWidgets(
    'ForgotPasswordScreen renders under Arabic without overflowing',
    (tester) async {
      getIt.registerFactory<PasswordResetCubit>(
        () => PasswordResetCubit(
          requestReset: _MockRequestPasswordReset(),
          verifyCode: _MockVerifyResetCode(),
          completeReset: _MockCompletePasswordReset(),
        ),
      );

      await pumpLocalized(tester, const ForgotPasswordScreen());

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'ResetPasswordScreen renders under Arabic without overflowing',
    (tester) async {
      getIt.registerFactory<PasswordResetCubit>(
        () => PasswordResetCubit(
          requestReset: _MockRequestPasswordReset(),
          verifyCode: _MockVerifyResetCode(),
          completeReset: _MockCompletePasswordReset(),
        ),
      );

      await pumpLocalized(
        tester,
        const ResetPasswordScreen(resetToken: 'token'),
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'DriverProfileDetailsScreen renders under Arabic without overflowing '
    '(long name and a long company name)',
    (tester) async {
      final getProfile = _MockGetProfile();
      final getStations = _MockGetStations();
      when(() => getProfile.call(any())).thenAnswer(
        (_) async => Right(
          ProfileUser(
            id: 'driver-1',
            fullName: 'سائق تجريبي طويل الاسم لاختبار التفاف النص',
            email: 'driver@example.com',
            phone: '+966501234567',
            isActive: true,
            createdAt: DateTime(2026, 1, 1),
            companyName: 'شركة النقل السريع المحدودة للخدمات اللوجستية',
          ),
        ),
      );
      when(getStations.call).thenAnswer((_) async => const Right(<Station>[]));

      getIt.registerFactoryParam<ProfileCubit, String, void>(
        (userId, _) => ProfileCubit(
          userId: userId,
          getProfile: getProfile,
          getStations: getStations,
          updateFullName: _MockUpdateFullName(),
          uploadProfilePicture: _MockUploadProfilePicture(),
          downloadAvatar: _MockDownloadAvatar(),
        ),
      );

      await pumpLocalized(
        tester,
        BlocProvider<SessionCubit>.value(
          value: SessionCubit()..authenticate(_driver),
          child: const DriverProfileDetailsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );
}
