import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'recipe_hive_model.g.dart';

@HiveType(typeId: 8)
class IngredientHiveModel extends HiveObject {
  @HiveField(0)
  final String ingredientId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String materialId;

  @HiveField(3)
  final double quantity;

  IngredientHiveModel({
    String? ingredientId,
    required this.name,
    required this.materialId,
    required this.quantity,
  }) : ingredientId = ingredientId ?? const Uuid().v4();

  IngredientEntity toEntity() {
    return IngredientEntity(
      ingredientId: ingredientId,
      name: name,
      materialId: materialId,
      quantity: quantity,
    );
  }

  factory IngredientHiveModel.fromEntity(IngredientEntity entity) {
    return IngredientHiveModel(
      ingredientId: entity.ingredientId,
      name: entity.name,
      materialId: entity.materialId,
      quantity: entity.quantity,
    );
  }
}

@HiveType(typeId: 7)
class RecipeHiveModel extends HiveObject {
  @HiveField(0)
  final String recipeId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final double sellingPrice;

  @HiveField(4)
  final List<IngredientHiveModel> ingredients;

  @HiveField(5)
  final String? userId;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  RecipeHiveModel({
    String? recipeId,
    required this.name,
    this.description,
    required this.sellingPrice,
    required this.ingredients,
    this.userId,
    this.createdAt,
    this.updatedAt,
  }) : recipeId = recipeId ?? const Uuid().v4();

  // To Entity
  RecipeEntity toEntity() {
    return RecipeEntity(
      recipeId: recipeId,
      name: name,
      description: description,
      sellingPrice: sellingPrice,
      ingredients: ingredients.map((e) => e.toEntity()).toList(),
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // From Entity
  factory RecipeHiveModel.fromEntity(RecipeEntity entity) {
    return RecipeHiveModel(
      recipeId: entity.recipeId,
      name: entity.name,
      description: entity.description,
      sellingPrice: entity.sellingPrice,
      ingredients: entity.ingredients
          .map((e) => IngredientHiveModel.fromEntity(e))
          .toList(),
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convert list
  static List<RecipeEntity> toEntityList(List<RecipeHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
