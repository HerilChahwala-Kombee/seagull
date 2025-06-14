import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seagull/i10/app_localizations.dart';
import 'package:seagull/src/core/routers/routes.dart';

Future<void> MainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await injectDependencies();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Seagull',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      textTheme: GoogleFonts.poppinsTextTheme(),
    ),

    routerConfig: AppRouter.goRouter,
    locale: const Locale('en'),
    // localizationsDelegates: AppLocalizations.localizationsDelegates,
    // supportedLocales: L10n.all,
  );
}
