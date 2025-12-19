import 'package:businesstrack/screens/BottomNavigaiton.dart';
import 'package:businesstrack/screens/bottom_navigation/dashboard_screen.dart';
import 'package:businesstrack/screens/bottom_navigation/inventory_screen.dart';
import 'package:businesstrack/screens/login_screen.dart';
import 'package:businesstrack/screens/splash_loading_screen.dart';
import 'package:businesstrack/screens/startSplashScreen.dart';
import 'package:businesstrack/theme/themefont.dart';
import 'package:businesstrack/widgets/material_item.dart';
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
          home: const SplashLoadingScreen(),
        );
      },
    );
  }
}
