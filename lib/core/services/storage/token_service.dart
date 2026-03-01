import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// provider
final tokenServiceProvider = Provider<TokenService>((ref) {
  return const TokenService();
});

class TokenService {
  static const String _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage;

  const TokenService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  // Save token: secure storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Get token
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  // Remove token (for logout)
  Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
