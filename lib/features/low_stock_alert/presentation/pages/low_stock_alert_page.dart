import 'package:businesstrack/core/utils/responsive_helper.dart';
import 'package:businesstrack/features/material/presentation/state/material_state.dart'
    as material_state_alias;
import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:businesstrack/features/low_stock_alert/presentation/viewmodel/low_stock_alert_viewmodel.dart';
import 'package:businesstrack/features/stock/presentation/pages/stock_management_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LowStockAlertPage extends ConsumerStatefulWidget {
  const LowStockAlertPage({super.key});

  @override
  ConsumerState<LowStockAlertPage> createState() => _LowStockAlertPageState();
}

class _LowStockAlertPageState extends ConsumerState<LowStockAlertPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lowStockAlertViewModelProvider.notifier).loadLowStockAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final materialState = ref.watch(materialViewModelProvider);
    final materials = materialState.materials;

    // Categorize materials based on ACTUAL stock levels (quantity) in real-time
    final criticalItems = materials
        .where((m) => m.quantity > 0 && m.quantity < (m.minimumStock * 0.3))
        .toList();
    final lowItems = materials
        .where((m) => m.quantity <= m.minimumStock && m.quantity > 0)
        .toList();
    final outOfStockItems = materials.where((m) => m.quantity == 0).toList();
    final normalItems = materials
        .where((m) => m.quantity > m.minimumStock)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Low Stock Alerts'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(materialViewModelProvider.notifier).getAllMaterials();
            },
            tooltip: 'Refresh Alerts',
          ),
        ],
      ),
      body: materials.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                _buildSummaryCards(
                  context,
                  criticalItems.length,
                  lowItems.length,
                  outOfStockItems.length,
                  normalItems.length,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (outOfStockItems.isNotEmpty) ...[
                            _buildOutOfStockSection(context, outOfStockItems),
                            const SizedBox(height: 24),
                          ],
                          if (criticalItems.isNotEmpty) ...[
                            _buildCriticalSection(context, criticalItems),
                            const SizedBox(height: 24),
                          ],
                          if (lowItems.isNotEmpty) ...[
                            _buildLowSection(context, lowItems),
                            const SizedBox(height: 24),
                          ],
                          if (normalItems.isNotEmpty) ...[
                            _buildNormalSection(context, normalItems),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inventory_2, size: 40, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              'No materials to monitor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Add materials to start tracking stock levels',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    int criticalCount,
    int lowCount,
    int outOfStockCount,
    int normalCount,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
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
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
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
                    Icons.warning_rounded,
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
                        'Stock Alerts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Real-time stock monitoring',
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
            crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
              context,
              mobile: 2,
              tablet: 4,
              desktop: 4,
            ),
            mainAxisSpacing: ResponsiveHelper.getGridSpacing(context),
            crossAxisSpacing: ResponsiveHelper.getGridSpacing(context),
            childAspectRatio: ResponsiveHelper.responsiveValue(
              context,
              mobile: 1.3,
              tablet: 1.4,
            ),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildMetricCard(
                context: context,
                icon: Icons.cancel_rounded,
                label: 'Out of Stock',
                value: outOfStockCount.toString(),
                color: const Color(0xFF8B0000),
                gradientEnd: const Color(0xFFD32F2F),
              ),
              _buildMetricCard(
                context: context,
                icon: Icons.error_rounded,
                label: 'Critical',
                value: criticalCount.toString(),
                color: const Color(0xFFF44336),
                gradientEnd: const Color(0xFFE53935),
              ),
              _buildMetricCard(
                context: context,
                icon: Icons.trending_down_rounded,
                label: 'Low Stock',
                value: lowCount.toString(),
                color: const Color(0xFFFF9800),
                gradientEnd: const Color(0xFFF57C00),
              ),
              _buildMetricCard(
                context: context,
                icon: Icons.check_circle_rounded,
                label: 'In Stock',
                value: normalCount.toString(),
                color: const Color(0xFF4CAF50),
                gradientEnd: const Color(0xFF388E3C),
              ),
            ],
          ),
        ],
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

  Widget _buildCriticalSection(BuildContext context, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.error_rounded,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Critical Stock (${items.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((material) => _buildCriticalCard(context, material)),
      ],
    );
  }

  Widget _buildOutOfStockSection(BuildContext context, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0000).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.cancel_rounded,
                  color: Color(0xFF8B0000),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Out of Stock (${items.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B0000),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((material) => _buildOutOfStockCard(context, material)),
      ],
    );
  }

  Widget _buildOutOfStockCard(BuildContext context, dynamic material) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, const Color(0xFF8B0000).withOpacity(0.08)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF8B0000).withOpacity(0.4),
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B0000), Color(0xFFD32F2F)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B0000).withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.inventory_2_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B0000).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'OUT OF STOCK',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '0 ${material.unit}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Min: ${material.minimumStock.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Reorder Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B0000),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalCard(BuildContext context, dynamic material) {
    final currentQty = material.quantity;
    final minQty = material.minimumStock;
    final fillPercent = minQty > 0
        ? (currentQty / minQty).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.red.withOpacity(0.08)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF44336), Color(0xFFE53935)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.inventory_2_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'CRITICAL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${currentQty.toStringAsFixed(0)} ${material.unit}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Min: ${minQty.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stock Level',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '${(fillPercent * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: fillPercent,
                  minHeight: 10,
                  backgroundColor: Colors.red.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StockManagementPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Restock Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowSection(BuildContext context, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_down_rounded,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Low Stock (${items.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((material) => _buildLowCard(context, material)),
      ],
    );
  }

  Widget _buildLowCard(BuildContext context, dynamic material) {
    final currentQty = material.quantity;
    final minQty = material.minimumStock;
    final fillPercent = minQty > 0
        ? (currentQty / minQty).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.orange.withOpacity(0.08)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.inventory_2_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'LOW STOCK',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${currentQty.toStringAsFixed(0)} ${material.unit}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Min: ${minQty.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stock Level',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '${(fillPercent * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: fillPercent,
                  minHeight: 10,
                  backgroundColor: Colors.orange.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StockManagementPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Add Stock'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalSection(BuildContext context, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Well Stocked (${items.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
              context,
              mobile: 2,
              tablet: 3,
              desktop: 4,
            ),
            crossAxisSpacing: ResponsiveHelper.getGridSpacing(context),
            mainAxisSpacing: ResponsiveHelper.getGridSpacing(context),
            childAspectRatio: ResponsiveHelper.getCardAspectRatio(context),
          ),
          itemBuilder: (context, index) {
            final material = items[index];
            return _buildNormalCard(context, material);
          },
        ),
      ],
    );
  }

  Widget _buildNormalCard(BuildContext context, dynamic material) {
    final currentQty = material.quantity;
    final minQty = material.minimumStock;
    final fillPercent = minQty > 0
        ? (currentQty / minQty).clamp(0.0, 1.0)
        : 1.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.green.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  material.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${currentQty.toStringAsFixed(0)} ${material.unit}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${(fillPercent * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fillPercent,
                    minHeight: 6,
                    backgroundColor: Colors.green.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
