import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seagull/src/presentation/screens/booking/booking_screen.dart';
import 'package:seagull/src/presentation/screens/login/login_screen.dart';
import 'package:seagull/src/presentation/screens/register/register_screen.dart';
import 'package:seagull/src/presentation/screens/splash/splash_screen.dart';
import 'package:seagull/src/presentation/screens/welcome/welcome_screen.dart';

import '../../presentation/screens/booking_confirmation/booking_confirmation.dart';
import '../../presentation/screens/service_details/service_details.dart';
import '../../presentation/screens/your_cart/your_cart.dart';
import 'my_app_route_constant.dart';

class AppRouter {
  static final GoRouter goRouter = GoRouter(
    initialLocation: Routes.splash,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splash,
        builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (BuildContext context, GoRouterState state) => const BookingConfirmationPage(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (BuildContext context, GoRouterState state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.booking,
        builder: (BuildContext context, GoRouterState state) => const BookingScreen(),
      ),
    ],
  );
}
