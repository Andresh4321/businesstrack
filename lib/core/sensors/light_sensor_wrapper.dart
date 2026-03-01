import 'package:businesstrack/app/myapp.dart';
import 'package:businesstrack/core/sensors/light_sensor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that listens to light sensor and automatically adjusts app theme
class LightSensorWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const LightSensorWrapper({super.key, required this.child});

  @override
  ConsumerState<LightSensorWrapper> createState() => _LightSensorWrapperState();
}

class _LightSensorWrapperState extends ConsumerState<LightSensorWrapper> {
  bool _lastDarkModeState = false;
  DateTime? _lastThemeChangeTime;

  @override
  Widget build(BuildContext context) {
    // Listen to light sensor state
    ref.listen<AsyncValue>(lightSensorStateProvider, (previous, next) {
      next.whenData((sensorState) {
        // Prevent rapid theme changes
        final now = DateTime.now();
        if (_lastThemeChangeTime != null &&
            now.difference(_lastThemeChangeTime!) <
                const Duration(seconds: 3)) {
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
                            ? 'Dark Mode Activated'
                            : 'Light Mode Activated',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Light: ${sensorState.lightLevel.toInt()} lux (${sensorState.lightCondition})',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: sensorState.isDarkMode
                ? Colors.indigo
                : Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }
}
