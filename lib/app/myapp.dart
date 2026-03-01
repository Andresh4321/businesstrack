import 'package:businesstrack/app/theme/themefont.dart';
import 'package:businesstrack/features/splash/presentation/pages/splash_loading_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.light,
  );

  // Global navigator key for sensor wrappers
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final theme = Themefont();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: MyApp.themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          navigatorKey: MyApp.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          themeMode: mode,
          home: SplashLoadingScreen(),
        );
      },
    );
  }
}
