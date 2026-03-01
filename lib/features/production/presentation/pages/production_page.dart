import 'package:businesstrack/core/services/storage/user_session_service.dart';
import 'package:businesstrack/core/utils/responsive_helper.dart';
import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:businesstrack/features/production/presentation/viewmodel/production_viewmodel.dart';
import 'package:businesstrack/features/production/presentation/state/production_state.dart';
import 'package:businesstrack/features/recipe/presentation/pages/create_recipe_page.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/presentation/state/recipe_state.dart';
import 'package:businesstrack/features/recipe/presentation/viewmodel/recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProductionPage extends ConsumerStatefulWidget {
  const ProductionPage({super.key});

  @override
  ConsumerState<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends ConsumerState<ProductionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _userId = '';
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _onTabChanged() {
    if (_currentTabIndex != _tabController.index && mounted) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userSessionService = UserSessionService(prefs: prefs);
    final userId = userSessionService.getCurrentUserId();
    if (userId != null && mounted) {
      setState(() {
        _userId = userId;
      });
      ref.read(recipeViewModelProvider.notifier).getAllRecipes();
      ref.read(productionViewModelProvider.notifier).getAllProduction();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeState = ref.watch(recipeViewModelProvider);
    final productionState = ref.watch(productionViewModelProvider);
    final materialState = ref.watch(materialViewModelProvider);

    ref.listen<ProductionState>(productionViewModelProvider, (previous, next) {
      final message = next.errorMessage;
      if (next.status == ProductionStatus.error &&
          message != null &&
          message.isNotEmpty &&
          previous?.errorMessage != message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Management'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Batches', icon: Icon(Icons.factory, size: 20)),
            Tab(text: 'Recipes', icon: Icon(Icons.menu_book, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBatchesTab(productionState, recipeState),
          _buildRecipesTab(recipeState),
        ],
      ),
      floatingActionButton: _currentTabIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () =>
                  _showStartBatchDialog(recipeState, materialState),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Batch'),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateRecipePage(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('New Recipe'),
            ),
    );
  }

  Widget _buildBatchesTab(ProductionState state, RecipeState recipeState) {
    final ongoing = state.production
        .where((p) => p.status == 'ongoing')
        .toList();
    final completed = state.production
        .where((p) => p.status == 'completed')
        .toList();

    if (state.status == ProductionStatus.loading && state.production.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Ongoing Batches
          Padding(
            padding: EdgeInsets.all(
              ResponsiveHelper.getHorizontalPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.factory, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Ongoing Batches (${ongoing.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (ongoing.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'No ongoing batches',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ongoing.length,
                    itemBuilder: (context, index) {
                      final batch = ongoing[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Colors.orange,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'In Progress',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(batch.createdAt ?? DateTime.now()),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Recipe ID: ${batch.recipeId}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Batch Qty: ${batch.batchQuantity.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    'Est. Output: ${batch.estimatedOutput.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _showCompleteBatchDialog(batch),
                                  icon: const Icon(Icons.check_circle),
                                  label: const Text('Complete Batch'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          // Completed Batches
          Padding(
            padding: EdgeInsets.all(
              ResponsiveHelper.getHorizontalPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Completed Batches (${completed.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (completed.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'No completed batches',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: completed.length,
                    itemBuilder: (context, index) {
                      final batch = completed[index];
                      var recipeName = batch.recipeId;
                      for (final recipe in recipeState.recipes) {
                        if (recipe.recipeId == batch.recipeId) {
                          recipeName = recipe.name;
                          break;
                        }
                      }
                      final wastagePercent = batch.actualOutput != null
                          ? ((batch.estimatedOutput - batch.actualOutput!) /
                                    batch.estimatedOutput *
                                    100)
                                .toStringAsFixed(1)
                          : '0.0';
                      final wastageColor = double.parse(wastagePercent) > 10
                          ? Colors.red
                          : Colors.green;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Completed',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(batch.updatedAt ?? DateTime.now()),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Recipe: $recipeName',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Output: ${batch.actualOutput?.toStringAsFixed(0) ?? 0} / ${batch.estimatedOutput.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    'Wastage: $wastagePercent%',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: wastageColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesTab(RecipeState state) {
    if (state.status == RecipeStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == RecipeStatus.error) {
      return Center(child: Text('Error: ${state.errorMessage}'));
    }

    if (state.recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            const Text(
              'No Recipes Yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a recipe to start production',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.recipes.length,
      itemBuilder: (context, index) {
        final recipe = state.recipes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (recipe.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              recipe.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      '\$${recipe.sellingPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: List.generate(recipe.ingredients.length, (i) {
                    final ingredient = recipe.ingredients[i];
                    return Chip(
                      label: Text(
                        '${ingredient.name} (${ingredient.quantity})',
                      ),
                      avatar: const Icon(Icons.local_dining, size: 16),
                      side: BorderSide(color: Colors.grey[300]!),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (recipe.recipeId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Unable to edit: invalid recipe id',
                                ),
                              ),
                            );
                            return;
                          }
                          _showEditRecipeDialog(recipe);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (recipe.recipeId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Unable to delete: invalid recipe id',
                                ),
                              ),
                            );
                            return;
                          }
                          _showDeleteRecipeDialog(recipe.recipeId!);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditRecipeDialog(RecipeEntity recipe) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: recipe.name);
    final descriptionController = TextEditingController(
      text: recipe.description ?? '',
    );
    final priceController = TextEditingController(
      text: recipe.sellingPrice.toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Recipe'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Recipe Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter recipe name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Selling Price'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter selling price';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              final updatedRecipe = RecipeEntity(
                recipeId: recipe.recipeId,
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
                sellingPrice: double.parse(priceController.text.trim()),
                ingredients: recipe.ingredients,
                userId: recipe.userId,
                createdAt: recipe.createdAt,
                updatedAt: recipe.updatedAt,
              );

              final success = await ref
                  .read(recipeViewModelProvider.notifier)
                  .updateRecipe(updatedRecipe);

              if (!mounted) {
                return;
              }

              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success ? 'Recipe updated' : 'Failed to update recipe',
                  ),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteRecipeDialog(String recipeId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: const Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ref
                  .read(recipeViewModelProvider.notifier)
                  .deleteRecipe(recipeId);

              if (!mounted) {
                return;
              }

              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success ? 'Recipe deleted' : 'Failed to delete recipe',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showStartBatchDialog(RecipeState recipeState, materialState) {
    String selectedRecipeId = '';
    String batchQuantity = '';
    String estimatedOutput = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Production Batch'),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Recipe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: selectedRecipeId.isEmpty ? null : selectedRecipeId,
                  items: recipeState.recipes
                      .where(
                        (r) => r.recipeId != null && r.recipeId!.isNotEmpty,
                      )
                      .map(
                        (r) => DropdownMenuItem<String>(
                          value: r.recipeId!,
                          child: Text(r.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRecipeId = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a recipe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Batch Quantity',
                    hintText: 'e.g., 10',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      batchQuantity = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Estimated Output',
                    hintText: 'e.g., 10',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      estimatedOutput = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedRecipeId.isNotEmpty &&
                  batchQuantity.isNotEmpty &&
                  estimatedOutput.isNotEmpty) {
                final isStarted = await ref
                    .read(productionViewModelProvider.notifier)
                    .startProduction(
                      recipeId: selectedRecipeId,
                      quantity: int.parse(batchQuantity),
                      estimatedOutput: double.parse(estimatedOutput),
                    );

                if (!context.mounted) return;

                if (isStarted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Batch started successfully')),
                  );
                } else {
                  final errorMessage =
                      ref.read(productionViewModelProvider).errorMessage ?? '';

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        errorMessage.isNotEmpty
                            ? errorMessage
                            : 'Material out of stock',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Start Batch'),
          ),
        ],
      ),
    );
  }

  void _showCompleteBatchDialog(dynamic batch) {
    String actualOutput = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Production Batch'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Actual Output',
                hintText: 'Enter actual output',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                helperText: 'Estimated: ${batch.estimatedOutput}',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                actualOutput = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (actualOutput.isNotEmpty) {
                final productionId = batch.productionId;
                if (productionId == null || productionId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Unable to complete: invalid batch id'),
                    ),
                  );
                  return;
                }

                ref
                    .read(productionViewModelProvider.notifier)
                    .endProduction(
                      productionId,
                      actualOutput: double.parse(actualOutput),
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Batch completed successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }
}
