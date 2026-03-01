import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://10.0.2.2:5000';
  // Base URL - change this for production
  // For Android Emulator use: 'http://10.0.2.2:5000'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000'
  // For iOS Simulator use: 'http://localhost:5000'

  // static const String baseUrl = 'http://192.168.1.27:5000/api/v1';

  //  static const bool isPysicalDevice = false;

  // static const String compIpAddress = "192.168.1.1";

  // static String get baseURl {
  //   if (isPysicalDevice) {
  //     return 'http://$compIpAddress:5000/api/v1';
  //     }
  //    // yadi andriod
  //    if(KisWeb){
  //     return "http:/localhost:3000/api/v1";
  //    }else if(Platform.isAndriod){
  //     return 'http://10.0.2.2:3000/api/v1';
  //    }
  //    else if(Platform.isAndriod){
  //     return 'http://localhost:3000/api/v1';
  //   }else{
  //  return 'http://localhost:3000/api/v1';
  //   }

  //

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
}
