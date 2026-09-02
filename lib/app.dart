import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injector.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/presentation/cubit/session_cubit.dart';
import 'features/auth/presentation/view/app_lock_gate.dart';
import 'features/delivery/presentation/cubit/delivery_cubit.dart';
import 'features/delivery/presentation/cubit/driver_summary_cubit.dart';
import 'features/notifications/presentation/cubit/notifications_cubit.dart';
import 'features/notifications/presentation/widgets/notification_banner_presenter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: getIt<SessionCubit>()),
        BlocProvider<NotificationsCubit>.value(
          value: getIt<NotificationsCubit>(),
        ),
        // spec 007: session-lifetime singleton, same reasoning as
        // NotificationsCubit above — reachable from the driver's home,
        // orders list, delivery detail and scan screens alike.
        BlocProvider<DeliveryCubit>.value(value: getIt<DeliveryCubit>()),
        BlocProvider<DriverSummaryCubit>.value(
          value: getIt<DriverSummaryCubit>(),
        ),
        BlocProvider<ThemeCubit>.value(
          value: getIt<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Ciro Fuel',
            debugShowCheckedModeBanner: false,
            // Text direction follows the locale automatically once these three
            // are wired — no screen needs its own `Directionality` for RTL.
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: getIt<AppRouter>().config,
            // AppLockGate wraps everything, including notification chrome
            // (spec 006 FR-016) — a locked driver must not be able to act
            // on a notification before the challenge resolves. It sits in
            // `builder:`, above the Navigator, deliberately — see its own
            // doc comment for why a go_router redirect would not do.
            builder: (context, child) => AppLockGate(
              child: NotificationBannerPresenter(
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          );
        },
      ),
    );
  }
}
