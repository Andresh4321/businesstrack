/// ========================================================================
/// ALL USECASES TEST - Comprehensive Domain Layer Testing (20 Tests)
/// ========================================================================
///
/// Test Coverage Summary:
/// ┌─────┬──────────────┬─────────────────────────────────────────┐
/// │ #   │ Feature      │ Usecase Tested                          │
/// ├─────┼──────────────┼─────────────────────────────────────────┤
/// │ 1   │ Auth         │ RegisterUsecase                         │
/// │ 2   │ Auth         │ LoginUsecase                            │
/// │ 3   │ Auth         │ AdminLoginUsecase                       │
/// │ 4   │ Auth         │ WhoAmIUsecase                           │
/// │ 5   │ Auth         │ UpdateProfileUsecase                    │
/// │ 6   │ Material     │ AddMaterialUsecase                      │
/// │ 7   │ Material     │ GetAllMaterialsUsecase                  │
/// │ 8   │ Material     │ UpdateMaterialUsecase                   │
/// │ 9   │ Material     │ DeleteMaterialUsecase                   │
/// │ 10  │ Recipe       │ CreateRecipeUsecase                     │
/// │ 11  │ Recipe       │ GetAllRecipesUsecase                    │
/// │ 12  │ Recipe       │ UpdateRecipeUsecase                     │
/// │ 13  │ Recipe       │ DeleteRecipeUsecase                     │
/// │ 14  │ Recipe       │ GetRecipeByIdUsecase                    │
/// │ 15  │ Production   │ StartProductionUsecase                  │
/// │ 16  │ Production   │ GetAllProductionUsecase                 │
/// │ 17  │ Production   │ EndProductionUsecase                    │
/// │ 18  │ Production   │ DeleteProductionUsecase                 │
/// │ 19  │ Stock        │ CreateStockTransactionUsecase           │
/// │ 20  │ Stock        │ GetAllStockTransactionsUsecase          │
/// └─────┴──────────────┴─────────────────────────────────────────┘

import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';
import 'package:businesstrack/features/auth/domain/usecases/admin_login_usecase.dart';
import 'package:businesstrack/features/auth/domain/usecases/login_usecase.dart';
import 'package:businesstrack/features/auth/domain/usecases/register_usecase.dart';
import 'package:businesstrack/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:businesstrack/features/auth/domain/usecases/whoami_usecase.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/material/domain/usecases/add_material_usecase.dart';
import 'package:businesstrack/features/material/domain/usecases/delete_material_usecase.dart';
import 'package:businesstrack/features/material/domain/usecases/get_all_materials_usecase.dart';
import 'package:businesstrack/features/material/domain/usecases/update_material_usecase.dart';
import 'package:businesstrack/features/production/domain/usecases/delete_production_usecase.dart';
import 'package:businesstrack/features/production/domain/usecases/end_production_usecase.dart';
import 'package:businesstrack/features/production/domain/usecases/get_all_production_usecase.dart';
import 'package:businesstrack/features/production/domain/usecases/start_production_usecase.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/domain/usecases/create_recipe_usecase.dart';
import 'package:businesstrack/features/recipe/domain/usecases/delete_recipe_usecase.dart';
import 'package:businesstrack/features/recipe/domain/usecases/get_all_recipes_usecase.dart';
import 'package:businesstrack/features/recipe/domain/usecases/get_recipe_by_id_usecase.dart';
import 'package:businesstrack/features/recipe/domain/usecases/update_recipe_usecase.dart';
import 'package:businesstrack/features/stock/domain/usecases/create_stock_transaction_usecase.dart';
import 'package:businesstrack/features/stock/domain/usecases/get_all_stock_transactions_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_fakes.dart';

