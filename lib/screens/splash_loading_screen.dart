import 'package:businesstrack/screens/startSplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashLoadingScreen extends StatefulWidget {
  const SplashLoadingScreen({super.key});

  @override
  State<SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen> {
  @override
  void initState() {
    super.initState();

    // 3-second delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Startsplashscreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    /// Auto-scale sizes
    final logoWidth = isTablet ? size.width * 0.45 : size.width * 0.65;
    final animationWidth = isTablet ? size.width * 0.30 : size.width * 0.45;

    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0), // Silver
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // LOGO (big + centered)
              Image.asset(
                "assets/images/logo.png",
                width: logoWidth,
                fit: BoxFit.contain,
              ),

              SizedBox(height: isTablet ? 40 : 25),

              // LOTTIE ANIMATION
              SizedBox(
                width: animationWidth,
                child: Lottie.asset(
                  "assets/animations/loading.json",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
