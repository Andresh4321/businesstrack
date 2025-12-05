import 'package:businesstrack/screens/splash_loading_screen.dart';
import 'package:businesstrack/screens/startSplashScreen.dart';
import 'package:flutter/material.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashLoadingScreen());
  }
}
