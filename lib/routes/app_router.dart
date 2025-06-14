import 'package:flutter/material.dart';

class AppRouter {
  static const String initialRoute = '/';
  // TODO: Add your routes here

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
      // TODO: Return your initial page, e.g., return MaterialPageRoute(builder: (_) => const HomePage());
        return MaterialPageRoute(builder: (_) => const Text('Home Page'));
      default:
        return MaterialPageRoute(builder: (_) => const Text('Error: Unknown route'));
    }
  }
} 