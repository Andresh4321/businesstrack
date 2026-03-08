import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'stock_biometric_auth_service.dart';

/// Authentication gate for Stock Management
/// Requires biometric + PIN on first access, then either method afterwards
class StockAuthGate extends StatefulWidget {
  final Widget child;
  final VoidCallback? onAuthSuccess;

  const StockAuthGate({super.key, required this.child, this.onAuthSuccess});

  @override
  State<StockAuthGate> createState() => _StockAuthGateState();
}

class _StockAuthGateState extends State<StockAuthGate> {
  final StockBiometricAuthService _authService = StockBiometricAuthService();
  bool _isAuthenticated = false;
  bool _isLoading = true;
  bool _isFirstTime = false;
  bool _isBiometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];

  // Setup state
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _isSettingUp = false;
  String _setupError = '';

  // Auth state
  final TextEditingController _authPinController = TextEditingController();
  bool _showPinAuth = false;
  String _authError = '';
  int _attemptCount = 0;
  static const int _maxAttempts = 3;
  bool _biometricInProgress = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _authPinController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    setState(() => _isLoading = true);

    try {
      final isFirstTime = await _authService.isFirstTime();
      final isBiometricAvailable = await _authService.isBiometricAvailable();
      final availableBiometrics = await _authService.getAvailableBiometrics();

      setState(() {
        _isFirstTime = isFirstTime;
        _isBiometricAvailable = isBiometricAvailable;
        _availableBiometrics = availableBiometrics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Initialization error: $e');
    }
  }

  Future<void> _setupInitialAuth() async {
    final pin = _pinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    // Validate PIN
    if (pin.isEmpty || confirmPin.isEmpty) {
      setState(() => _setupError = 'Please enter a 4-digit PIN');
      return;
    }

    if (pin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin)) {
      setState(() => _setupError = 'PIN must be exactly 4 digits');
      return;
    }

    if (pin != confirmPin) {
      setState(() => _setupError = 'PINs do not match');
      return;
    }

    setState(() {
      _isSettingUp = true;
      _setupError = '';
    });

    try {
      // Save PIN first
      final pinSaved = await _authService.setupPin(pin);
      if (!pinSaved) {
        setState(() {
          _setupError = 'Failed to save PIN. Please try again.';
          _isSettingUp = false;
        });
        return;
      }

      // If biometric is available, try to authenticate
      if (_isBiometricAvailable) {
        final result = await _authService.authenticateWithBiometrics();
        if (result.success) {
          _onAuthenticationSuccess();
        } else {
          // Biometric failed but PIN is set, allow access
          setState(
            () => _setupError =
                'Biometric setup failed, but you can use PIN. ${result.message}',
          );
          _onAuthenticationSuccess();
        }
      } else {
        // No biometric, but PIN is set
        _onAuthenticationSuccess();
      }
    } catch (e) {
      setState(() {
        _setupError = 'Setup error: $e';
        _isSettingUp = false;
      });
    }
  }

  Future<void> _authenticateWithBiometric() async {
    if (!_isBiometricAvailable) {
      setState(() => _showPinAuth = true);
      return;
    }

    setState(() {
      _biometricInProgress = true;
      _authError = '';
    });

    final result = await _authService.authenticateWithBiometrics();

    setState(() => _biometricInProgress = false);

    if (result.success) {
      _onAuthenticationSuccess();
    } else {
      setState(() {
        _authError = result.message;
      });
    }
  }

  Future<void> _authenticateWithPin() async {
    final pin = _authPinController.text.trim();

    if (pin.length != 4) {
      setState(() => _authError = 'PIN must be 4 digits');
      return;
    }

    final isValid = await _authService.verifyPin(pin);

    if (isValid) {
      _onAuthenticationSuccess();
    } else {
      _attemptCount++;

      if (_attemptCount >= _maxAttempts) {
        setState(() {
          _authError =
              'Too many failed attempts. Please try biometric authentication.';
          _showPinAuth = false;
          _attemptCount = 0;
        });
        _authPinController.clear();
      } else {
        setState(() {
          _authError =
              'Incorrect PIN. ${_maxAttempts - _attemptCount} attempts remaining.';
        });
        _authPinController.clear();
      }
    }
  }

  void _onAuthenticationSuccess() {
    setState(() {
      _isAuthenticated = true;
      _authError = '';
      _setupError = '';
    });
    widget.onAuthSuccess?.call();
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  String _getBiometricIcon() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return '👤';
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return '👆';
    }
    return '🔐';
  }

  String _getBiometricName() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    }
    return 'Biometric';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing security...'),
            ],
          ),
        ),
      );
    }

    if (_isAuthenticated) {
      return widget.child;
    }

    if (_isFirstTime) {
      return _buildSetupScreen();
    }

    return _buildAuthScreen();
  }

  Widget _buildSetupScreen() {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Management Security'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.security, size: 80, color: theme.primaryColor),
            SizedBox(height: 24),
            Text(
              'Secure Stock Management',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Stock management contains sensitive data. Please set up security to continue.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),

            // Biometric info
            if (_isBiometricAvailable) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Text(_getBiometricIcon(), style: TextStyle(fontSize: 32)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getBiometricName()} Available',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                          ),
                          Text(
                            'You can use ${_getBiometricName().toLowerCase()} for quick access',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],

            // PIN setup
            Text(
              'Create 4-Digit PIN',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This PIN will be required along with ${_isBiometricAvailable ? "biometric or as an " : ""}alternative authentication method.',
              style: theme.textTheme.bodySmall,
            ),
            SizedBox(height: 16),

            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: 'Enter PIN',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                counterText: '',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
            ),
            SizedBox(height: 16),

            TextField(
              controller: _confirmPinController,
              decoration: InputDecoration(
                labelText: 'Confirm PIN',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
                counterText: '',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onSubmitted: (_) => _setupInitialAuth(),
            ),

            if (_setupError.isNotEmpty) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _setupError,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSettingUp ? null : _setupInitialAuth,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSettingUp
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Set Up Security'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthScreen() {
    final theme = Theme.of(context);

    if (!_showPinAuth && _isBiometricAvailable) {
      return _buildBiometricAuthScreen(theme);
    } else {
      return _buildPinAuthScreen(theme);
    }
  }

  Widget _buildBiometricAuthScreen(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Management'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2, size: 80, color: theme.primaryColor),
              SizedBox(height: 24),
              Text(
                'Authentication Required',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please authenticate to access stock management',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Primary: Fingerprint/Face Button
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor.withOpacity(0.9),
                      theme.primaryColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _biometricInProgress
                      ? null
                      : _authenticateWithBiometric,
                  icon: _biometricInProgress
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(
                          _availableBiometrics.contains(BiometricType.face)
                              ? Icons.face
                              : Icons.fingerprint,
                          size: 32,
                        ),
                  label: Text(
                    'Use ${_getBiometricName()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Secondary: Switch to PIN
              TextButton.icon(
                onPressed: _biometricInProgress
                    ? null
                    : () => setState(() {
                        _showPinAuth = true;
                        _authError = '';
                        _authPinController.clear();
                        _attemptCount = 0;
                      }),
                icon: Icon(Icons.lock),
                label: Text('Use PIN Instead'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
              ),

              // Error message
              if (_authError.isNotEmpty) ...[
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          _authError,
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinAuthScreen(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Management'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 80, color: theme.primaryColor),
              SizedBox(height: 24),
              Text(
                'Enter PIN',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Enter your 4-digit PIN to continue',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // PIN Input Field
              SizedBox(
                width: 220,
                child: TextField(
                  controller: _authPinController,
                  decoration: InputDecoration(
                    labelText: 'PIN',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.pin),
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, letterSpacing: 12),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  onSubmitted: (_) => _authenticateWithPin(),
                ),
              ),
              SizedBox(height: 24),

              // Verify Button
              ElevatedButton(
                onPressed: _authenticateWithPin,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Verify PIN',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 24),

              // Back to Fingerprint (if available)
              if (_isBiometricAvailable)
                TextButton.icon(
                  onPressed: () => setState(() {
                    _showPinAuth = false;
                    _authError = '';
                    _authPinController.clear();
                    _attemptCount = 0;
                  }),
                  icon: Icon(
                    _availableBiometrics.contains(BiometricType.face)
                        ? Icons.face
                        : Icons.fingerprint,
                  ),
                  label: Text('Use ${_getBiometricName()} Instead'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                ),

              // Error message
              if (_authError.isNotEmpty) ...[
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          _authError,
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
