# Sensors Module

This module provides hardware sensor integration for the entire BusinessTrack app, including light sensing and shake detection for enhanced user experience.

## 🎯 Overview

The sensors module includes two main features:

### 1. **Light Sensor** 💡
- **Purpose**: Automatically adjusts app theme based on ambient lighting
- **Behavior**: 
  - Dark mode activates when light < 200 lux
  - Light mode activates when light > 500 lux
- **Benefit**: Better visibility and reduced eye strain

### 2. **Shake Detector** 📳
- **Purpose**: Quick access to creation actions from anywhere in the app
- **Behavior**: Shake phone to open quick actions menu
- **Actions Available**:
  - Create Recipe
  - Add Material
  - Add Supplier
  - Start Production Batch

## 📁 Module Structure

```
lib/core/sensors/
├── README.md                        # This file - main documentation
├── SHAKE_DETECTOR_README.md         # Detailed shake detector docs
├── example_usage.dart               # Code examples
│
├── Light Sensor Files:
│   ├── light_sensor_state.dart      # State model
│   ├── light_sensor_service.dart    # Core logic
│   ├── light_sensor_provider.dart   # Riverpod providers
│   └── light_sensor_wrapper.dart    # App integration
│
├── Shake Detector Files:
│   ├── shake_detector_state.dart    # State model
│   ├── shake_detector_service.dart  # Core logic
│   ├── shake_detector_provider.dart # Riverpod providers
│   └── shake_detector_wrapper.dart  # App integration
│
└── widgets/
    ├── light_sensor_indicator.dart  # Visual indicator widget
    └── quick_action_dialog.dart     # Shake action menu
```

## 🚀 Quick Start

### Already Integrated! ✅

Both sensors are already active in your app through `main.dart`:

```dart
runApp(
  ProviderScope(
    child: const ShakeDetectorWrapper(
      child: LightSensorWrapper(
        child: MyApp(),
      ),
    ),
  ),
);
```

### How to Use

#### Light Sensor
1. **No action needed** - theme switches automatically
2. **Optional**: Add indicator to any page:
```dart
import 'package:businesstrack/core/sensors/widgets/light_sensor_indicator.dart';

AppBar(
  actions: [const LightSensorIndicator()],
)
```

#### Shake Detector
1. **Shake your phone** anywhere in the app
2. Select from quick actions menu
3. Create items instantly

## 📊 Sensor Parameters

### Light Sensor Thresholds:
| Light Level | Mode | Description |
|------------|------|-------------|
| < 100 lux | Dark | Very Dark |
| 100-200 lux | Dark | Dark |
| 200-500 lux | Light | Dim |
| 500-800 lux | Light | Normal |
| > 800 lux | Light | Bright |

### Shake Detection:
- **Threshold**: 15.0 m/s² acceleration
- **Cooldown**: 2 seconds between detections
- **Best on**: Physical devices (not emulators)

## 💻 Code Examples

### Display Light Sensor Info
```dart
import 'package:businesstrack/core/sensors/widgets/light_sensor_indicator.dart';

// Compact indicator
LightSensorIndicator()

// Detailed card
LightSensorIndicator(showDetails: true)

// Mini version
LightSensorIndicator(compact: true)
```

### Access Sensor Data
```dart
import 'package:businesstrack/core/sensors/light_sensor_provider.dart';
import 'package:businesstrack/core/sensors/shake_detector_provider.dart';

// In a ConsumerWidget:

// Light sensor data
final lightState = ref.watch(currentLightSensorStateProvider);
print('Light: ${lightState.lightLevel} lux');
print('Dark mode: ${lightState.isDarkMode}');

// Shake detector data
final shakeState = ref.watch(currentShakeDetectorStateProvider);
print('Shakes detected: ${shakeState.shakeCount}');
```

## 🎨 Customization

### Adjust Light Sensor Thresholds
Edit `light_sensor_service.dart`:
```dart
static const double darkModeThreshold = 200.0;
static const double lightModeThreshold = 500.0;
```

### Change Shake Sensitivity
Edit `shake_detector_service.dart`:
```dart
static const double shakeThreshold = 15.0; // Lower = more sensitive
```

### Add Custom Quick Actions
Edit `widgets/quick_action_dialog.dart` to add more buttons

## 📱 Platform Support

| Feature | Android | iOS | Web | Desktop |
|---------|---------|-----|-----|---------|
| Light Sensor | ✅ | ✅ | ⚠️ Simulated | ⚠️ Simulated |
| Shake Detector | ✅ | ✅ | ❌ | ❌ |

**Note**: Best experience on physical mobile devices

## 🐛 Troubleshooting

### Light Sensor Not Working?
- Check if sensor is active: Light indicator should show in UI
- Theme changes may be subtle in some screens
- Simulated mode is used on web/desktop

### Shake Detector Not Responding?
- Use a **physical device** (not emulator)
- Shake with **moderate force**
- Wait 2-3 seconds between shakes (cooldown period)
- Check that dialog isn't already showing

### Both Sensors Off?
- Verify wrappers are in `main.dart`
- Check terminal for sensor initialization errors
- Ensure `sensors_plus` package is installed

## 🔧 Maintenance

### Disable Temporarily

**Disable Light Sensor:**
```dart
// Remove from main.dart
child: const MyApp(),  // Instead of LightSensorWrapper
```

**Disable Shake Detector:**
```dart
// Remove from main.dart  
child: const LightSensorWrapper(child: MyApp()),  // Remove ShakeDetectorWrapper
```

### Update Sensor Logic
- Light sensor logic: `light_sensor_service.dart`
- Shake detection logic: `shake_detector_service.dart`
- Quick action menu: `widgets/quick_action_dialog.dart`

## 📚 Additional Documentation

- **Detailed Shake Info**: See `SHAKE_DETECTOR_README.md`
- **Code Examples**: See `example_usage.dart`
- **Individual Providers**: Check provider files for state management details

## 🎯 Best Practices

1. ✅ Test on physical devices for accurate sensor readings
2. ✅ Provide visual feedback when sensors trigger actions
3. ✅ Use appropriate cooldown periods to prevent spam
4. ✅ Keep quick actions relevant and frequently used
5. ✅ Monitor sensor battery impact on production builds

## 🔗 Dependencies

```yaml
dependencies:
  sensors_plus: ^4.0.2
  flutter_riverpod: ^3.0.3
```

## 📞 Support

For issues or feature requests related to sensors:
1. Check this README and related docs
2. Review example_usage.dart
3. Verify sensor initialization in terminal logs

---

**Status**: ✅ Both sensors active and integrated
**Last Updated**: 2026-03-01
