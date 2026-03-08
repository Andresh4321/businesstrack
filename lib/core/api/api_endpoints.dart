import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Set true when running on a physical phone on the same LAN as the backend.
  static const bool isPhysicalDevice = true;
  static const String computerIpAddress = '192.168.1.10';

  /// Dynamically returns the base URL based on platform and device type
  /// - Physical Device: Uses computer's local network IP
  /// - Android Emulator: Uses 10.0.2.2 (special alias to host machine)
  /// - iOS Simulator: Uses localhost
  /// - Web: Uses localhost
  static String get baseUrl {
    if (isPhysicalDevice) {
      return 'http://$computerIpAddress:5000';
    }
    // For development environment (emulator/simulator)
    if (kIsWeb) {
      return 'http://localhost:5000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000';
    } else if (Platform.isIOS) {
      return 'http://localhost:5000';
    } else {
      return 'http://localhost:5000';
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth Endpoints ============
  static const String authLogin = '/api/auth/login';
  static const String authRegister = '/api/auth/register';
  static const String authAdminLogin = '/api/auth/admin/login';
  static const String authWhoAmI = '/api/auth/whoami';
  static String authUpdateProfile(String id) => '/api/auth/$id';
  static const String authUploadPhoto = '/api/auth/upload-photo';
  static const String authForgotPassword = '/api/auth/forgot-password';
  static String authResetPassword(String token) =>
      '/api/auth/reset-password/$token';

  // ============ Material Endpoints ============
  static const String materials = '/api/materials';
  static String materialById(String id) => '/api/materials/$id';
  static String materialCreate = '/api/materials';
  static String materialUpdate(String id) => '/api/materials/$id';
  static String materialDelete(String id) => '/api/materials/$id';

  // ============ Stock Endpoints ============
  static const String stock = '/api/stock';
  static const String stockCurrent = '/api/stock/current';
  static String stockById(String id) => '/api/stock/$id';
  static String stockCreate = '/api/stock';
  static String stockUpdate(String id) => '/api/stock/$id';
  static String stockDelete(String id) => '/api/stock/$id';

  // ============ Bill of Materials Endpoints ============
  static const String billOfMaterials = '/api/bill-of-materials';
  static String billOfMaterialsById(String id) => '/api/bill-of-materials/$id';
  static String billOfMaterialsCreate = '/api/bill-of-materials';
  static String billOfMaterialsChangePrice(String id) =>
      '/api/bill-of-materials/$id/price';
  static String billOfMaterialsDelete(String id) =>
      '/api/bill-of-materials/$id';

  // ============ Recipe/Ingredients Endpoints ============
  static const String recipes = '/api/recipes';
  static String recipeById(String id) => '/api/recipes/$id';
  static String recipeCreate = '/api/recipes';
  static String recipeDelete(String id) => '/api/recipes/$id';

  // ============ Production Endpoints ============
  static const String production = '/api/production';
  static String productionById(String id) => '/api/production/$id';
  static String productionCreate = '/api/production';
  static String productionComplete(String id) => '/api/production/$id/complete';
  static String productionDelete(String id) => '/api/production/$id';

  // ============ Supplier Endpoints ============
  static const String suppliers = '/api/suppliers';
  static String supplierById(String id) => '/api/suppliers/$id';
  static String supplierCreate = '/api/suppliers';
  static String supplierUpdate(String id) => '/api/suppliers/$id';
  static String supplierDelete(String id) => '/api/suppliers/$id';
  // ============ Admin User Endpoints ============
  static const String adminUsers = '/api/admin/users';
  static String adminUserById(String id) => '/api/admin/users/$id';
  static String adminUserCreate = '/api/admin/users';
  static String adminUserUpdate(String id) => '/api/admin/users/$id';
  static String adminUserImage(String id) => '/api/admin/users/$id/image';
  static String adminUserDelete(String id) => '/api/admin/users/$id';

  // ============ Static File Endpoints ============
  static const String uploadedFiles = '/uploads';
  static const String itemPhotos = '/items/photos';

  // ============ Messaging Endpoints ============
  static const String messages = '/api/messages';
  static const String messagesCheckUser = '/api/messages/check-user';
  static const String messagesConversation = '/api/messages/conversation';
  static const String messagesSend = '/api/messages/send';
  static const String messagesUnreadCount = '/api/messages/count/unread';
  static const String messagesNotifications =
      '/api/messages/notifications/list';
  static String messagesByConversationId(String conversationId) =>
      '/api/messages/$conversationId';
}
