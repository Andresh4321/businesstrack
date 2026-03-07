import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:businesstrack/features/stock/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteStockParams extends Equatable {
  final String stockId;

  const DeleteStockParams({required this.stockId});

  @override
  List<Object?> get props => [stockId];
}

final deleteStockUsecaseProvider = Provider<DeleteStockUsecase>((ref) {
  final stockRepository = ref.read(stockRepositoryProvider);
  return DeleteStockUsecase(stockRepository: stockRepository);
});

class DeleteStockUsecase implements UsecasewithParams<bool, DeleteStockParams> {
  final IStockRepository _stockRepository;

  DeleteStockUsecase({required IStockRepository stockRepository})
    : _stockRepository = stockRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteStockParams params) {
    return _stockRepository.deleteStock(params.stockId);
  }
}
