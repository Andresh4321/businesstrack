import 'package:businesstrack/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:businesstrack/app/theme/themefont.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.light,
  );

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MyApp.themeNotifier,
      builder: (_, ThemeMode mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Themefont().lightTheme,
          darkTheme: Themefont().darkTheme,
          themeMode: mode,
          home: const OnboardingPage(),
        );
      },
    );
  }
}
