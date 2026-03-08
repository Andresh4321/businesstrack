# Stock Management Biometric Authentication

## Overview

The Stock Management feature now has enhanced security with **biometric authentication (fingerprint/face recognition)** and **4-digit PIN verification**. This ensures that only authorized personnel can access sensitive stock data.

---

## Features

### 🔐 Dual Authentication
- **Biometric Authentication**: Fingerprint, Face ID, or other device biometrics
- **4-Digit PIN**: Secure numeric code as backup or alternative

### 🎯 First-Time Setup
On first access to Stock Management:
1. User is prompted to create a **4-digit PIN**
2. System checks for available biometric authentication
3. If biometrics available, user authenticates with fingerprint/face to complete setup
4. PIN is securely stored using Flutter Secure Storage

### 🔓 Subsequent Access
After initial setup:
- User can authenticate with **EITHER** biometric OR PIN
- Flexible authentication allows quick access via fingerprint or fallback to PIN
- Failed biometric attempts automatically prompt for PIN

### 🛡️ Security Features
- **Secure Storage**: PIN stored using Flutter Secure Storage (encrypted)
- **Attempt Limiting**: Maximum 3 PIN attempts before requiring biometric
- **Lockout Protection**: Biometric lockout detection with PIN fallback
- **Device-Level Security**: Uses native device biometric APIs

---

## Architecture

### Files Created

#### 1. **stock_biometric_auth_service.dart**
Location: `lib/features/stock/presentation/widgets/`

**Purpose**: Core authentication service handling all biometric and PIN operations

**Key Methods**:
- `isBiometricAvailable()` - Check device biometric capability
- `authenticateWithBiometrics()` - Perform biometric authentication
- `setupPin(String pin)` - Store new PIN
- `verifyPin(String pin)` - Validate entered PIN
- `hasPinSet()` - Check if PIN exists
- `resetPin()` - Clear authentication data

**Classes**:
- `StockBiometricAuthService` - Singleton service
- `BiometricAuthResult` - Authentication result wrapper
- `BiometricErrorCode` - Error type enumeration

---

#### 2. **stock_auth_gate.dart**
Location: `lib/features/stock/presentation/widgets/`

**Purpose**: Authentication UI wrapper that protects stock management screens

**Features**:
- First-time setup UI with PIN creation
- Authentication UI with biometric and PIN options
- Automatic retry and fallback logic
- Clear error messaging

**UI States**:
- **Loading**: Initializing security
- **Setup**: First-time PIN creation (+ optional biometric)
- **Authentication**: Login screen (biometric or PIN)
- **Authenticated**: Access granted, shows protected content

---

#### 3. **Protected Pages**
All stock management pages are wrapped with `StockAuthGate`:

- `stock_management_page.dart` - Main stock management screen
- `stock_page.dart` - Stock list view
- `stock_update_page.dart` - Stock adjustment screen

---

## User Flow

### First-Time Access

```
User Opens Stock Management
         ↓
   Is First Time?
         ↓ Yes
   Setup Screen
         ↓
  Enter 4-Digit PIN
         ↓
  Confirm PIN Match
         ↓
 Biometric Available? 
    ↓ Yes          ↓ No
Authenticate     PIN Only
with Biometric   Sufficient
         ↓           ↓
    ✅ Access Granted
```

### Subsequent Access

```
User Opens Stock Management
         ↓
  Authentication Screen
         ↓
  Choose Method:
  [Biometric] or [PIN]
         ↓
    Authenticate
         ↓
  Success? ↓ No → Retry (3 attempts)
         ↓ Yes
    ✅ Access Granted
```

---

## Code Integration

### How It Works

1. **Wrapper Pattern**: Each stock page is wrapped with `StockAuthGate`
   ```dart
   return StockAuthGate(
     child: Scaffold(
       // Your stock management UI
     ),
   );
   ```

2. **Automatic Gating**: Authentication happens before page content renders
3. **Seamless UX**: Once authenticated, user stays authenticated during session
4. **Security First**: Can't bypass - authentication is required

---

## Configuration

### Requirements

**pubspec.yaml**:
```yaml
dependencies:
  local_auth: ^2.3.0
  flutter_secure_storage: ^10.0.0
```

**Platform Setup**:

#### Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

#### iOS (`ios/Runner/Info.plist`):
```xml
<key>NSFaceIDUsageDescription</key>
<string>Authenticate to access Stock Management</string>
```

