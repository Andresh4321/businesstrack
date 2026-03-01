// Example: How to use sensors in your pages

import 'package:businesstrack/core/sensors/widgets/light_sensor_indicator.dart';
import 'package:flutter/material.dart';

class ExamplePageWithSensors extends StatelessWidget {
  const ExamplePageWithSensors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Page'),
        actions: [
          // Add light sensor indicator to app bar
          const LightSensorIndicator(),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show detailed light sensor information
            const LightSensorIndicator(showDetails: true),
            const SizedBox(height: 16),

            // Info about shake detector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.vibration, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Shake Detector Active',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Shake your phone to quickly create new items!',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: const Text(
                            'Recipe',
                            style: TextStyle(fontSize: 11),
                          ),
                          avatar: const Icon(Icons.menu_book, size: 16),
                        ),
                        Chip(
                          label: const Text(
                            'Material',
                            style: TextStyle(fontSize: 11),
                          ),
                          avatar: const Icon(Icons.inventory_2, size: 16),
                        ),
                        Chip(
                          label: const Text(
                            'Supplier',
                            style: TextStyle(fontSize: 11),
                          ),
                          avatar: const Icon(Icons.local_shipping, size: 16),
                        ),
                        Chip(
                          label: const Text(
                            'Production',
                            style: TextStyle(fontSize: 11),
                          ),
                          avatar: const Icon(Icons.factory, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Your page content goes here...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

/* 
 * ==========================================
 * SENSOR INTEGRATION GUIDE
 * ==========================================
 * 
 * Both sensors are already active app-wide via main.dart!
 * You don't need to add anything special to make them work.
 * 
 * 
 * 1️⃣ LIGHT SENSOR (Auto Theme Switching):
 * ----------------------------------------
 * - Automatically switches between light and dark mode
 * - Based on ambient light levels
 * - Works everywhere in the app
 * 
 * To show light sensor indicator in your page:
 *   import 'package:businesstrack/core/sensors/widgets/light_sensor_indicator.dart';
 * 
 *   // In AppBar:
 *   AppBar(
 *     actions: [
 *       const LightSensorIndicator(),
 *     ],
 *   )
 * 
 *   // Or in body for detailed info:
 *   LightSensorIndicator(showDetails: true)
 * 
 * 
 * 2️⃣ SHAKE DETECTOR (Quick Actions):
 * -----------------------------------
 * - Shake phone anywhere to open quick actions menu
 * - Provides fast access to create:
 *   • Recipe
 *   • Material
 *   • Supplier
 *   • Production Batch
 * 
 * No code needed - just shake the device!
 * 
 * 
 * 3️⃣ ACCESS SENSOR DATA IN YOUR CODE:
 * -------------------------------------
 * 
 * Light Sensor:
 *   import 'package:businesstrack/core/sensors/light_sensor_provider.dart';
 *   
 *   // In a ConsumerWidget:
 *   final lightState = ref.watch(currentLightSensorStateProvider);
 *   print('Light Level: ${lightState.lightLevel} lux');
 *   print('Is Dark Mode: ${lightState.isDarkMode}');
 * 
 * Shake Detector:
 *   import 'package:businesstrack/core/sensors/shake_detector_provider.dart';
 *   
 *   // In a ConsumerWidget:
 *   final shakeState = ref.watch(currentShakeDetectorStateProvider);
 *   print('Shake detected: ${shakeState.isShaking}');
 *   print('Total shakes: ${shakeState.shakeCount}');
 * 
 * 
 * 4️⃣ DOCUMENTATION:
 * -----------------
 * - Light Sensor: See README.md
 * - Shake Detector: See SHAKE_DETECTOR_README.md
 */
