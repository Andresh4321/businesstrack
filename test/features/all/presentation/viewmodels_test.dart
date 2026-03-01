import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/auth/data/repositories/auth_repository.dart';
import 'package:businesstrack/features/auth/presentation/state/auth.state.dart';
import 'package:businesstrack/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:businesstrack/features/material/data/repositories/material_repository_impl.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/material/presentation/state/material_state.dart';
import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:businesstrack/features/production/data/repositories/production_repository_impl.dart';
import 'package:businesstrack/features/production/presentation/state/production_state.dart';
import 'package:businesstrack/features/production/presentation/viewmodel/production_viewmodel.dart';
import 'package:businesstrack/features/recipe/data/repositories/recipe_repository_impl.dart';
import 'package:businesstrack/features/recipe/presentation/state/recipe_state.dart';
import 'package:businesstrack/features/recipe/presentation/viewmodel/recipe_viewmodel.dart';
import 'package:businesstrack/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:businesstrack/features/stock/presentation/state/stock_state.dart';
import 'package:businesstrack/features/stock/presentation/viewmodel/stock_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_fakes.dart';

void main() {
  group('ViewModels', () {
    test('1) AuthViewModel starts with initial state', () {
      final repo = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.initial);
    });

    test('2) AuthViewModel register sets registered state', () async {
      final repo = FakeAuthRepository()..registerResult = const Right(true);
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .register(
            fullName: 'User',
            email: 'user@mail.com',
            username: 'user',
            password: '123456',
            confirmPassword: '123456',
          );

      expect(
        container.read(authViewModelProvider).status,
        AuthStatus.registered,
      );
    });

    test('3) AuthViewModel login sets authenticated state', () async {
      final repo = FakeAuthRepository()
        ..loginResult = Right(sampleAuthEntity());
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .login(email: 'user@mail.com', password: '123456');

      expect(
        container.read(authViewModelProvider).status,
        AuthStatus.authenticated,
      );
      expect(
        container.read(authViewModelProvider).authEntity?.email,
        'test@example.com',
      );
    });

    test('4) AuthViewModel login sets error state on failure', () async {
      final repo = FakeAuthRepository()
        ..loginResult = Left(const Apifailure(message: 'Invalid credentials'));
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .login(email: 'bad@mail.com', password: 'bad');

      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Invalid credentials');
    });

    test('5) MaterialViewModel starts with initial status', () {
      final materialRepo = FakeMaterialRepository();
      final stockRepo = FakeStockRepository();
      final container = ProviderContainer(
        overrides: [
          materialRepositoryProvider.overrideWithValue(materialRepo),
          stockRepositoryProvider.overrideWithValue(stockRepo),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(materialViewModelProvider).status,
        MaterialStatus.initial,
      );
    });

    test('6) MaterialViewModel addMaterial success becomes loaded', () async {
      final materialRepo = FakeMaterialRepository()
        ..addResult = const Right(true);
      final stockRepo = FakeStockRepository();
      final container = ProviderContainer(
        overrides: [
          materialRepositoryProvider.overrideWithValue(materialRepo),
          stockRepositoryProvider.overrideWithValue(stockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(materialViewModelProvider.notifier)
          .addMaterial(
            name: 'Sugar',
            unit: 'kg',
            unitPrice: 100,
            minimumStock: 2,
          );

      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(materialViewModelProvider).status,
        MaterialStatus.loaded,
      );
    });

    test('7) MaterialViewModel addMaterial failure becomes error', () async {
      final materialRepo = FakeMaterialRepository()
        ..addResult = Left(const Apifailure(message: 'Add material failed'));
      final stockRepo = FakeStockRepository();
      final container = ProviderContainer(
        overrides: [
          materialRepositoryProvider.overrideWithValue(materialRepo),
          stockRepositoryProvider.overrideWithValue(stockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(materialViewModelProvider.notifier)
          .addMaterial(name: 'Sugar', unit: 'kg');

      final state = container.read(materialViewModelProvider);
      expect(state.status, MaterialStatus.error);
      expect(state.errorMessage, 'Add material failed');
    });

    test(
      '8) MaterialViewModel aggregates stock quantities from transactions',
      () async {
        final materialRepo = FakeMaterialRepository()
          ..allResult = Right([
            const MaterialEntity(
              materialId: 'mat-1',
              name: 'Flour',
              unit: 'kg',
              unitPrice: 50,
              quantity: 0,
              minimumStock: 3,
            ),
          ]);
        final stockRepo = FakeStockRepository()
          ..allTxnResult = Right(
            [
                  const MaterialEntity(
                    materialId: 'mat-1',
                    name: 'Flour',
                    unit: 'kg',
                    unitPrice: 50,
                    quantity: 0,
                    minimumStock: 3,
                  ),
                ]
                .map(
                  (_) => const StockEntity(
                    materialId: 'mat-1',
                    quantity: 7,
                    transactionType: 'in',
                  ),
                )
                .toList(),
          );

        final container = ProviderContainer(
          overrides: [
            materialRepositoryProvider.overrideWithValue(materialRepo),
            stockRepositoryProvider.overrideWithValue(stockRepo),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(materialViewModelProvider.notifier)
            .getAllMaterials();

        final state = container.read(materialViewModelProvider);
        expect(state.status, MaterialStatus.loaded);
        expect(state.materials.first.quantity, 7);
      },
    );

    test('9) RecipeViewModel starts with initial status', () {
      final repo = FakeRecipeRepository();
      final container = ProviderContainer(
        overrides: [recipeRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(recipeViewModelProvider).status,
        RecipeStatus.initial,
      );
    });

    test('10) RecipeViewModel getAllRecipes success loads recipes', () async {
      final repo = FakeRecipeRepository()..allResult = Right([sampleRecipe()]);
      final container = ProviderContainer(
        overrides: [recipeRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(recipeViewModelProvider.notifier).getAllRecipes();

      final state = container.read(recipeViewModelProvider);
      expect(state.status, RecipeStatus.loaded);
      expect(state.recipes.length, 1);
    });

    test('11) RecipeViewModel createRecipe failure sets error', () async {
      final repo = FakeRecipeRepository()
        ..createResult = Left(
          const Apifailure(message: 'Create recipe failed'),
        );
      final container = ProviderContainer(
        overrides: [recipeRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final result = await container
          .read(recipeViewModelProvider.notifier)
          .createRecipe(name: 'Cake', sellingPrice: 100, ingredients: const []);

      final state = container.read(recipeViewModelProvider);
      expect(result, isFalse);
      expect(state.status, RecipeStatus.error);
      expect(state.errorMessage, 'Create recipe failed');
    });

    test('12) RecipeViewModel deleteRecipe success returns true', () async {
      final repo = FakeRecipeRepository()
        ..deleteResult = const Right(true)
        ..allResult = const Right([]);
      final container = ProviderContainer(
        overrides: [recipeRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final result = await container
          .read(recipeViewModelProvider.notifier)
          .deleteRecipe('r1');
      await Future<void>.delayed(Duration.zero);

      expect(result, isTrue);
      expect(
        container.read(recipeViewModelProvider).status,
        RecipeStatus.loaded,
      );
    });

    test('13) StockViewModel starts with initial status', () {
      final stockRepo = FakeStockRepository();
      final materialRepo = FakeMaterialRepository();
      final container = ProviderContainer(
        overrides: [
          stockRepositoryProvider.overrideWithValue(stockRepo),
          materialRepositoryProvider.overrideWithValue(materialRepo),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(stockViewModelProvider).status,
        StockStatus.initial,
      );
    });

    test('14) StockViewModel getAllStockTransactions loads data', () async {
      final stockRepo = FakeStockRepository()
        ..allTxnResult = Right([sampleStock()]);
      final materialRepo = FakeMaterialRepository();
      final container = ProviderContainer(
        overrides: [
          stockRepositoryProvider.overrideWithValue(stockRepo),
          materialRepositoryProvider.overrideWithValue(materialRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(stockViewModelProvider.notifier)
          .getAllStockTransactions();

      final state = container.read(stockViewModelProvider);
      expect(state.status, StockStatus.loaded);
      expect(state.stock.length, 1);
    });

    test(
      '15) StockViewModel createStockTransaction failure sets error',
      () async {
        final stockRepo = FakeStockRepository()
          ..createTxnResult = Left(const Apifailure(message: 'Txn failed'));
        final materialRepo = FakeMaterialRepository();
        final container = ProviderContainer(
          overrides: [
            stockRepositoryProvider.overrideWithValue(stockRepo),
            materialRepositoryProvider.overrideWithValue(materialRepo),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(stockViewModelProvider.notifier)
            .createStockTransaction(
              materialId: 'mat-1',
              quantity: 2,
              transactionType: 'out',
            );

        final state = container.read(stockViewModelProvider);
        expect(state.status, StockStatus.error);
        expect(state.errorMessage, 'Txn failed');
      },
    );

    test('16) StockViewModel updateStock success becomes loaded', () async {
      final stockRepo = FakeStockRepository()
        ..updateResult = const Right(true)
        ..allTxnResult = const Right([]);
      final materialRepo = FakeMaterialRepository();
      final container = ProviderContainer(
        overrides: [
          stockRepositoryProvider.overrideWithValue(stockRepo),
          materialRepositoryProvider.overrideWithValue(materialRepo),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(stockViewModelProvider.notifier)
          .updateStock(stockId: 's1');
      await Future<void>.delayed(Duration.zero);

      expect(container.read(stockViewModelProvider).status, StockStatus.loaded);
    });

    test('17) ProductionViewModel starts with initial status', () {
      final repo = FakeProductionRepository();
      final container = ProviderContainer(
        overrides: [productionRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(productionViewModelProvider).status,
        ProductionStatus.initial,
      );
    });

    test(
      '18) ProductionViewModel startProduction false sets out-of-stock error',
      () async {
        final repo = FakeProductionRepository()
          ..startResult = const Right(false);
        final container = ProviderContainer(
          overrides: [productionRepositoryProvider.overrideWithValue(repo)],
        );
        addTearDown(container.dispose);

        final started = await container
            .read(productionViewModelProvider.notifier)
            .startProduction(recipeId: 'r1', quantity: 5);

        final state = container.read(productionViewModelProvider);
        expect(started, isFalse);
        expect(state.status, ProductionStatus.error);
        expect(state.errorMessage, 'Material out of stock');
      },
    );

    test(
      '19) ProductionViewModel startProduction success returns true',
      () async {
        final repo = FakeProductionRepository()
          ..startResult = const Right(true)
          ..allResult = const Right([]);
        final container = ProviderContainer(
          overrides: [productionRepositoryProvider.overrideWithValue(repo)],
        );
        addTearDown(container.dispose);

        final started = await container
            .read(productionViewModelProvider.notifier)
            .startProduction(recipeId: 'r1', quantity: 5);
        await Future<void>.delayed(Duration.zero);

        expect(started, isTrue);
        expect(
          container.read(productionViewModelProvider).status,
          ProductionStatus.loaded,
        );
      },
    );

    test(
      '20) ProductionViewModel endProduction failure sets error and returns false',
      () async {
        final repo = FakeProductionRepository()
          ..endResult = Left(const Apifailure(message: 'End failed'));
        final container = ProviderContainer(
          overrides: [productionRepositoryProvider.overrideWithValue(repo)],
        );
        addTearDown(container.dispose);

        final ended = await container
            .read(productionViewModelProvider.notifier)
            .endProduction('p1');

        final state = container.read(productionViewModelProvider);
        expect(ended, isFalse);
        expect(state.status, ProductionStatus.error);
        expect(state.errorMessage, 'End failed');
      },
    );
  });
}
