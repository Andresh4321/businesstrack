import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/auth/domain/usecases/login_usecase.dart';
import 'package:businesstrack/features/auth/domain/usecases/register_usecase.dart';
import 'package:businesstrack/features/low_stock_alert/domain/usecases/check_low_stock_items_usecase.dart';
import 'package:businesstrack/features/low_stock_alert/domain/usecases/get_critical_stock_items_usecase.dart';
import 'package:businesstrack/features/low_stock_alert/domain/usecases/get_low_stock_items_usecase.dart';
import 'package:businesstrack/features/low_stock_alert/domain/usecases/resolve_alert_usecase.dart';
import 'package:businesstrack/features/material/domain/usecases/add_material_usecase.dart';
import 'package:businesstrack/features/production/domain/usecases/start_production_usecase.dart';
import 'package:businesstrack/features/recipe/domain/usecases/create_recipe_usecase.dart';
import 'package:businesstrack/features/report/domain/usecases/generate_production_summary_report_usecase.dart';
import 'package:businesstrack/features/report/domain/usecases/generate_stock_summary_report_usecase.dart';
import 'package:businesstrack/features/stock/domain/usecases/update_stock_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_fakes.dart';

void main() {
  group('Usecases', () {
    test('1) LoginUsecase returns auth entity on success', () async {
      final repo = FakeAuthRepository()
        ..loginResult = Right(sampleAuthEntity());
      final usecase = LoginUsecase(authRepository: repo);

      final result = await usecase(
        const LoginUsecaseParams(email: 'test@example.com', password: 'secret'),
      );

      expect(result.isRight(), isTrue);
      expect(repo.lastLoginEmail, 'test@example.com');
    });

    test('2) LoginUsecase returns failure on error', () async {
      final repo = FakeAuthRepository()
        ..loginResult = Left(const Apifailure(message: 'Invalid credentials'));
      final usecase = LoginUsecase(authRepository: repo);

      final result = await usecase(
        const LoginUsecaseParams(email: 'bad@example.com', password: 'bad'),
      );

      expect(result.isLeft(), isTrue);
    });

    test('3) RegisterUsecase maps params to entity', () async {
      final repo = FakeAuthRepository();
      final usecase = RegisterUsecase(authRepository: repo);

      final result = await usecase(
        const RegisterUsecaseParams(
          fullName: 'Jane Doe',
          email: 'jane@example.com',
          phoneNumber: '9800000000',
          password: 'pass123',
          confirmPassword: 'pass123',
        ),
      );

      expect(result.isRight(), isTrue);
      expect(repo.lastRegistered?.fullName, 'Jane Doe');
      expect(repo.lastRegistered?.email, 'jane@example.com');
    });

    test('4) RegisterUsecase returns failure from repository', () async {
      final repo = FakeAuthRepository()
        ..registerResult = Left(const Apifailure(message: 'Email exists'));
      final usecase = RegisterUsecase(authRepository: repo);

      final result = await usecase(
        const RegisterUsecaseParams(
          fullName: 'Jane Doe',
          email: 'jane@example.com',
          password: 'pass123',
        ),
      );

      expect(result.isLeft(), isTrue);
    });

    test(
      '5) AddMaterialUsecase applies defaults for optional fields',
      () async {
        final repo = FakeMaterialRepository();
        final usecase = AddMaterialUsecase(materialRepository: repo);

        await usecase(const AddMaterialParams(name: 'Eggs'));

        expect(repo.lastAdded?.name, 'Eggs');
        expect(repo.lastAdded?.unit, '');
        expect(repo.lastAdded?.unitPrice, 0.0);
        expect(repo.lastAdded?.quantity, 0.0);
        expect(repo.lastAdded?.minimumStock, 0.0);
      },
    );

    test('6) AddMaterialUsecase returns failure from repository', () async {
      final repo = FakeMaterialRepository()
        ..addResult = Left(const Apifailure(message: 'Add failed'));
      final usecase = AddMaterialUsecase(materialRepository: repo);

      final result = await usecase(const AddMaterialParams(name: 'Eggs'));

      expect(result.isLeft(), isTrue);
    });

    test('7) CreateRecipeUsecase maps materials and quantities', () async {
      final repo = FakeRecipeRepository();
      final usecase = CreateRecipeUsecase(recipeRepository: repo);

      await usecase(
        const CreateRecipeParams(
          name: 'Cake',
          materials: ['Flour', 'Sugar'],
          quantities: [2, 1],
        ),
      );

      expect(repo.lastCreated?.ingredients.length, 2);
      expect(repo.lastCreated?.ingredients.first.quantity, 2.0);
      expect(repo.lastCreated?.ingredients.last.materialId, 'Sugar');
    });

    test('8) CreateRecipeUsecase fills missing quantity with zero', () async {
      final repo = FakeRecipeRepository();
      final usecase = CreateRecipeUsecase(recipeRepository: repo);

      await usecase(
        const CreateRecipeParams(
          name: 'Bread',
          materials: ['Flour', 'Yeast'],
          quantities: [3],
        ),
      );

      expect(repo.lastCreated?.ingredients[1].quantity, 0.0);
    });

    test('9) UpdateStockUsecase maps defaults correctly', () async {
      final repo = FakeStockRepository();
      final usecase = UpdateStockUsecase(stockRepository: repo);

      await usecase(const UpdateStockParams(stockId: 's1'));

      expect(repo.lastUpdated?.stockId, 's1');
      expect(repo.lastUpdated?.materialId, '');
      expect(repo.lastUpdated?.quantity, 0.0);
      expect(repo.lastUpdated?.transactionType, 'in');
    });

    test(
      '10) UpdateStockUsecase returns failure on repository error',
      () async {
        final repo = FakeStockRepository()
          ..updateResult = Left(const Apifailure(message: 'Update failed'));
        final usecase = UpdateStockUsecase(stockRepository: repo);

        final result = await usecase(const UpdateStockParams(stockId: 's1'));

        expect(result.isLeft(), isTrue);
      },
    );

    test(
      '11) StartProductionUsecase uses quantity as fallback output',
      () async {
        final repo = FakeProductionRepository();
        final usecase = StartProductionUsecase(productionRepository: repo);

        await usecase(
          const StartProductionParams(recipeId: 'r1', quantity: 12),
        );

        expect(repo.lastStarted?.batchQuantity, 12.0);
        expect(repo.lastStarted?.estimatedOutput, 12.0);
        expect(repo.lastStarted?.status, 'ongoing');
      },
    );

    test('12) StartProductionUsecase uses explicit estimatedOutput', () async {
      final repo = FakeProductionRepository();
      final usecase = StartProductionUsecase(productionRepository: repo);

      await usecase(
        const StartProductionParams(
          recipeId: 'r1',
          quantity: 12,
          estimatedOutput: 10.5,
        ),
      );

      expect(repo.lastStarted?.estimatedOutput, 10.5);
    });

    test('13) GetLowStockItemsUsecase returns low stock items', () async {
      final repo = FakeLowStockItemsRepository();
      final usecase = GetLowStockItemsUsecase(repo);

      final result = await usecase();

      expect(result.isRight(), isTrue);
    });

    test(
      '14) GetLowStockItemsUsecase returns failure when repository fails',
      () async {
        final repo = FakeLowStockItemsRepository()
          ..lowItemsResult = Left(const Apifailure(message: 'No items'));
        final usecase = GetLowStockItemsUsecase(repo);

        final result = await usecase();

        expect(result.isLeft(), isTrue);
      },
    );

    test('15) GetCriticalStockItemsUsecase returns critical items', () async {
      final repo = FakeLowStockItemsRepository();
      final usecase = GetCriticalStockItemsUsecase(repo);

      final result = await usecase();

      expect(result.isRight(), isTrue);
    });

    test(
      '16) GetCriticalStockItemsUsecase returns failure on repository error',
      () async {
        final repo = FakeLowStockItemsRepository()
          ..criticalItemsResult = Left(
            const Apifailure(message: 'Critical failed'),
          );
        final usecase = GetCriticalStockItemsUsecase(repo);

        final result = await usecase();

        expect(result.isLeft(), isTrue);
      },
    );

    test('17) CheckLowStockItemsUseCase delegates to repository', () async {
      final repo = FakeLowStockAlertsRepository();
      final usecase = CheckLowStockItemsUseCase(repo);

      final result = await usecase();

      expect(result.isRight(), isTrue);
    });

    test('18) ResolveAlertUseCase passes alert id and resolver', () async {
      final repo = FakeLowStockAlertsRepository();
      final usecase = ResolveAlertUseCase(repo);

      final result = await usecase('alert-1', 'admin');

      expect(result, const Right(true));
      expect(repo.lastResolvedId, 'alert-1');
      expect(repo.lastResolvedBy, 'admin');
    });

    test('19) GenerateStockSummaryReportUsecase returns report', () async {
      final repo = FakeReportRepository();
      final usecase = GenerateStockSummaryReportUsecase(repo);

      final result = await usecase();

      expect(result.isRight(), isTrue);
    });

    test(
      '20) GenerateProductionSummaryReportUsecase returns failure path',
      () async {
        final repo = FakeReportRepository()
          ..productionSummaryResult = Left(
            const Apifailure(message: 'Generation failed'),
          );
        final usecase = GenerateProductionSummaryReportUsecase(repo);

        final result = await usecase();

        expect(result.isLeft(), isTrue);
      },
    );
  });
}
