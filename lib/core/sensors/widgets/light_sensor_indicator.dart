import 'package:businesstrack/core/sensors/light_sensor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget to display light sensor status
/// Can be placed anywhere in the app to show current light levels
class LightSensorIndicator extends ConsumerWidget {
  final bool showDetails;
  final bool compact;

  const LightSensorIndicator({
    super.key,
    this.showDetails = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorStateAsync = ref.watch(lightSensorStateProvider);

    return sensorStateAsync.when(
      data: (sensorState) {
        if (compact) {
          return _buildCompactIndicator(sensorState);
        } else if (showDetails) {
          return _buildDetailedIndicator(sensorState);
        } else {
          return _buildChipIndicator(sensorState);
        }
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildChipIndicator(sensorState) {
    return Chip(
      avatar: Icon(
        sensorState.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
        size: 16,
        color: Colors.white,
      ),
      label: Text(
        '${sensorState.lightLevel.toInt()} lux',
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      backgroundColor: sensorState.isDarkMode
          ? Colors.indigo[700]
          : Colors.orange[600],
    );
  }

  Widget _buildCompactIndicator(sensorState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: sensorState.isDarkMode ? Colors.indigo[700] : Colors.orange[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            sensorState.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
            size: 14,
            color: sensorState.isDarkMode ? Colors.white : Colors.orange[800],
          ),
          const SizedBox(width: 4),
          Text(
            '${sensorState.lightLevel.toInt()}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: sensorState.isDarkMode ? Colors.white : Colors.orange[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedIndicator(sensorState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sensors,
                  color: sensorState.isDarkMode ? Colors.indigo : Colors.orange,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Light Sensor',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: sensorState.isDarkMode
                        ? Colors.indigo[100]
                        : Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        sensorState.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        size: 14,
                        color: sensorState.isDarkMode
                            ? Colors.indigo[700]
                            : Colors.orange[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        sensorState.isDarkMode ? 'Dark' : 'Light',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: sensorState.isDarkMode
                              ? Colors.indigo[700]
                              : Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  sensorState.isDarkMode
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Ambient Light: ${sensorState.lightLevel.toInt()} lux',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.wb_twilight, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Condition: ${sensorState.lightCondition}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
