import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:businesstrack/features/auth/presentation/pages/login_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  final List<_OnboardingItem> _pages = [
    _OnboardingItem(
      title: 'BusinessTrack',
      subtitle: 'Manage inventory, production & analytics — all in one place',
      lottiePath: 'assets/animations/Factory.json',
      bgGradient: const LinearGradient(
        colors: [Color(0xFF6C63FF), Color.fromARGB(255, 17, 15, 57)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      buttonColor: Colors.white,
      buttonTextColor: Color(0xFF4F46E5),
    ),
    _OnboardingItem(
      title: 'BusinessTrack',
      subtitle:
          'Manage your factory inventory, production batches, and analytics automatically.',
      lottiePath: 'assets/animations/processing.json',
      bgGradient: const LinearGradient(
        colors: [Color(0xFFF7F8FA), Color(0xFFF7F8FA)],
      ),
      buttonColor: Color(0xFF4F46E5),
      buttonTextColor: Colors.white,
    ),
    _OnboardingItem(
      title: 'BusinessTrack',
      subtitle: 'Generate professional reports from your Business easily.',
      lottiePath: 'assets/animations/report.json',
      bgGradient: const LinearGradient(
        colors: [Color(0xFFF8F9FA), Color(0xFFF8F9FA)],
      ),
      buttonColor: Color(0xFF4F46E5),
      buttonTextColor: Colors.white,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animationController.forward();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _skipOnboarding() => _navigateToLogin();

  void _navigateToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          final page = _pages[index];
          return Container(
            decoration: BoxDecoration(
              gradient: page.bgGradient,
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Optional: Semi-transparent Lottie for first page
                  if (index == 0)
                    Positioned(
                      right: -50,
                      bottom: -50,
                      child: Opacity(
                        opacity: 0.3,
                        child: Lottie.asset(
                          page.lottiePath,
                          width: 450,
                          height: 450,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _animationController,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              page.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: index == 0 ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              page.subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: index == 0 ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Lottie.asset(
                              page.lottiePath,
                              width: 300,
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Skip Button
                  Positioned(
                    top: 20,
                    right: 20,
                    child: TextButton(
                      onPressed: _skipOnboarding,
                      style: TextButton.styleFrom(
                        backgroundColor: index == 0 ? Colors.white30 : Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: index == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Next/Get Started Button
                  Positioned(
                    bottom: 40,
                    left: 24,
                    right: 24,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: page.buttonColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: page.buttonTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Helper class for page data
class _OnboardingItem {
  final String title;
  final String subtitle;
  final String lottiePath;
  final LinearGradient bgGradient;
  final Color buttonColor;
  final Color buttonTextColor;

  const _OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.lottiePath,
    required this.bgGradient,
    required this.buttonColor,
    required this.buttonTextColor,
  });
}