void main() {
  group('✓ AUTH USECASES', () {
    test('RegisterUsecase - successfully registers user', () async {
      final repo = FakeAuthRepository();
      final usecase = RegisterUsecase(authRepository: repo);

      final result = await usecase(
        const RegisterUsecaseParams(
          fullName: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
        ),
      );

      expect(result, const Right(true));
      expect(repo.lastRegistered?.fullName, 'John Doe');
    });

    test('LoginUsecase - successfully logs in user', () async {
      final repo = FakeAuthRepository();
      final usecase = LoginUsecase(authRepository: repo);

      final result = await usecase(
        const LoginUsecaseParams(
          email: 'user@example.com',
          password: 'password123',
        ),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (r) => expect(r.email, 'test@example.com'),
      );
    });

    test('AdminLoginUsecase - admin login successful', () async {
      final repo = FakeAuthRepository();
      final usecase = AdminLoginUsecase(repository: repo);

      final result = await usecase(
        const AdminLoginParams(
          email: 'admin@example.com',
          password: 'admin123',
        ),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (r) => expect(r.authId, 'auth-123'),
      );
    });

    test('WhoAmIUsecase - returns current user info', () async {
      final repo = FakeAuthRepository();
      final usecase = WhoAmIUsecase(repository: repo);

      final result = await usecase();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (r) => expect(r.fullName, 'Test User'),
      );
    });

    test('UpdateProfileUsecase - updates user profile', () async {
      final repo = FakeAuthRepository();
      final usecase = UpdateProfileUsecase(repository: repo);

      final result = await usecase(
        const UpdateProfileParams(
          entity: AuthEntity(
            authId: 'auth-123',
            fullName: 'Updated Name',
            email: 'test@example.com',
          ),
        ),
      );

      expect(result.isRight(), isTrue);
    });
  });

  group('✓ MATERIAL USECASES', () {
    test('AddMaterialUsecase - adds material successfully', () async {
      final repo = FakeMaterialRepository();
      final usecase = AddMaterialUsecase(materialRepository: repo);

      final result = await usecase(
        const AddMaterialParams(
          name: 'Sugar',
          unit: 'kg',
          unitPrice: 60.0,
          quantity: 50.0,
          minimumStock: 10.0,
        ),
      );

      expect(result, const Right(true));
      expect(repo.lastAdded?.name, 'Sugar');
    });

    test('GetAllMaterialsUsecase - returns list of materials', () async {
      final repo = FakeMaterialRepository();
      final usecase = GetAllMaterialsUsecase(materialRepository: repo);

      final result = await usecase();

      expect(result.isRight(), isTrue);
      result.fold((l) => fail('Expected Right'), (r) => expect(r, isNotEmpty));
    });

    test('UpdateMaterialUsecase - updates material successfully', () async {
      final repo = FakeMaterialRepository();
      final usecase = UpdateMaterialUsecase(materialRepository: repo);

      final result = await usecase(
        UpdateMaterialParams(
          material: sampleMaterialEntity().copyWith(name: 'Updated Flour'),
        ),
      );

      expect(result, const Right(true));
    });

    test('DeleteMaterialUsecase - deletes material successfully', () async {
      final repo = FakeMaterialRepository();
      final usecase = DeleteMaterialUsecase(materialRepository: repo);

      final result = await usecase(
        const DeleteMaterialParams(materialId: 'mat-123'),
      );

      expect(result, const Right(true));
    });
  });

  group('✓ RECIPE USECASES', () {
    test('CreateRecipeUsecase - creates recipe with ingredients', () async {
      final repo = FakeRecipeRepository();
      final usecase = CreateRecipeUsecase(recipeRepository: repo);

      final result = await usecase(
        const CreateRecipeParams(
          name: 'Bread',
          sellingPrice: 50.0,
          ingredients: [
            IngredientEntity(name: 'Flour', materialId: 'mat-1', quantity: 2.0),
          ],
        ),
      );

      expect(result, const Right(true));
      expect(repo.lastCreated?.name, 'Bread');
    });

    test('GetAllRecipesUsecase - returns recipe list', () async {
      final repo = FakeRecipeRepository();
      final usecase = GetAllRecipesUsecase(recipeRepository: repo);

      final result = await usecase();

      expect(result.isRight(), isTrue);
    });

    test('UpdateRecipeUsecase - updates recipe successfully', () async {
      final repo = FakeRecipeRepository();
      final usecase = UpdateRecipeUsecase(recipeRepository: repo);

      final result = await usecase(
        const UpdateRecipeParams(
          recipe: RecipeEntity(
            recipeId: 'recipe-123',
            name: 'Bread',
            sellingPrice: 250.0,
            ingredients: [],
          ),
        ),
      );

      expect(result, const Right(true));
    });

    test('DeleteRecipeUsecase - deletes recipe successfully', () async {
      final repo = FakeRecipeRepository();
      final usecase = DeleteRecipeUsecase(recipeRepository: repo);

      final result = await usecase(
        const DeleteRecipeParams(recipeId: 'recipe-123'),
      );

      expect(result, const Right(true));
    });

    test('GetRecipeByIdUsecase - returns specific recipe', () async {
      final repo = FakeRecipeRepository();
      final usecase = GetRecipeByIdUsecase(recipeRepository: repo);

      final result = await usecase(
        const GetRecipeByIdParams(recipeId: 'recipe-123'),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (r) => expect(r.recipeId, 'recipe-123'),
      );
    });
  });

  group('✓ PRODUCTION USECASES', () {
    test('StartProductionUsecase - starts production', () async {
      final repo = FakeProductionRepository();
      final usecase = StartProductionUsecase(productionRepository: repo);

      final result = await usecase(
        const StartProductionParams(recipeId: 'recipe-123', quantity: 10),
      );

      expect(result, const Right(true));
    });

    test('GetAllProductionUsecase - returns production list', () async {
      final repo = FakeProductionRepository();
      final usecase = GetAllProductionUsecase(productionRepository: repo);

      final result = await usecase();

      expect(result.isRight(), isTrue);
    });

    test('EndProductionUsecase - ends production successfully', () async {
      final repo = FakeProductionRepository();
      final usecase = EndProductionUsecase(productionRepository: repo);

      final result = await usecase(
        const EndProductionParams(productionId: 'prod-123', actualOutput: 9.5),
      );

      expect(result, const Right(true));
    });

    test('DeleteProductionUsecase - deletes production record', () async {
      final repo = FakeProductionRepository();
      final usecase = DeleteProductionUsecase(productionRepository: repo);

      final result = await usecase(
        const DeleteProductionParams(productionId: 'prod-123'),
      );

      expect(result, const Right(true));
    });
  });

  group('✓ STOCK USECASES', () {
    test('CreateStockTransactionUsecase - creates transaction', () async {
      final repo = FakeStockRepository();
      final usecase = CreateStockTransactionUsecase(stockRepository: repo);

      final result = await usecase(
        const CreateStockTransactionParams(
          materialId: 'mat-123',
          quantity: 50.0,
          transactionType: 'in',
        ),
      );

      expect(result, const Right(true));
    });

    test('GetAllStockTransactionsUsecase - returns transactions', () async {
      final repo = FakeStockRepository();
      final usecase = GetAllStockTransactionsUsecase(stockRepository: repo);

      final result = await usecase();

      expect(result.isRight(), isTrue);
    });
  });
}
