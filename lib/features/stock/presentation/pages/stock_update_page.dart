import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:businesstrack/features/stock/presentation/state/stock_state.dart'
    as stock_vm_state;
import 'package:businesstrack/features/stock/presentation/viewmodel/stock_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockUpdatePage extends ConsumerStatefulWidget {
  const StockUpdatePage({super.key});

  @override
  ConsumerState<StockUpdatePage> createState() => _StockUpdatePageState();
}

class _StockUpdatePageState extends ConsumerState<StockUpdatePage> {
  String? selectedMaterialId;
  final quantityController = TextEditingController();
  final remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(materialViewModelProvider.notifier).getAllMaterials();
      ref.read(stockViewModelProvider.notifier).getAllStockTransactions();
    });
  }

  @override
  void dispose() {
    quantityController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  Future<void> _handleStockTransaction(String type) async {
    if (selectedMaterialId == null || quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select material and enter quantity'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final quantity = double.tryParse(quantityController.text.trim());
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid quantity'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await ref
        .read(stockViewModelProvider.notifier)
        .createStockTransaction(
          materialId: selectedMaterialId!,
          quantity: quantity,
          transactionType: type,
          description: remarksController.text.trim().isEmpty
              ? null
              : remarksController.text.trim(),
        );

    quantityController.clear();
    remarksController.clear();
    selectedMaterialId = null;
    setState(() {});

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Stock ${type == 'in' ? 'added' : 'removed'} successfully',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final materialState = ref.watch(materialViewModelProvider);
    final materials = materialState.materials;
    final stockState = ref.watch(stockViewModelProvider);

    ref.listen<stock_vm_state.StockState>(stockViewModelProvider, (
      previous,
      next,
    ) {
      if (previous?.status != stock_vm_state.StockStatus.error &&
          next.status == stock_vm_state.StockStatus.error &&
          (next.errorMessage?.isNotEmpty ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Stock Management'), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.inventory,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stock Adjustments',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${stockState.stock.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Material Selection
              Text(
                'Select Material',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String?>(
                value: selectedMaterialId,
                hint: const Text('Select a material'),
                items: materials
                    .map(
                      (m) => DropdownMenuItem(
                        value: m.materialId,
                        child: Text(m.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMaterialId = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Quantity Input
              Text('Quantity', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: quantityController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Remarks
              Text(
                'Remarks (Optional)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: remarksController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add notes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          stockState.status ==
                              stock_vm_state.StockStatus.loading
                          ? null
                          : () => _handleStockTransaction('in'),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Stock'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          stockState.status ==
                              stock_vm_state.StockStatus.loading
                          ? null
                          : () => _handleStockTransaction('out'),
                      icon: const Icon(Icons.remove),
                      label: const Text('Remove Stock'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Transactions
              Text(
                'Recent Adjustments',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (stockState.stock.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  alignment: Alignment.center,
                  child: Text(
                    'No adjustments yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stockState.stock.length > 5
                      ? 5
                      : stockState.stock.length,
                  itemBuilder: (context, index) {
                    final transaction = stockState.stock[index];
                    final isIncoming = transaction.transactionType == 'in';

                    return Card(
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isIncoming
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isIncoming
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: isIncoming ? Colors.green : Colors.red,
                          ),
                        ),
                        title: Text(transaction.materialId),
                        subtitle: Text(
                          transaction.description ?? 'No remarks',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          '${isIncoming ? '+' : '-'}${transaction.quantity}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isIncoming ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
