import 'package:equatable/equatable.dart';

class IngredientEntity extends Equatable {
  final String? ingredientId;
  final String name;
  final String materialId;
  final double quantity;

  const IngredientEntity({
    this.ingredientId,
    required this.name,
    required this.materialId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [ingredientId, name, materialId, quantity];
}

class RecipeEntity extends Equatable {
  final String? recipeId;
  final String name;
  final String? description;
  final double sellingPrice;
  final List<IngredientEntity> ingredients;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RecipeEntity({
    this.recipeId,
    required this.name,
    this.description,
    required this.sellingPrice,
    required this.ingredients,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    recipeId,
    name,
    description,
    sellingPrice,
    ingredients,
    userId,
    createdAt,
    updatedAt,
  ];
}
