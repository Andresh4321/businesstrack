import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:businesstrack/core/sensors/shake_detector_state.dart';

class ShakeDetectorService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final StreamController<ShakeDetectorState> _stateController =
      StreamController<ShakeDetectorState>.broadcast();

  ShakeDetectorState _currentState = ShakeDetectorState.initial();

  Stream<ShakeDetectorState> get stateStream => _stateController.stream;
  ShakeDetectorState get currentState => _currentState;

  // Shake detection parameters
  static const double shakeThreshold = 15.0; // Acceleration threshold for shake
  static const Duration shakeCooldown = Duration(
    seconds: 2,
  ); // Cooldown between shakes

  DateTime? _lastShakeTime;
  int _shakeCount = 0;

  void initialize() {
    _startShakeDetection();
    _updateState(_currentState.copyWith(isActive: true));
  }

  void _startShakeDetection() {
    _accelerometerSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      _detectShake(event);
    });
  }

  void _detectShake(AccelerometerEvent event) {
    // Calculate total acceleration (magnitude of acceleration vector)
    double acceleration = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );

    // Check if acceleration exceeds shake threshold
    if (acceleration > shakeThreshold) {
      final now = DateTime.now();

      // Check cooldown period to prevent multiple rapid detections
      if (_lastShakeTime == null ||
          now.difference(_lastShakeTime!) > shakeCooldown) {
        _lastShakeTime = now;
        _shakeCount++;

        // Update state to indicate shake detected
        ShakeDetectorState newState = _currentState.copyWith(
          isShaking: true,
          lastShakeTime: now,
          shakeCount: _shakeCount,
        );

        _updateState(newState);

        // Reset shaking state after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_currentState.isShaking) {
            _updateState(_currentState.copyWith(isShaking: false));
          }
        });
      }
    }
  }

  void _updateState(ShakeDetectorState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  void dispose() {
    _accelerometerSubscription?.cancel();
    _stateController.close();
  }
}
