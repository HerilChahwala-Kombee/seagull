import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seagull/routes/app_router.dart';
import 'package:seagull/i10/app_localizations.dart';

void main() {
  // TODO: Setup dependency injection here
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clean Architecture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.initialRoute,
      supportedLocales: const [
        Locale('en', ''), // English
        // TODO: Add other supported locales here
      ],
      localizationsDelegates: const [
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // home: const Placeholder(), // Removed as routing is now handled by onGenerateRoute
    );
  }
} 