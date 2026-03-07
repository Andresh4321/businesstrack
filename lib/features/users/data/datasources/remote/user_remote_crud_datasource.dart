import 'dart:io';

import 'package:businesstrack/features/users/data/datasources/datasource_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Remote datasource used by the legacy CRUD-style users feature.
///
/// Only the image upload API is referenced by the legacy repository today.
abstract class IUserRemoteDatasource {
  Future<String> uploadImage(File image);
}

// Legacy code expects this exact provider identifier.
final IUserRemoteDatasourceProvider = Provider<IUserRemoteDatasource>((ref) {
  final dio = ref.read(dioProvider);
  return UserRemoteCrudDatasource(dio: dio);
});

class UserRemoteCrudDatasource implements IUserRemoteDatasource {
  final Dio dio;

  UserRemoteCrudDatasource({required this.dio});

  @override
  Future<String> uploadImage(File image) async {
    // Best-effort implementation: keep compile-safe even if backend differs.
    final fileName = image.path.split(Platform.pathSeparator).last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path, filename: fileName),
    });

    final response = await dio.post('/api/uploads', data: formData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      if (data is Map && data['fileName'] is String)
        return data['fileName'] as String;
      if (data is Map && data['filename'] is String)
        return data['filename'] as String;
      if (data is Map &&
          data['data'] is Map &&
          (data['data']['fileName'] is String)) {
        return data['data']['fileName'] as String;
      }
      return fileName;
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      message: 'Upload failed (${response.statusCode})',
    );
  }
}
