import 'dart:async';
import 'package:businesstrack/core/sensors/light_sensor_state.dart';

class LightSensorService {
  Timer? _lightSimulationTimer;
  final StreamController<LightSensorState> _stateController =
      StreamController<LightSensorState>.broadcast();

  LightSensorState _currentState = LightSensorState.initial();

  Stream<LightSensorState> get stateStream => _stateController.stream;
  LightSensorState get currentState => _currentState;

  // Hysteresis thresholds to prevent flickering
  // Dark mode ON when light < darkModeThresholdLow
  // Dark mode OFF when light > darkModeThresholdHigh
  static const double darkModeThresholdLow = 180.0;
  static const double darkModeThresholdHigh = 300.0;

  DateTime? _lastStateUpdateTime;
  static const Duration updateInterval = Duration(seconds: 2);

  void initialize() {
    _startLightSensor();
    _updateState(_currentState.copyWith(isActive: true));
  }

  void _startLightSensor() {
    // Use time-based simulation for realistic day/night cycle
    // Updates every 2 seconds to provide responsive theme switching
    _lightSimulationTimer = Timer.periodic(updateInterval, (timer) {
      _simulateDayNightCycle();
    });

    // Initial update
    _simulateDayNightCycle();
  }

  void _simulateDayNightCycle() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;

    double simulatedLight;

    // Simulate realistic day/night cycle based on time of day
    if (hour >= 6 && hour < 7) {
      // Early Dawn: 6 AM - 7 AM (50-180 lux) - gradually brightening
      double progress = (hour - 6) + (minute / 60.0);
      simulatedLight = 50 + (progress * 130);
    } else if (hour >= 7 && hour < 8) {
      // Dawn: 7 AM - 8 AM (180-400 lux) - getting brighter
      double progress = (hour - 7) + (minute / 60.0);
      simulatedLight = 180 + (progress * 220);
    } else if (hour >= 8 && hour < 17) {
      // Day: 8 AM - 5 PM (400-800 lux) - bright daylight
      simulatedLight = 400 + ((hour - 8) * 40) + (minute / 60.0 * 40);
    } else if (hour >= 17 && hour < 18) {
      // Late Afternoon: 5 PM - 6 PM (600-400 lux) - starting to dim
      double progress = (hour - 17) + (minute / 60.0);
      simulatedLight = 600 - (progress * 200);
    } else if (hour >= 18 && hour < 19) {
      // Dusk: 6 PM - 7 PM (400-180 lux) - getting darker
      double progress = (hour - 18) + (minute / 60.0);
      simulatedLight = 400 - (progress * 220);
    } else if (hour >= 19 && hour < 20) {
      // Evening: 7 PM - 8 PM (180-80 lux) - twilight
      double progress = (hour - 19) + (minute / 60.0);
      simulatedLight = 180 - (progress * 100);
    } else {
      // Night: 8 PM - 6 AM (30-80 lux) - dark with some ambient light
      simulatedLight = 30 + (now.second % 30);
    }

    _updateLightLevel(simulatedLight);
  }

  void _updateLightLevel(double lightLevel) {
    // Apply hysteresis to prevent flickering
    bool shouldBeDarkMode;
    if (_currentState.isDarkMode) {
      // Currently in dark mode: only switch to light if above HIGH threshold
      shouldBeDarkMode = lightLevel < darkModeThresholdHigh;
    } else {
      // Currently in light mode: only switch to dark if below LOW threshold
      shouldBeDarkMode = lightLevel < darkModeThresholdLow;
    }

    String condition = _getLightCondition(lightLevel);

    LightSensorState newState = _currentState.copyWith(
      lightLevel: lightLevel,
      isDarkMode: shouldBeDarkMode,
      lightCondition: condition,
    );

    _updateState(newState);
  }

  void _updateState(LightSensorState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  String _getLightCondition(double lightLevel) {
    if (lightLevel < 80) {
      return 'Very Dark';
    } else if (lightLevel < 180) {
      return 'Dark';
    } else if (lightLevel < 350) {
      return 'Dim';
    } else if (lightLevel < 600) {
      return 'Normal';
    } else {
      return 'Bright';
    }
  }

  void dispose() {
    _lightSimulationTimer?.cancel();
    _stateController.close();
  }
}
