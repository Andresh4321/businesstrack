// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientModelAdapter extends TypeAdapter<IngredientModel> {
  @override
  final int typeId = 8;

  @override
  IngredientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientModel(
      ingredientId: fields[0] as String?,
      name: fields[1] as String,
      materialId: fields[2] as String,
      quantity: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.ingredientId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.materialId)
      ..writeByte(3)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecipeModelAdapter extends TypeAdapter<RecipeModel> {
  @override
  final int typeId = 7;

  @override
  RecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeModel(
      recipeId: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String?,
      sellingPrice: fields[3] as double,
      ingredients: (fields[4] as List).cast<IngredientModel>(),
      userId: fields[5] as String?,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.recipeId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.sellingPrice)
      ..writeByte(4)
      ..write(obj.ingredients)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
