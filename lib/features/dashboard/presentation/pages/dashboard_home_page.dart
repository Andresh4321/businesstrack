import 'package:businesstrack/features/dashboard/presentation/pages/dashboard_screen_improved.dart'
    as improved;
import 'package:flutter/material.dart';

/// Legacy entrypoint kept for compatibility.
/// The improved dashboard is used across the app.
class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const improved.DashboardScreen();
  }
}
