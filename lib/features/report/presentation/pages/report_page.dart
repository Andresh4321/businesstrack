import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/core/utils/responsive_helper.dart';
import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/production/presentation/viewmodel/production_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(materialViewModelProvider.notifier).getAllMaterials();
      ref.read(productionViewModelProvider.notifier).getAllProduction();
    });
  }

  @override
  Widget build(BuildContext context) {
    final materialState = ref.watch(materialViewModelProvider);
    final productionState = ref.watch(productionViewModelProvider);

    final materials = materialState.materials;
    final batches = productionState.production;
    final completedBatches = batches
        .where((b) => b.status == 'completed')
        .toList();
    final lowStockCount = materials
        .where((m) => m.quantity <= m.minimumStock)
        .length;

    final avgWastage = completedBatches.isEmpty
        ? 0.0
        : completedBatches
                  .map(_calculateWastagePercent)
                  .reduce((a, b) => a + b) /
              completedBatches.length;

    final totalProduction = completedBatches.fold<double>(
      0,
      (sum, b) => sum + b.batchQuantity,
    );

    final totalInventoryValue = materials.fold<double>(
      0,
      (sum, material) => sum + (material.quantity * material.unitPrice),
    );

    final dailyData = _buildLast7DaysData(completedBatches);
    final topConsumedMaterials = _buildTopConsumedMaterials(
      completedBatches,
      materials,
    );

    final stockDistribution = [...materials]
      ..sort(
        (a, b) =>
            (b.quantity * b.unitPrice).compareTo(a.quantity * a.unitPrice),
      );

    final topStockDistribution = stockDistribution.take(4).toList();

    final loading =
        (materialState.status.name == 'loading' && materials.isEmpty) ||
        (productionState.status.name == 'loading' && batches.isEmpty);

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Analytics'), elevation: 0),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(
                ResponsiveHelper.getHorizontalPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                      mobile: 1.25,
                      tablet: 1.3,
                    ),
                    children: [
                      _buildSummaryCard(
                        title: 'Total Materials',
                        value: '${materials.length}',
                        subtitle: 'Tracked items',
                        icon: Icons.inventory_2,
                        color: Colors.blue,
                      ),
                      _buildSummaryCard(
                        title: 'Total Batches',
                        value: '${batches.length}',
                        subtitle: '${completedBatches.length} completed',
                        icon: Icons.factory,
                        color: Colors.deepPurple,
                      ),
                      _buildSummaryCard(
                        title: 'Low Stock Items',
                        value: '$lowStockCount',
                        subtitle: 'Need restocking',
                        icon: Icons.trending_down,
                        color: lowStockCount > 0 ? Colors.red : Colors.green,
                      ),
                      _buildSummaryCard(
                        title: 'Avg Wastage',
                        value: '${avgWastage.toStringAsFixed(1)}%',
                        subtitle: 'Per batch',
                        icon: Icons.bar_chart,
                        color: avgWastage > 10 ? Colors.orange : Colors.green,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildChartCard(
                    title: 'Daily Production',
                    subtitle: 'Units produced over last 7 days',
                    rightLabel: 'Last 7 days',
                    child: _buildVerticalBarChart(
                      dailyData,
                      (d) => d.production,
                      barColor: const Color(0xFFF97316),
                      valueSuffix: 'u',
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildChartCard(
                    title: 'Daily Wastage %',
                    subtitle: 'Wastage percentage over last 7 days',
                    child: _buildVerticalBarChart(
                      dailyData,
                      (d) => d.wastage,
                      barColor: const Color(0xFFF59E0B),
                      valueSuffix: '%',
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildChartCard(
                    title: 'Top Consumed Materials',
                    subtitle: 'Most used raw materials in production',
                    child: topConsumedMaterials.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text('No consumption data yet'),
                            ),
                          )
                        : Column(
                            children: topConsumedMaterials.map((item) {
                              final maxValue = topConsumedMaterials.first.value;
                              final ratio = maxValue == 0
                                  ? 0.0
                                  : item.value / maxValue;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${item.value.toStringAsFixed(1)} units',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    LinearProgressIndicator(
                                      value: ratio,
                                      minHeight: 8,
                                      borderRadius: BorderRadius.circular(999),
                                      backgroundColor: Colors.grey[200],
                                      valueColor: const AlwaysStoppedAnimation(
                                        Color(0xFF10B981),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),

                  const SizedBox(height: 12),

                  _buildChartCard(
                    title: 'Inventory Value',
                    subtitle: 'Distribution by material',
                    child: topStockDistribution.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: Text('No inventory data')),
                          )
                        : Column(
                            children: [
                              ...topStockDistribution.map((material) {
                                final materialValue =
                                    material.quantity * material.unitPrice;
                                final ratio = totalInventoryValue == 0
                                    ? 0.0
                                    : materialValue / totalInventoryValue;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              material.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            '\$${materialValue.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      LinearProgressIndicator(
                                        value: ratio,
                                        minHeight: 8,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        backgroundColor: Colors.grey[200],
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                              Color(0xFF3B82F6),
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 8),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Inventory',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '\$${totalInventoryValue.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(height: 12),

                  _buildInsightCard(
                    color: const Color(0xFF3B82F6),
                    icon: Icons.payments,
                    title: 'Cost Insights',
                    description:
                        'Track manpower, utilities, and packaging next for full profitability analytics.',
                    tip: 'Tip: Add expense categories in next update',
                  ),
                  const SizedBox(height: 10),
                  _buildInsightCard(
                    color: const Color(0xFF10B981),
                    icon: Icons.trending_down,
                    title: 'Wastage Reduction',
                    description:
                        'Average wastage is ${avgWastage.toStringAsFixed(1)}%. Industry target is below 5%.',
                    tip: avgWastage < 5 ? 'Great job!' : 'Room for improvement',
                  ),
                  const SizedBox(height: 10),
                  _buildInsightCard(
                    color: const Color(0xFFF59E0B),
                    icon: Icons.factory,
                    title: 'Production Rate',
                    description:
                        'Total production: ${totalProduction.toStringAsFixed(0)} units from ${completedBatches.length} completed batches.',
                    tip:
                        'Avg: ${(completedBatches.isEmpty ? 0 : (totalProduction / completedBatches.length)).toStringAsFixed(1)} units/batch',
                  ),
                ],
              ),
            ),
    );
  }

  List<_DailyMetric> _buildLast7DaysData(
    List<ProductionEntity> completedBatches,
  ) {
    final today = DateTime.now();
    return List.generate(7, (index) {
      final date = DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(Duration(days: 6 - index));

      final dayBatches = completedBatches.where((batch) {
        final sourceDate = batch.updatedAt ?? batch.createdAt;
        if (sourceDate == null) return false;
        return sourceDate.year == date.year &&
            sourceDate.month == date.month &&
            sourceDate.day == date.day;
      }).toList();

      final production = dayBatches.fold<double>(
        0,
        (sum, batch) => sum + batch.batchQuantity,
      );

      final wastage = dayBatches.isEmpty
          ? 0.0
          : dayBatches.map(_calculateWastagePercent).reduce((a, b) => a + b) /
                dayBatches.length;

      return _DailyMetric(
        label: DateFormat('EEE').format(date),
        production: production,
        wastage: wastage,
      );
    });
  }

  List<_MaterialUsage> _buildTopConsumedMaterials(
    List<ProductionEntity> completedBatches,
    List<MaterialEntity> materials,
  ) {
    final materialNameById = {
      for (final material in materials)
        if (material.materialId != null) material.materialId!: material.name,
    };

    final consumptionByMaterialId = <String, double>{};

    for (final batch in completedBatches) {
      for (final item in batch.itemsUsed) {
        consumptionByMaterialId[item.materialId] =
            (consumptionByMaterialId[item.materialId] ?? 0) + item.quantityUsed;
      }
    }

    final items =
        consumptionByMaterialId.entries
            .map(
              (entry) => _MaterialUsage(
                name: materialNameById[entry.key] ?? entry.key,
                value: entry.value,
              ),
            )
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return items.take(5).toList();
  }

  double _calculateWastagePercent(ProductionEntity batch) {
    if (batch.estimatedOutput <= 0) return 0.0;
    if (batch.actualOutput == null) return 0.0;

    final percent =
        ((batch.estimatedOutput - batch.actualOutput!) /
            batch.estimatedOutput) *
        100;
    return percent < 0 ? 0.0 : percent;
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget child,
    String? rightLabel,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (rightLabel != null)
                  Text(
                    rightLabel,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalBarChart(
    List<_DailyMetric> data,
    double Function(_DailyMetric) valueSelector, {
    required Color barColor,
    required String valueSuffix,
  }) {
    final maxValue = data.isEmpty
        ? 1.0
        : data.map(valueSelector).reduce((a, b) => a > b ? a : b);
    final normalizedMax = maxValue <= 0 ? 1.0 : maxValue;

    return SizedBox(
      height: 170,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((entry) {
          final value = valueSelector(entry);
          final ratio = value / normalizedMax;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${value.toStringAsFixed(0)}$valueSuffix',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 100,
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: ratio.clamp(0.05, 1.0),
                      widthFactor: 0.75,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.label,
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInsightCard({
    required Color color,
    required IconData icon,
    required String title,
    required String description,
    required String tip,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 6),
            Text(
              tip,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyMetric {
  final String label;
  final double production;
  final double wastage;

  const _DailyMetric({
    required this.label,
    required this.production,
    required this.wastage,
  });
}

class _MaterialUsage {
  final String name;
  final double value;

  const _MaterialUsage({required this.name, required this.value});
}
