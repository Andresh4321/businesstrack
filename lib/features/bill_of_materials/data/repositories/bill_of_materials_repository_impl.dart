import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/services/connectivity/network_info.dart';
import 'package:businesstrack/features/bill_of_materials/data/datasource/bill_of_materials_datasource.dart';
import 'package:businesstrack/features/bill_of_materials/data/datasource/remote/bill_of_materials_remote_datasource.dart';
import 'package:businesstrack/features/bill_of_materials/data/models/bill_of_materials_model.dart';
import 'package:businesstrack/features/bill_of_materials/domain/entities/bill_of_materials_entity.dart';
import 'package:businesstrack/features/bill_of_materials/domain/repository/bill_of_materials_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final billOfMaterialsRepositoryProvider = Provider<IBillOfMaterialsRepository>((
  ref,
) {
  final billOfMaterialsRemoteDatasource = ref.read(
    billOfMaterialsRemoteProvider,
  );
  final networkInfo = ref.read(networkInfoProvider);

  return BillOfMaterialsRepository(
    billOfMaterialsRemoteDatasource: billOfMaterialsRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class BillOfMaterialsRepository implements IBillOfMaterialsRepository {
  final IBillOfMaterialsRemoteDataSource _billOfMaterialsRemoteDatasource;
  final NetworkInfo _networkInfo;

  BillOfMaterialsRepository({
    required IBillOfMaterialsRemoteDataSource billOfMaterialsRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _billOfMaterialsRemoteDatasource = billOfMaterialsRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<BillOfMaterialsEntity>>> getAllBillItems() async {
    if (await _networkInfo.isConnected) {
      try {
        final materials = await _billOfMaterialsRemoteDatasource
            .getAllBillItems();
        return Right(materials.map((e) => e.toEntity()).toList());
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data['message'] ?? 'Failed to fetch bill items',
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      return const Left(Apifailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BillOfMaterialsEntity>> createBillItem(
    BillOfMaterialsEntity entity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = BillOfMaterialsModel.fromEntity(entity);
        final result = await _billOfMaterialsRemoteDatasource.createBillItem(
          model,
        );
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data['message'] ?? 'Failed to create bill item',
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      return const Left(Apifailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BillOfMaterialsEntity>> updatePrice(
    String billId,
    double price,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _billOfMaterialsRemoteDatasource.updatePrice(
          billId,
          price,
        );
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? 'Failed to update price',
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      return const Left(Apifailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBillItem(String billId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _billOfMaterialsRemoteDatasource.deleteBillItem(billId);
        return const Right(null);
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data['message'] ?? 'Failed to delete bill item',
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      return const Left(Apifailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BillOfMaterialsEntity>> getBillItemById(
    String billId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _billOfMaterialsRemoteDatasource.getBillItemById(
          billId,
        );
        if (result != null) {
          return Right(result.toEntity());
        }
        return const Left(Apifailure(message: 'Bill item not found'));
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? 'Failed to fetch bill item',
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      return const Left(Apifailure(message: 'No internet connection'));
    }
  }
}
