import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:equatable/equatable.dart';

enum RecipeStatus { initial, loading, loaded, error }

class RecipeState extends Equatable {
  final RecipeStatus status;
  final List<RecipeEntity> recipes;
  final RecipeEntity? selectedRecipe;
  final String? errorMessage;

  const RecipeState({
    this.status = RecipeStatus.initial,
    this.recipes = const [],
    this.selectedRecipe,
    this.errorMessage,
  });

  RecipeState copyWith({
    RecipeStatus? status,
    List<RecipeEntity>? recipes,
    RecipeEntity? selectedRecipe,
    String? errorMessage,
  }) {
    return RecipeState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      selectedRecipe: selectedRecipe ?? this.selectedRecipe,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, recipes, selectedRecipe, errorMessage];
}
