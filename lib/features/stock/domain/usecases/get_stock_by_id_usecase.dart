import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:businesstrack/features/stock/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetStockByIdParams extends Equatable {
  final String stockId;

  const GetStockByIdParams({required this.stockId});

  @override
  List<Object?> get props => [stockId];
}

final getStockByIdUsecaseProvider = Provider<GetStockByIdUsecase>((ref) {
  final stockRepository = ref.read(stockRepositoryProvider);
  return GetStockByIdUsecase(stockRepository: stockRepository);
});

class GetStockByIdUsecase
    implements UsecasewithParams<StockEntity, GetStockByIdParams> {
  final IStockRepository _stockRepository;

  GetStockByIdUsecase({required IStockRepository stockRepository})
    : _stockRepository = stockRepository;

  @override
  Future<Either<Failure, StockEntity>> call(GetStockByIdParams params) {
    return _stockRepository.getStockById(params.stockId);
  }
}
