import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/features/report/data/models/report_model.dart';
import 'package:businesstrack/features/report/data/datasources/remote/report_remote_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportRemoteProvider = Provider<IReportRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ReportRemoteDataSource(apiClient: apiClient);
});

class ReportRemoteDataSource implements IReportRemoteDataSource {
  final ApiClient _apiClient;

  ReportRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<ReportModel>> getAllReports() async {
    try {
      final response = await _apiClient.get('/reports');

      final reports = (response.data as List)
          .map((json) => ReportModel.fromJson(json))
          .toList();

      return reports;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReportModel> getReportById(String reportId) async {
    try {
      final response = await _apiClient.get('/reports/$reportId');

      return ReportModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReportModel> generateReport({
    required String title,
    required String type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _apiClient.post(
        '/reports/generate',
        data: {
          'title': title,
          'type': type,
          if (startDate != null) 'startDate': startDate.toIso8601String(),
          if (endDate != null) 'endDate': endDate.toIso8601String(),
        },
      );

      return ReportModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteReport(String reportId) async {
    try {
      await _apiClient.delete('/reports/$reportId');

      return true;
    } catch (e) {
      rethrow;
    }
  }
}
