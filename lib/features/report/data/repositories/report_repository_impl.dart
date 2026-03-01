import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/services/connectivity/network_info.dart';
import 'package:businesstrack/features/report/data/datasources/local/report_local_datasource.dart';
import 'package:businesstrack/features/report/data/datasources/remote/report_remote_datasource.dart';
import 'package:businesstrack/features/report/data/datasources/remote/report_remote_datasource_impl.dart';
import 'package:businesstrack/features/report/data/datasources/report_datasource.dart';
import 'package:businesstrack/features/report/data/models/report_model.dart';
import 'package:businesstrack/features/report/domain/entities/report_entity.dart';
import 'package:businesstrack/features/report/domain/repositories/report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportRepositoryProvider = Provider<IReportRepository>((ref) {
  final reportLocalDatasource = ref.read(reportLocalDatasourceProvider);
  final reportRemoteDatasource = ref.read(reportRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return ReportRepositoryImpl(
    reportLocalDatasource: reportLocalDatasource,
    reportRemoteDatasource: reportRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class ReportRepositoryImpl implements IReportRepository {
  final IReportDataSource _reportLocalDatasource;
  final IReportRemoteDataSource _reportRemoteDatasource;
  final NetworkInfo _networkInfo;

  ReportRepositoryImpl({
    required IReportDataSource reportLocalDatasource,
    required IReportRemoteDataSource reportRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _reportLocalDatasource = reportLocalDatasource,
       _reportRemoteDatasource = reportRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<ReportEntity>>> getAllReports() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _reportRemoteDatasource.getAllReports();

        // Cache reports locally
        for (var report in result) {
          await _reportLocalDatasource.saveReport(report);
        }

        return Right(ReportModel.toEntityList(result));
      } on DioException catch (e) {
        return Left(
          ApiFailure(message: e.message ?? 'Failed to fetch reports'),
        );
      }
    } else {
      try {
        final result = await _reportLocalDatasource.getAllReports();
        return Right(ReportModel.toEntityList(result));
      } catch (e) {
        return Left(CacheFailure(message: 'Failed to load reports from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, ReportEntity>> getReportById(String reportId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _reportRemoteDatasource.getReportById(reportId);
        await _reportLocalDatasource.saveReport(result);
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(ApiFailure(message: e.message ?? 'Failed to fetch report'));
      }
    } else {
      try {
        final result = await _reportLocalDatasource.getReportById(reportId);
        return Right(result.toEntity());
      } catch (e) {
        return Left(CacheFailure(message: 'Failed to load report from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, ReportEntity>> generateReport({
    required String title,
    required String type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _reportRemoteDatasource.generateReport(
          title: title,
          type: type,
          startDate: startDate,
          endDate: endDate,
        );
        await _reportLocalDatasource.saveReport(result);
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(message: e.message ?? 'Failed to generate report'),
        );
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteReport(String reportId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _reportRemoteDatasource.deleteReport(reportId);
        await _reportLocalDatasource.deleteReport(reportId);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(message: e.message ?? 'Failed to delete report'),
        );
      }
    } else {
      try {
        final result = await _reportLocalDatasource.deleteReport(reportId);
        return Right(result);
      } catch (e) {
        return Left(
          CacheFailure(message: 'Failed to delete report from cache'),
        );
      }
    }
  }

  @override
  Future<Either<Failure, bool>> saveReport(ReportEntity report) async {
    try {
      final model = ReportModel.fromEntity(report);
      final result = await _reportLocalDatasource.saveReport(model);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to save report'));
    }
  }
}
