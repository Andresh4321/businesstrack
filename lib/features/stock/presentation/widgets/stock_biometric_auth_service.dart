import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Biometric authentication service specifically for Stock Management
/// Handles fingerprint/face recognition and 4-digit PIN verification
class StockBiometricAuthService {
  static final StockBiometricAuthService _instance =
      StockBiometricAuthService._internal();

  factory StockBiometricAuthService() => _instance;

  StockBiometricAuthService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _pinKey = 'stock_management_pin';
  static const String _firstTimeKey = 'stock_management_first_time';

  /// Check if biometric authentication is available on device
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
      return canAuthenticate;
    } catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Authenticate using biometrics (fingerprint/face)
  Future<BiometricAuthResult> authenticateWithBiometrics() async {
    try {
      final bool canAuthenticate = await isBiometricAvailable();

      if (!canAuthenticate) {
        return BiometricAuthResult(
          success: false,
          message: 'Biometric authentication not available on this device',
          errorCode: BiometricErrorCode.notAvailable,
        );
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Stock Management',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );

      if (didAuthenticate) {
        return BiometricAuthResult(
          success: true,
          message: 'Authentication successful',
        );
      } else {
        return BiometricAuthResult(
          success: false,
          message: 'Authentication failed',
          errorCode: BiometricErrorCode.authenticationFailed,
        );
      }
    } on PlatformException catch (e) {
      String message;
      BiometricErrorCode errorCode;

      if (e.code == auth_error.notAvailable) {
        message = 'Biometric authentication not available';
        errorCode = BiometricErrorCode.notAvailable;
      } else if (e.code == auth_error.notEnrolled) {
        message =
            'No biometrics enrolled. Please set up biometrics in device settings';
        errorCode = BiometricErrorCode.notEnrolled;
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        message = 'Too many failed attempts. Please try PIN instead';
        errorCode = BiometricErrorCode.lockedOut;
      } else {
        message = 'Authentication error: ${e.message}';
        errorCode = BiometricErrorCode.other;
      }

      return BiometricAuthResult(
        success: false,
        message: message,
        errorCode: errorCode,
      );
    } catch (e) {
      return BiometricAuthResult(
        success: false,
        message: 'Unexpected error: $e',
        errorCode: BiometricErrorCode.other,
      );
    }
  }

  /// Check if this is the first time accessing stock management
  Future<bool> isFirstTime() async {
    final String? value = await _secureStorage.read(key: _firstTimeKey);
    return value == null;
  }

  /// Mark that initial setup is complete
  Future<void> markSetupComplete() async {
    await _secureStorage.write(key: _firstTimeKey, value: 'true');
  }

  /// Set up a new 4-digit PIN
  Future<bool> setupPin(String pin) async {
    if (!_isValidPin(pin)) {
      return false;
    }

    try {
      await _secureStorage.write(key: _pinKey, value: pin);
      await markSetupComplete();
      return true;
    } catch (e) {
      print('Error saving PIN: $e');
      return false;
    }
  }

  /// Verify the entered PIN
  Future<bool> verifyPin(String pin) async {
    if (!_isValidPin(pin)) {
      return false;
    }

    try {
      final String? storedPin = await _secureStorage.read(key: _pinKey);
      return storedPin == pin;
    } catch (e) {
      print('Error verifying PIN: $e');
      return false;
    }
  }

  /// Check if a PIN has been set
  Future<bool> hasPinSet() async {
    try {
      final String? pin = await _secureStorage.read(key: _pinKey);
      return pin != null && pin.isNotEmpty;
    } catch (e) {
      print('Error checking PIN: $e');
      return false;
    }
  }

  /// Reset PIN (requires biometric authentication first)
  Future<bool> resetPin() async {
    try {
      await _secureStorage.delete(key: _pinKey);
      await _secureStorage.delete(key: _firstTimeKey);
      return true;
    } catch (e) {
      print('Error resetting PIN: $e');
      return false;
    }
  }

  /// Validate PIN format (must be 4 digits)
  bool _isValidPin(String pin) {
    return pin.length == 4 && RegExp(r'^\d{4}$').hasMatch(pin);
  }

  /// Get biometric type name for display
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face Recognition';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris Scan';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
    }
  }
}

/// Result of biometric authentication attempt
class BiometricAuthResult {
  final bool success;
  final String message;
  final BiometricErrorCode? errorCode;

  BiometricAuthResult({
    required this.success,
    required this.message,
    this.errorCode,
  });
}

/// Error codes for biometric authentication
enum BiometricErrorCode {
  notAvailable,
  notEnrolled,
  lockedOut,
  authenticationFailed,
  other,
}
