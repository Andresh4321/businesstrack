import 'package:businesstrack/core/utils/responsive_helper.dart';
import 'package:businesstrack/features/recipe/presentation/pages/create_recipe_page.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/presentation/state/recipe_state.dart';
import 'package:businesstrack/features/recipe/presentation/viewmodel/recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeListPage extends ConsumerStatefulWidget {
  const RecipeListPage({super.key});

  @override
  ConsumerState<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends ConsumerState<RecipeListPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late TextEditingController _searchController;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
    _searchController = TextEditingController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recipeViewModelProvider.notifier).getAllRecipes();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeState = ref.watch(recipeViewModelProvider);
    final recipes = recipeState.recipes;

    // Filter recipes
    final filteredRecipes = _searchController.text.isEmpty
        ? recipes
        : recipes
            .where(
              (r) => r.name.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ),
            )
            .toList();

    // Calculate stats
    final avgPrice = recipes.isEmpty
        ? 0.0
        : recipes.fold<double>(0, (sum, r) => sum + r.sellingPrice) /
            recipes.length;
    final totalIngredients = recipes.fold<int>(
      0,
      (sum, r) => sum + r.ingredients.length,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: recipeState.status == RecipeStatus.loading && recipes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : recipeState.status == RecipeStatus.error
              ? _buildErrorState(recipeState.errorMessage)
              : CustomScrollView(
                  slivers: [
                    _buildAppBar(context, recipes.length, avgPrice, totalIngredients),
                    SliverToBoxAdapter(child: _buildSearchBar()),
                    filteredRecipes.isEmpty
                        ? SliverFillRemaining(child: _buildEmptyState(context))
                        : _buildRecipesGrid(filteredRecipes),
                  ],
                ),
      floatingActionButton: ScaleTransition(
        scale: _animationController,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final created = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateRecipePage()),
            );

            if (created == true && mounted) {
              ref.read(recipeViewModelProvider.notifier).getAllRecipes();
            }
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('New Recipe'),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    int totalRecipes,
    double avgPrice,
    int totalIngredients,
  ) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveHelper.getHorizontalPadding(context),
                60,
                ResponsiveHelper.getHorizontalPadding(context),
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recipes',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    mobile: 24,
                                    tablet: 28,
                                  ),
                                ),
                          ),
                          Text(
                            'Production recipes',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStatChip(
                          Icons.restaurant_menu_rounded,
                          '$totalRecipes Recipes',
                        ),
                        const SizedBox(width: 12),
                        _buildStatChip(
                          Icons.attach_money_rounded,
                          'Avg \$${avgPrice.toStringAsFixed(2)}',
                        ),
                        const SizedBox(width: 12),
                        _buildStatChip(
                          Icons.local_dining_rounded,
                          '$totalIngredients Total Ingredients',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        titlePadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final horizontalPadding = ResponsiveHelper.getHorizontalPadding(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search recipes...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400]),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          onChanged: (value) => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 80,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Recipes Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first production recipe\nto start making products',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final created = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateRecipePage(),
                  ),
                );

                if (created == true && mounted) {
                  ref.read(recipeViewModelProvider.notifier).getAllRecipes();
                }
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create First Recipe'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage ?? 'Unable to load recipes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(recipeViewModelProvider.notifier).getAllRecipes();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipesGrid(List<RecipeEntity> recipes) {
    final horizontalPadding = ResponsiveHelper.getHorizontalPadding(context);
    final gridSpacing = ResponsiveHelper.getGridSpacing(context);
    final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        8,
        horizontalPadding,
        100,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: gridSpacing,
          mainAxisSpacing: gridSpacing,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final recipe = recipes[index];
            return FadeTransition(
              opacity: _animationController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOut,
                  ),
                ),
                child: _buildRecipeCard(recipe),
              ),
            );
          },
          childCount: recipes.length,
        ),
      ),
    );
  }

  Widget _buildRecipeCard(RecipeEntity recipe) {
    final profitMargin = recipe.sellingPrice > 0
        ? ((recipe.sellingPrice - (recipe.sellingPrice * 0.6)) /
                recipe.sellingPrice *
                100)
            .clamp(0, 100)
        : 0;

    // Assign color based on price range
    Color priceColor = Colors.green;
    IconData priceIcon = Icons.trending_up_rounded;
    if (recipe.sellingPrice < 10) {
      priceColor = Colors.blue;
      priceIcon = Icons.remove_rounded;
    } else if (recipe.sellingPrice > 50) {
      priceColor = Colors.purple;
      priceIcon = Icons.star_rounded;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to recipe details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            priceColor.withOpacity(0.2),
                            priceColor.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: priceColor,
                        size: 24,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: priceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(priceIcon, color: priceColor, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${profitMargin.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: priceColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Recipe name
                Text(
                  recipe.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),

                // Description
                if (recipe.description != null && recipe.description!.isNotEmpty)
                  Text(
                    recipe.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                  ),
                const Spacer(),

                // Ingredients badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_dining_rounded,
                        size: 14,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${recipe.ingredients.length} ingredients',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Price section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        priceColor.withOpacity(0.1),
                        priceColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money_rounded,
                            size: 16,
                            color: priceColor,
                          ),
                          Text(
                            recipe.sellingPrice.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: priceColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (recipe.recipeId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Unable to edit: invalid recipe id'),
                              ),
                            );
                            return;
                          }
                          _showEditDialog(context, recipe);
                        },
                        icon: const Icon(Icons.edit_rounded, size: 16),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (recipe.recipeId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Unable to delete: invalid recipe id'),
                            ),
                          );
                          return;
                        }
                        _showDeleteConfirmation(context, recipe.recipeId!);
                      },
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: Colors.red,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String recipeId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_rounded, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text('Delete Recipe'),
          ],
        ),
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

              if (!dialogContext.mounted) return;

              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        success
                            ? Icons.check_circle_rounded
                            : Icons.error_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        success
                            ? 'Recipe deleted successfully'
                            : 'Failed to delete recipe',
                      ),
                    ],
                  ),
                  backgroundColor:
                      success ? Colors.green.shade700 : Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, RecipeEntity recipe) {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.edit_rounded,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Edit Recipe'),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFormField(
                  controller: nameController,
                  label: 'Recipe Name',
                  hint: 'e.g., Chocolate Cake',
                  icon: Icons.menu_book_rounded,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: descriptionController,
                  label: 'Description',
                  hint: 'Brief description of the recipe',
                  icon: Icons.description_rounded,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: priceController,
                  label: 'Selling Price',
                  hint: 'e.g., 25.99',
                  icon: Icons.attach_money_rounded,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],
            ),
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

              if (!dialogContext.mounted) return;

              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        success
                            ? Icons.check_circle_rounded
                            : Icons.error_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        success
                            ? 'Recipe updated successfully'
                            : 'Failed to update recipe',
                      ),
                    ],
                  ),
                  backgroundColor:
                      success ? Colors.green.shade700 : Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        if (label == 'Selling Price') {
          if (double.tryParse(value.trim()) == null) {
            return 'Please enter a valid price';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
