import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'recipe_model.g.dart';

@HiveType(typeId: 8) // Updated to match HiveTableConstant.ingredientTypeId
class IngredientModel extends HiveObject {
  @HiveField(0)
  final String? ingredientId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String materialId;

  @HiveField(3)
  final double quantity;

  IngredientModel({
    String? ingredientId,
    required this.name,
    required this.materialId,
    required this.quantity,
  }) : ingredientId = ingredientId ?? const Uuid().v4();

  factory IngredientModel.fromEntity(IngredientEntity entity) {
    return IngredientModel(
      ingredientId: entity.ingredientId,
      name: entity.name,
      materialId: entity.materialId,
      quantity: entity.quantity,
    );
  }

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    final materialValue = json['material'];
    String? parsedMaterialId;

    if (materialValue is Map) {
      parsedMaterialId =
          (materialValue['_id'] ?? materialValue['id']) as String?;
    } else {
      parsedMaterialId = materialValue as String?;
    }

    return IngredientModel(
      ingredientId: (json['_id'] ?? json['id']) as String?,
      name: json['name'] as String,
      materialId: parsedMaterialId ?? '',
      quantity: (json['quantity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'material': materialId, 'quantity': quantity};
  }

  IngredientEntity toEntity() {
    return IngredientEntity(
      ingredientId: ingredientId,
      name: name,
      materialId: materialId,
      quantity: quantity,
    );
  }
}

@HiveType(typeId: 7) // Updated to match HiveTableConstant.recipeTypeId
class RecipeModel extends HiveObject {
  @HiveField(0)
  final String? recipeId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final double sellingPrice;

  @HiveField(4)
  final List<IngredientModel> ingredients;

  @HiveField(5)
  final String? userId;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  RecipeModel({
    String? recipeId,
    required this.name,
    this.description,
    required this.sellingPrice,
    required this.ingredients,
    this.userId,
    this.createdAt,
    this.updatedAt,
  }) : recipeId = recipeId ?? const Uuid().v4();

  factory RecipeModel.fromEntity(RecipeEntity entity) {
    return RecipeModel(
      recipeId: entity.recipeId,
      name: entity.name,
      description: entity.description,
      sellingPrice: entity.sellingPrice,
      ingredients: entity.ingredients
          .map((e) => IngredientModel.fromEntity(e))
          .toList(),
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final ingredientsList = (json['ingredients'] as List? ?? []);
    return RecipeModel(
      recipeId: (json['_id'] ?? json['id']) as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      sellingPrice: (json['selling_price'] as num).toDouble(),
      ingredients: ingredientsList
          .map((item) => IngredientModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      userId: json['user'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'selling_price': sellingPrice,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
    };
  }

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

  static List<RecipeEntity> toEntityList(List<RecipeModel> list) {
    return list.map((e) => e.toEntity()).toList();
  }
}
