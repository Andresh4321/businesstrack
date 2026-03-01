import 'package:businesstrack/core/sensors/shake_detector_service.dart';
import 'package:businesstrack/core/sensors/shake_detector_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the shake detector service
final shakeDetectorServiceProvider = Provider<ShakeDetectorService>((ref) {
  final service = ShakeDetectorService();
  service.initialize();

  // Cleanup when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

// Provider for the shake detector state stream
final shakeDetectorStateProvider = StreamProvider<ShakeDetectorState>((ref) {
  final service = ref.watch(shakeDetectorServiceProvider);
  return service.stateStream;
});

// Provider for current shake detector state (synchronous)
final currentShakeDetectorStateProvider = Provider<ShakeDetectorState>((ref) {
  final asyncValue = ref.watch(shakeDetectorStateProvider);

  return asyncValue.when(
    data: (state) => state,
    loading: () => ShakeDetectorState.initial(),
    error: (_, __) => ShakeDetectorState.initial(),
  );
});
