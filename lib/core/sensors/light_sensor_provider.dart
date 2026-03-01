import 'package:businesstrack/core/sensors/light_sensor_service.dart';
import 'package:businesstrack/core/sensors/light_sensor_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the light sensor service
final lightSensorServiceProvider = Provider<LightSensorService>((ref) {
  final service = LightSensorService();
  service.initialize();

  // Cleanup when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

// Provider for the light sensor state stream
final lightSensorStateProvider = StreamProvider<LightSensorState>((ref) {
  final service = ref.watch(lightSensorServiceProvider);
  return service.stateStream;
});

// Provider for current light sensor state (synchronous)
final currentLightSensorStateProvider = Provider<LightSensorState>((ref) {
  final asyncValue = ref.watch(lightSensorStateProvider);

  return asyncValue.when(
    data: (state) => state,
    loading: () => LightSensorState.initial(),
    error: (_, __) => LightSensorState.initial(),
  );
});
