import 'package:businesstrack/core/services/storage/user_session_service.dart';
import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:businesstrack/features/material/presentation/state/material_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BillOfMaterialsPage extends ConsumerStatefulWidget {
  const BillOfMaterialsPage({super.key});

  @override
  ConsumerState<BillOfMaterialsPage> createState() =>
      _BillOfMaterialsPageState();
}

class _BillOfMaterialsPageState extends ConsumerState<BillOfMaterialsPage> {
  String _userId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserDataAndMaterials();
    });
  }

  Future<void> _loadUserDataAndMaterials() async {
    final prefs = await SharedPreferences.getInstance();
    final userSessionService = UserSessionService(prefs: prefs);
    final userId = userSessionService.getCurrentUserId();
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      // Load materials
      if (mounted) {
        ref.read(materialViewModelProvider.notifier).getAllMaterials();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final materialState = ref.watch(materialViewModelProvider);

    if (materialState.status == MaterialStatus.loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bill of Materials')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (materialState.status == MaterialStatus.error) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bill of Materials')),
        body: Center(child: Text('Error: ${materialState.errorMessage}')),
      );
    }

    if (materialState.materials.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bill of Materials')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text(
                'No materials available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Add materials from the Materials section to see them here',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    // Calculate real-time metrics using actual current stock
    final totalValue = materialState.materials.fold<double>(
      0,
      (sum, material) => sum + (material.quantity * material.unitPrice),
    );

    final totalQuantity = materialState.materials.fold<double>(
      0,
      (sum, material) => sum + material.quantity,
    );

    final lowStockCount = materialState.materials.where((material) {
      return material.quantity > 0 &&
          material.quantity <= material.minimumStock;
    }).length;

    final outOfStockCount = materialState.materials.where((material) {
      return material.quantity == 0;
    }).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill of Materials'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(materialViewModelProvider.notifier).getAllMaterials();
            },
            tooltip: 'Refresh Inventory',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Main Header Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.description_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bill of Materials',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Real-time inventory valuation',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Metrics Grid
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildMetricCard(
                        context: context,
                        icon: Icons.category_rounded,
                        label: 'Total Materials',
                        value: materialState.materials.length.toString(),
                        color: const Color(0xFF2196F3),
                        gradientEnd: const Color(0xFF1976D2),
                      ),
                      _buildMetricCard(
                        context: context,
                        icon: Icons.inventory_rounded,
                        label: 'Units in Stock',
                        value: totalQuantity.toStringAsFixed(0),
                        color: const Color(0xFF4CAF50),
                        gradientEnd: const Color(0xFF388E3C),
                      ),
                      _buildMetricCard(
                        context: context,
                        icon: Icons.attach_money_rounded,
                        label: 'Total Value',
                        value: '₹${totalValue.toStringAsFixed(0)}',
                        color: const Color(0xFFFF9800),
                        gradientEnd: const Color(0xFFF57C00),
                      ),
                      _buildMetricCard(
                        context: context,
                        icon: Icons.warning_amber_rounded,
                        label: lowStockCount > 0
                            ? 'Low Stock Items'
                            : 'Stock Status',
                        value: lowStockCount > 0
                            ? lowStockCount.toString()
                            : outOfStockCount > 0
                            ? '$outOfStockCount Out'
                            : 'Good',
                        color: lowStockCount > 0 || outOfStockCount > 0
                            ? const Color(0xFFF44336)
                            : const Color(0xFF4CAF50),
                        gradientEnd: lowStockCount > 0 || outOfStockCount > 0
                            ? const Color(0xFFD32F2F)
                            : const Color(0xFF388E3C),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Materials List
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inventory Breakdown',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Detailed view of all materials and their values',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  ...materialState.materials.map((material) {
                    final name = material.name;
                    final quantity =
                        material.quantity; // Real-time current stock
                    final unit = material.unit;
                    final cost = material.unitPrice;
                    final totalItemValue = quantity * cost;
                    final minStock = material.minimumStock;
                    final isLowStock = quantity > 0 && quantity <= minStock;
                    final isOutOfStock = quantity == 0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            isOutOfStock
                                ? Colors.red.withOpacity(0.05)
                                : isLowStock
                                ? Colors.orange.withOpacity(0.05)
                                : Colors.green.withOpacity(0.05),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isOutOfStock
                              ? Colors.red.withOpacity(0.3)
                              : isLowStock
                              ? Colors.orange.withOpacity(0.3)
                              : Colors.green.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isOutOfStock
                                          ? [
                                              const Color(0xFFF44336),
                                              const Color(0xFFE53935),
                                            ]
                                          : isLowStock
                                          ? [
                                              const Color(0xFFFF9800),
                                              const Color(0xFFF57C00),
                                            ]
                                          : [
                                              const Color(0xFF4CAF50),
                                              const Color(0xFF388E3C),
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            (isOutOfStock
                                                    ? Colors.red
                                                    : isLowStock
                                                    ? Colors.orange
                                                    : Colors.green)
                                                .withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isOutOfStock
                                        ? Icons.remove_circle_outline_rounded
                                        : isLowStock
                                        ? Icons.warning_amber_rounded
                                        : Icons.check_circle_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isOutOfStock
                                              ? Colors.red.withOpacity(0.15)
                                              : isLowStock
                                              ? Colors.orange.withOpacity(0.15)
                                              : Colors.blue.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          isOutOfStock
                                              ? 'OUT OF STOCK'
                                              : isLowStock
                                              ? 'LOW STOCK'
                                              : 'IN STOCK',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: isOutOfStock
                                                ? Colors.red[700]
                                                : isLowStock
                                                ? Colors.orange[700]
                                                : Colors.blue[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoColumn(
                                      'Current Stock',
                                      '$quantity $unit',
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoColumn(
                                      'Unit Price',
                                      '₹${cost.toStringAsFixed(2)}',
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoColumn(
                                      'Total Value',
                                      '₹${totalItemValue.toStringAsFixed(2)}',
                                      highlight: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isLowStock || isOutOfStock) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isOutOfStock
                                      ? Colors.red.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      size: 16,
                                      color: isOutOfStock
                                          ? Colors.red[700]
                                          : Colors.orange[700],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        isOutOfStock
                                            ? 'Stock depleted. Reorder required.'
                                            : 'Stock below minimum threshold (${minStock.toStringAsFixed(0)} $unit)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isOutOfStock
                                              ? Colors.red[700]
                                              : Colors.orange[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  // Grand Total Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Inventory Value',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${materialState.materials.length} materials',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '₹${totalValue.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color gradientEnd,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
    String label,
    String value, {
    bool highlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: highlight ? Colors.blue : Colors.black87,
          ),
        ),
      ],
    );
  }
}