---

## Security Considerations

### ✅ Best Practices Implemented
- PIN stored using FlutterSecureStorage (platform-encrypted storage)
- Biometric authentication uses device hardware security
- No plain-text storage of credentials
- Attempt limiting prevents brute force
- Error handling doesn't leak security info

### 🔒 Additional Recommendations
- Consider implementing session timeout
- Add audit logging for authentication events
- Implement remote wipe capability
- Consider multi-factor authentication for high-value operations
- Regular security audits

---

## Testing

### Test Scenarios

1. **First-Time Setup**
   - Create PIN
   - Confirm PIN matches
   - Biometric auth (if available)

2. **Biometric Authentication**
   - Successful fingerprint
   - Cancelled authentication
   - Failed attempts
   - Fallback to PIN

3. **PIN Authentication**
   - Correct PIN entry
   - Incorrect PIN (attempt limiting)
   - Maximum attempts reached

4. **Edge Cases**
   - Device without biometric
   - Biometric not enrolled
   - Biometric lockout
   - App restart (session persistence)

---

## Customization

### Changing PIN Length
In `stock_biometric_auth_service.dart`:
```dart
bool _isValidPin(String pin) {
  return pin.length == 4 && RegExp(r'^\d{4}$').hasMatch(pin);
}
```
Change `4` to desired length (e.g., `6` for 6-digit PIN)

### Changing Attempt Limit
In `stock_auth_gate.dart`:
```dart
static const int _maxAttempts = 3;
```

### Customizing Messages
Edit the authentication reason in `stock_biometric_auth_service.dart`:
```dart
localizedReason: 'Authenticate to access Stock Management',
```

---

## Troubleshooting

### Issue: "Biometric not available"
**Solution**: 
- Check device has biometric hardware
- Ensure biometric is enrolled in device settings
- Verify platform permissions are set

### Issue: "PIN not saving"
**Solution**:
- Check FlutterSecureStorage is initialized
- Verify platform-specific secure storage is available
- Check app permissions

### Issue: Authentication screen stuck
**Solution**:
- Clear app data and retry
- Check for authentication state persistence issues
- Verify `isFirstTime()` logic

---

## Future Enhancements

### Potential Additions
- [ ] Session timeout/auto-lock
- [ ] Remote authentication via backend
- [ ] Biometric + PIN (two-factor)
- [ ] Admin override codes
- [ ] Authentication audit logs
- [ ] Touch ID/Face ID fallback options
- [ ] Pattern lock as alternative
- [ ] Export authentication logs

---

## Support

### Dependencies
- **local_auth**: ^2.3.0 (biometric authentication)
- **flutter_secure_storage**: ^10.0.0 (secure PIN storage)

### Platform Support
- ✅ Android (API 23+)
- ✅ iOS (iOS 11+)
- ✅ Windows (Windows Hello)
- ⚠️ Web (limited biometric support)
- ⚠️ macOS (Touch ID support)
- ⚠️ Linux (limited support)

---

## Example Usage

### Wrapping a New Page

If you want to add authentication to another sensitive page:

```dart
import 'package:businesstrack/features/stock/presentation/widgets/stock_auth_gate.dart';

class MySensitivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StockAuthGate(
      onAuthSuccess: () {
        // Optional callback when authentication succeeds
        print('User authenticated!');
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Sensitive Data')),
        body: YourProtectedContent(),
      ),
    );
  }
}
```

### Manual Authentication Check

```dart
final authService = StockBiometricAuthService();

// Check if biometric is available
bool canUseBiometric = await authService.isBiometricAvailable();

// Authenticate
final result = await authService.authenticateWithBiometrics();
if (result.success) {
  // Access granted
} else {
  // Show error: result.message
}

// Verify PIN
bool isValid = await authService.verifyPin('1234');
```

---

## License

Part of the BusinessTrack application. All rights reserved.

---

## Changelog

### v1.0.0 (2026-03-08)
- ✅ Initial implementation
- ✅ Biometric authentication (fingerprint, face, iris)
- ✅ 4-digit PIN verification
- ✅ First-time setup flow
- ✅ Flexible authentication (biometric OR PIN)
- ✅ Secure storage using FlutterSecureStorage
- ✅ Error handling and fallback mechanisms
- ✅ Integrated into all stock management pages
