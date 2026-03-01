# Shake Detector Module

This module provides shake detection functionality to quickly access creation actions from anywhere in the app.

## 📁 Structure

```
lib/core/sensors/
├── shake_detector_state.dart       # State model for shake detection
├── shake_detector_service.dart     # Service that handles shake detection logic
├── shake_detector_provider.dart    # Riverpod providers for state management
├── shake_detector_wrapper.dart     # Wrapper widget for app-wide integration
└── widgets/
    └── quick_action_dialog.dart    # Dialog shown on shake detection
```

## 🚀 Features

- **Shake to Create**: Shake your phone anywhere in the app to open quick actions
- **Quick Access Menu**: Fast access to:
  - Create Recipe
  - Add Material
  - Add Supplier
  - Start Production Batch
- **Smart Cooldown**: Prevents accidental multiple triggers (2-3 second cooldown)
- **Visual Feedback**: Shows snackbar notification when shake is detected
- **App-wide Integration**: Works from any screen in the app

## 🎯 How It Works

1. **Shake Detection**: Uses accelerometer to detect shake gestures (threshold: 15.0 m/s²)
2. **Cooldown System**: Prevents multiple rapid detections with 2-second cooldown
3. **Quick Action Dialog**: Automatically shows dialog with creation options
4. **Navigation**: Taps on any option navigate to the respective creation page

## 💻 Usage

### Basic Setup (Already Done)

The shake detector is already integrated into the app via `main.dart`:

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

1. **Shake your phone** anywhere in the app
2. Wait for the quick action dialog to appear
3. Select the action you want to perform:
   - 📖 Create Recipe
   - 📦 Add Material
   - 🚚 Add Supplier
   - 🏭 Start Production

### Customization

#### Change Shake Sensitivity

Edit `shake_detector_service.dart`:

```dart
static const double shakeThreshold = 15.0;  // Lower = more sensitive
```

#### Change Cooldown Duration

Edit `shake_detector_service.dart`:

```dart
static const Duration shakeCooldown = Duration(seconds: 2); // Adjust cooldown time
```

#### Add More Quick Actions

Edit `quick_action_dialog.dart` and add new buttons:

```dart
_buildQuickActionButton(
  context,
  icon: Icons.your_icon,
  title: 'Your Action',
  subtitle: 'Your description',
  color: Colors.yourColor,
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const YourPage(),
      ),
    );
  },
),
```

## 🎨 Shake Detection Parameters

- **Threshold**: 15.0 m/s² acceleration
- **Cooldown**: 2 seconds between detections
- **Dialog Cooldown**: 3 seconds minimum between dialog shows
- **Feedback Duration**: 1.5 seconds

## 🧪 Testing

To test shake detection:
1. Run the app on a physical device (emulators may not have reliable accelerometer)
2. Hold the device firmly
3. Shake it with moderate force
4. The quick action dialog should appear

**Note**: Shake detection works best on physical devices. Emulators may have limited or no accelerometer support.

## 📱 Platform Support

- ✅ Android (Physical Device)
- ✅ iOS (Physical Device)
- ⚠️ Emulator/Simulator (Limited - may not work reliably)
- ❌ Web (No accelerometer support)
- ❌ Desktop (No accelerometer support)

## 🐛 Debugging

To see shake detection events, the service will:
- Update the state stream on each shake
- Show a snackbar notification
- Display the quick action dialog

### Check if Sensor is Active

```dart
final shakeState = ref.watch(currentShakeDetectorStateProvider);
print('Shake detector active: ${shakeState.isActive}');
print('Shake count: ${shakeState.shakeCount}');
```

## 🔄 How to Disable

If you want to temporarily disable shake detection, remove the `ShakeDetectorWrapper` from `main.dart`:

```dart
// Before (with shake detector):
runApp(
  ProviderScope(
    child: const ShakeDetectorWrapper(
      child: LightSensorWrapper(child: MyApp()),
    ),
  ),
);

// After (without shake detector):
runApp(
  ProviderScope(
    child: const LightSensorWrapper(child: MyApp()),
  ),
);
```

## 🎯 Best Practices

1. **Test on Physical Device**: Always test shake detection on actual hardware
2. **Adjust Sensitivity**: Tune the threshold based on your target users
3. **Provide Visual Feedback**: Always show users that shake was detected
4. **Use Cooldown**: Prevent accidental multiple triggers
5. **Keep Actions Relevant**: Only show frequently-used creation actions

## 🔗 Integration with Other Features

The shake detector works seamlessly with:
- **Light Sensor**: Both sensors operate independently
- **Navigation**: Can trigger navigation from any screen
- **State Management**: Uses Riverpod for reactive updates

## 💡 Tips

- **Moderate Force**: Users should shake with moderate force, not too gentle or too hard
- **Secure Grip**: Encourage users to hold device securely while shaking
- **Clear Feedback**: The snackbar provides immediate feedback that shake was detected
- **Quick Access**: Most useful for power users who frequently create new items
