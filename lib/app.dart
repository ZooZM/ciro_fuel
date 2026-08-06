import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injector.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/session_cubit.dart';
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
      ],
      child: MaterialApp.router(
        title: 'Ciro Fuel',
        debugShowCheckedModeBanner: false,
        // Text direction follows the locale automatically once these three
        // are wired — no screen needs its own `Directionality` for RTL.
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: getIt<AppRouter>().config,
        builder: (context, child) => NotificationBannerPresenter(
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
