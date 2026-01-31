import 'dart:io';

import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/core/services/storage/token_service.dart';
import 'package:businesstrack/features/users/data/datasources/user_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final IUserRemoteDatasourceProvider=Provider<IUserRemoteDatasource>((ref){
  return UserRemoteDatasource(
    apiClient:ref.read(apiClientProvider),
    tokenService:ref.read(tokenServiceProvider),
  );
});

class UserRemoteDatasource implements IUserRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  UserRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<String> uploadImage(File image) async {
    //c:asd/asd/image/jpg;
    final fileName = image.path.split('/').last;
    final formData = FormData.fromMap({
      'userImage': await MultipartFile.fromFile(image.path, filename: fileName),
    });

    //get token from token service
    final token = await _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.imageUploadPhoto,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['success'];
  }

  @override
  Future<String> uploadVideo(File video) async{ 
    final fileName = video.path.split('/').last;
    final formData = FormData.fromMap({
      'itemVideo': await MultipartFile.fromFile(video.path, filename: fileName),
    });

    //get token from token service
    final token = await _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadVideo,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['success'];
  }
}
