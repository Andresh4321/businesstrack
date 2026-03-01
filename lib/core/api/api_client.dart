import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_AuthInterceptor());

    // Auto retry on network failures
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryEvaluator: (error, attempt) {
          // Retry on connection errors and timeouts, not on 4xx/5xx
          return error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError;
        },
      ),
    );

    // Only add logger in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Multipart request for file uploads
  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    return _dio.post(
      path,
      data: formData,
      options: options,
      onSendProgress: onSendProgress,
    );
  }
}

/// Auth Interceptor to add JWT token to requests and handle token expiration
class _AuthInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  /// Public endpoints that don't require authentication
  static const List<String> _publicEndpoints = [
    '/api/auth/login',
    '/api/auth/register',
    '/api/auth/admin/login',
    '/api/auth/forgot-password',
    // Routes matching '/api/auth/reset-password/*' are also public
  ];

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check if this is a public endpoint
    final isPublicEndpoint = _isPublicEndpoint(options.path);

    if (!isPublicEndpoint) {
      // Add token to protected endpoints
      final token = await _storage.read(key: _tokenKey);
      if (kDebugMode) {
        print('🔐 [AuthInterceptor] Endpoint: ${options.path}');
        print('🔐 [AuthInterceptor] Token exists: ${token != null}');
        if (token != null) {
          print('🔐 [AuthInterceptor] Token preview: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
        }
      }
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        if (kDebugMode) {
          print('⚠️ [AuthInterceptor] No token found for protected endpoint!');
        }
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token expired or invalid
    if (err.response?.statusCode == 401) {
      // Clear token from secure storage
      _storage.delete(key: _tokenKey);

      // TODO: Navigate to login screen
      // You can use a navigation callback or state management to redirect to login
      if (kDebugMode) {
        print('Token expired or invalid. Redirecting to login...');
      }
    }
    handler.next(err);
  }

  /// Check if endpoint is public (doesn't require authentication)
  static bool _isPublicEndpoint(String path) {
    // Check if path matches any public endpoint exact match
    if (_publicEndpoints.contains(path)) {
      return true;
    }

    // Check for reset-password dynamic endpoint
    if (path.contains('/api/auth/reset-password/')) {
      return true;
    }

    return false;
  }
}
