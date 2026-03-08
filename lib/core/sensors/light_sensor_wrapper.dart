import 'package:businesstrack/app/myapp.dart';
import 'package:businesstrack/core/sensors/light_sensor_provider.dart';
import 'package:businesstrack/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:businesstrack/features/auth/presentation/state/auth.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Widget that listens to light sensor and automatically adjusts app theme
/// Only activates after successful login
class LightSensorWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const LightSensorWrapper({super.key, required this.child});

  @override
  ConsumerState<LightSensorWrapper> createState() => _LightSensorWrapperState();
}

class _LightSensorWrapperState extends ConsumerState<LightSensorWrapper> {
  bool _lastDarkModeState = false;
  DateTime? _lastThemeChangeTime;
  bool _autoThemeEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoThemeEnabled = prefs.getBool('auto_theme_enabled') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is authenticated
    final authState = ref.watch(authViewModelProvider);
    final isAuthenticated = authState.status == AuthStatus.authenticated;

    // Only listen to light sensor if user is logged in and auto-theme is enabled
    if (isAuthenticated && _autoThemeEnabled) {
      ref.listen<AsyncValue>(lightSensorStateProvider, (previous, next) {
        next.whenData((sensorState) {
          // Prevent rapid theme changes
          final now = DateTime.now();
          if (_lastThemeChangeTime != null &&
              now.difference(_lastThemeChangeTime!) <
                  const Duration(seconds: 5)) {
            return;
          }

          // Only update theme if it actually changed
          if (sensorState.isDarkMode != _lastDarkModeState) {
            _lastDarkModeState = sensorState.isDarkMode;
            _lastThemeChangeTime = now;

            // Update the app theme
            MyApp.themeNotifier.value = sensorState.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light;

            // Show notification to user
            if (mounted) {
              _showThemeChangeNotification(sensorState);
            }
          }
        });
      });
    }

    return widget.child;
  }

  void _showThemeChangeNotification(sensorState) {
    // Get a scaffold messenger to show snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final navigatorContext = MyApp.navigatorKey.currentContext;
      if (navigatorContext == null) return;

      final messenger = ScaffoldMessenger.maybeOf(navigatorContext);
      if (messenger != null) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  sensorState.isDarkMode
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        sensorState.isDarkMode
                            ? '🌙 Dark Mode'
                            : '☀️ Light Mode',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Auto-switched based on time (${sensorState.lightLevel.toInt()} lux)',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: sensorState.isDarkMode
                ? Colors.indigo.shade700
                : Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }
}
