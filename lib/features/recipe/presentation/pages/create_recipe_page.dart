import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/presentation/state/recipe_state.dart';
import 'package:businesstrack/features/recipe/presentation/viewmodel/recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRecipePage extends ConsumerStatefulWidget {
  const CreateRecipePage({super.key});

  @override
  ConsumerState<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends ConsumerState<CreateRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  List<_Ingredient> _ingredients = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(materialViewModelProvider.notifier).getAllMaterials();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add(_Ingredient(materialId: '', quantity: ''));
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _updateIngredient(int index, {String? materialId, String? quantity}) {
    setState(() {
      if (materialId != null) {
        _ingredients[index] = _ingredients[index].copyWith(
          materialId: materialId,
        );
      }
      if (quantity != null) {
        _ingredients[index] = _ingredients[index].copyWith(quantity: quantity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final materialState = ref.watch(materialViewModelProvider);
    final materials = materialState.materials
        .where((material) => material.materialId != null)
        .toList();
    final recipeState = ref.watch(recipeViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Recipe'), elevation: 0),
      body: recipeState.status == RecipeStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Name
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Recipe Name',
                        hintText: 'e.g., 1-Tier Cake',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.menu_book),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter recipe name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Brief description of the recipe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Selling Price
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Selling Price (\$)',
                        hintText: 'e.g., 25.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.currency_exchange),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter selling price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Ingredients Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _addIngredient,
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (_ingredients.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'No ingredients added yet',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: List.generate(_ingredients.length, (index) {
                          final ingredient = _ingredients[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: DropdownButtonFormField<String>(
                                      value: ingredient.materialId.isEmpty
                                          ? null
                                          : ingredient.materialId,
                                      decoration: InputDecoration(
                                        labelText: 'Material',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                      ),
                                      items: materials
                                          .map(
                                            (m) => DropdownMenuItem(
                                              value: m.materialId,
                                              child: Text(m.name),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          _updateIngredient(
                                            index,
                                            materialId: value,
                                          );
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Select material';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: ingredient.quantity,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Qty',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                      ),
                                      onChanged: (value) {
                                        _updateIngredient(
                                          index,
                                          quantity: value,
                                        );
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter qty';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _removeIngredient(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              _ingredients.isNotEmpty) {
                            final ingredientEntities = _ingredients
                                .where(
                                  (item) =>
                                      item.materialId.isNotEmpty &&
                                      item.quantity.isNotEmpty,
                                )
                                .map((item) {
                                  final selectedMaterial = materials.firstWhere(
                                    (material) =>
                                        material.materialId == item.materialId,
                                  );

                                  return IngredientEntity(
                                    name: selectedMaterial.name,
                                    materialId: item.materialId,
                                    quantity:
                                        double.tryParse(item.quantity) ?? 0,
                                  );
                                })
                                .toList();

                            if (ingredientEntities.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please add at least one valid ingredient',
                                  ),
                                ),
                              );
                              return;
                            }

                            final success = await ref
                                .read(recipeViewModelProvider.notifier)
                                .createRecipe(
                                  name: _nameController.text.trim(),
                                  description: _descriptionController.text
                                      .trim(),
                                  sellingPrice:
                                      double.tryParse(
                                        _priceController.text.trim(),
                                      ) ??
                                      0,
                                  ingredients: ingredientEntities,
                                );

                            if (!context.mounted) {
                              return;
                            }

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Recipe created successfully'),
                                ),
                              );
                              Navigator.pop(context, true);
                            } else {
                              final error = ref
                                  .read(recipeViewModelProvider)
                                  .errorMessage;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error ?? 'Failed to create recipe',
                                  ),
                                ),
                              );
                            }
                          } else if (_ingredients.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please add at least one ingredient',
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Create Recipe'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _Ingredient {
  final String materialId;
  final String quantity;

  _Ingredient({required this.materialId, required this.quantity});

  _Ingredient copyWith({String? materialId, String? quantity}) {
    return _Ingredient(
      materialId: materialId ?? this.materialId,
      quantity: quantity ?? this.quantity,
    );
  }
}
