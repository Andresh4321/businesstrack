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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
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
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isTablet = constraints.maxWidth >= 700;
          final double maxContentWidth = isTablet ? 620 : 460;

          return PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              final Color titleColor = index == 0 ? Colors.white : Colors.black;
              final Color subtitleColor = index == 0
                  ? Colors.white70
                  : Colors.black54;

              return Container(
                decoration: BoxDecoration(gradient: page.bgGradient),
                child: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Stack(
                        children: [
                          if (index == 0)
                            Positioned(
                              right: isTablet ? -20 : -50,
                              bottom: isTablet ? -20 : -50,
                              child: Opacity(
                                opacity: 0.25,
                                child: IgnorePointer(
                                  child: Lottie.asset(
                                    page.lottiePath,
                                    width: isTablet ? 420 : 320,
                                    height: isTablet ? 420 : 320,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              isTablet ? 32 : 20,
                              72,
                              isTablet ? 32 : 20,
                              132,
                            ),
                            child: FadeTransition(
                              opacity: _animationController,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    page.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isTablet ? 40 : 32,
                                      fontWeight: FontWeight.bold,
                                      color: titleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    page.subtitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isTablet ? 20 : 17,
                                      height: 1.35,
                                      color: subtitleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  Expanded(
                                    child: Center(
                                      child: AspectRatio(
                                        aspectRatio: isTablet ? 1.25 : 1,
                                        child: Lottie.asset(
                                          page.lottiePath,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: isTablet ? 28 : 16,
                            child: TextButton(
                              onPressed: _skipOnboarding,
                              style: TextButton.styleFrom(
                                backgroundColor: index == 0
                                    ? Colors.white30
                                    : Colors.black12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: index == 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 94,
                            left: 0,
                            right: 0,
                            child: _OnboardingDots(
                              currentPage: _currentPage,
                              totalPages: _pages.length,
                              activeColor: index == 0
                                  ? Colors.white
                                  : const Color(0xFF4F46E5),
                              inactiveColor: index == 0
                                  ? Colors.white38
                                  : Colors.black26,
                            ),
                          ),
                          Positioned(
                            bottom: 28,
                            left: isTablet ? 28 : 16,
                            right: isTablet ? 28 : 16,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _nextPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: page.buttonColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  _currentPage == _pages.length - 1
                                      ? 'Get Started'
                                      : 'Next',
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
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots({
    required this.currentPage,
    required this.totalPages,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int currentPage;
  final int totalPages;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final bool isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: isActive ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
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
