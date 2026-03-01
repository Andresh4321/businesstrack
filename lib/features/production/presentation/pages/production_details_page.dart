import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProductionDetailsPage extends ConsumerStatefulWidget {
  final ProductionEntity? production;

  const ProductionDetailsPage({super.key, this.production});

  @override
  ConsumerState<ProductionDetailsPage> createState() =>
      _ProductionDetailsPageState();
}

class _ProductionDetailsPageState extends ConsumerState<ProductionDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final production = widget.production;

    if (production == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Production Details'), elevation: 0),
        body: const Center(child: Text('No production data available')),
      );
    }

    final wastagePercent = production.actualOutput != null
        ? ((production.estimatedOutput - production.actualOutput!) /
                  production.estimatedOutput *
                  100)
              .toStringAsFixed(1)
        : '0.0';
    final wastageColor = double.parse(wastagePercent) > 10
        ? Colors.red
        : Colors.green;

    return Scaffold(
      appBar: AppBar(title: const Text('Production Details'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          production.status.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Batch ${production.batchQuantity.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: production.status == 'ongoing'
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        production.status == 'ongoing'
                            ? 'In Progress'
                            : 'Completed',
                        style: TextStyle(
                          color: production.status == 'ongoing'
                              ? Colors.orange
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Details Section
            const Text(
              'Production Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Recipe ID', production.recipeId),
            _buildDetailRow(
              'Batch Quantity',
              production.batchQuantity.toStringAsFixed(0),
            ),
            _buildDetailRow(
              'Estimated Output',
              production.estimatedOutput.toStringAsFixed(0),
            ),
            if (production.actualOutput != null)
              _buildDetailRow(
                'Actual Output',
                production.actualOutput!.toStringAsFixed(0),
              ),
            const SizedBox(height: 16),

            // Performance Metrics
            const Text(
              'Performance Metrics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wastage',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$wastagePercent%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: wastageColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Efficiency',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(100 - double.parse(wastagePercent)).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Items Used
            if (production.itemsUsed.isNotEmpty) ...[
              const Text(
                'Materials Used',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: production.itemsUsed.length,
                itemBuilder: (context, index) {
                  final item = production.itemsUsed[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Material ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item.materialId,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${item.quantityUsed.toStringAsFixed(2)} ${item.unit}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],

            // Timestamps
            const Text(
              'Timeline',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (production.createdAt != null)
              _buildDetailRow(
                'Created',
                DateFormat(
                  'MMM dd, yyyy hh:mm a',
                ).format(production.createdAt!),
              ),
            if (production.updatedAt != null)
              _buildDetailRow(
                'Updated',
                DateFormat(
                  'MMM dd, yyyy hh:mm a',
                ).format(production.updatedAt!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
