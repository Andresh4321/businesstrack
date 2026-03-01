import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:businesstrack/core/sensors/light_sensor_state.dart';

class LightSensorService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  Timer? _lightSimulationTimer;
  final StreamController<LightSensorState> _stateController =
      StreamController<LightSensorState>.broadcast();

  LightSensorState _currentState = LightSensorState.initial();

  Stream<LightSensorState> get stateStream => _stateController.stream;
  LightSensorState get currentState => _currentState;

  // Threshold values for theme switching
  static const double darkModeThreshold = 200.0;
  static const double lightModeThreshold = 500.0;

  void initialize() {
    _startLightSensor();
    _updateState(_currentState.copyWith(isActive: true));
  }

  void _startLightSensor() {
    // Method 1: Use accelerometer to simulate light detection
    _accelerometerSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      // Calculate simulated light level based on device movement/orientation
      double totalAccel = event.x.abs() + event.y.abs() + event.z.abs();
      double simulatedLight = (totalAccel * 50).clamp(0, 1000);

      _updateLightLevel(simulatedLight);
    });

    // Method 2: Time-based simulation (day/night cycle)
    _lightSimulationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _simulateDayNightCycle();
    });
  }

  void _simulateDayNightCycle() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;

    double simulatedLight;

    // Simulate realistic day/night cycle
    if (hour >= 6 && hour < 8) {
      // Dawn: 6 AM - 8 AM (100-600 lux)
      simulatedLight = 100 + ((hour - 6) * 2 + minute / 60) * 250;
    } else if (hour >= 8 && hour < 18) {
      // Day: 8 AM - 6 PM (600-1000 lux)
      simulatedLight = 600 + (now.second * 4).toDouble();
    } else if (hour >= 18 && hour < 20) {
      // Dusk: 6 PM - 8 PM (600-100 lux)
      simulatedLight = 600 - ((hour - 18) * 2 + minute / 60) * 250;
    } else {
      // Night: 8 PM - 6 AM (50-100 lux)
      simulatedLight = 50 + (now.second * 0.5);
    }

    _updateLightLevel(simulatedLight);
  }

  void _updateLightLevel(double lightLevel) {
    bool shouldBeDarkMode = lightLevel < darkModeThreshold;
    bool themeChanged = shouldBeDarkMode != _currentState.isDarkMode;

    String condition = _getLightCondition(lightLevel);

    LightSensorState newState = _currentState.copyWith(
      lightLevel: lightLevel,
      isDarkMode: shouldBeDarkMode,
      lightCondition: condition,
    );

    _updateState(newState, themeChanged: themeChanged);
  }

  void _updateState(LightSensorState newState, {bool themeChanged = false}) {
    _currentState = newState;
    _stateController.add(newState);
  }

  String _getLightCondition(double lightLevel) {
    if (lightLevel < 100) {
      return 'Very Dark';
    } else if (lightLevel < 200) {
      return 'Dark';
    } else if (lightLevel < 500) {
      return 'Dim';
    } else if (lightLevel < 800) {
      return 'Normal';
    } else {
      return 'Bright';
    }
  }

  void dispose() {
    _accelerometerSubscription?.cancel();
    _lightSimulationTimer?.cancel();
    _stateController.close();
  }
}
