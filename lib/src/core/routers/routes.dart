import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seagull/src/presentation/screens/booking/booking_screen.dart';
import 'package:seagull/src/presentation/screens/otp/otp_screen.dart';
import 'package:seagull/src/presentation/screens/register/register_screen.dart';
import 'package:seagull/src/presentation/screens/splash/splash_screen.dart';
import 'package:seagull/src/presentation/screens/welcome/welcome_screen.dart';

import 'my_app_route_constant.dart';

class AppRouter {
  static final GoRouter goRouter = GoRouter(
    initialLocation: Routes.splash,
    routes: <RouteBase>[
      GoRoute(path: Routes.splash, builder: (BuildContext context, GoRouterState state) => const SplashScreen()),
      GoRoute(path: Routes.welcome, builder: (BuildContext context, GoRouterState state) => const WelcomeScreen()),
      GoRoute(path: Routes.login, builder: (BuildContext context, GoRouterState state) => const OTPScreen()),
      GoRoute(path: Routes.register, builder: (BuildContext context, GoRouterState state) => const SignInScreen()),
      GoRoute(path: Routes.booking, builder: (BuildContext context, GoRouterState state) => const BookingScreen()),
    ],
  );
}
