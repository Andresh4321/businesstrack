import 'package:businesstrack/features/material/presentation/state/material_state.dart'
    as material_state_alias;
import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:businesstrack/features/stock/presentation/state/stock_state.dart'
    as stock_state_alias;
import 'package:businesstrack/features/stock/presentation/viewmodel/stock_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockManagementPage extends ConsumerStatefulWidget {
  const StockManagementPage({super.key});

  @override
  ConsumerState<StockManagementPage> createState() =>
      _StockManagementPageState();
}

class _StockManagementPageState extends ConsumerState<StockManagementPage> {
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(materialViewModelProvider.notifier).getAllMaterials();
      ref.read(stockViewModelProvider.notifier).getAllStockTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<stock_state_alias.StockState>(stockViewModelProvider, (
      previous,
      next,
    ) {
      if (previous?.status != stock_state_alias.StockStatus.error &&
          next.status == stock_state_alias.StockStatus.error &&
          (next.errorMessage?.isNotEmpty ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final stockState = ref.watch(stockViewModelProvider);
    final materialState = ref.watch(materialViewModelProvider);
    final materials = materialState.materials;
    final stockTransactions = stockState.stock;

    return Scaffold(
      appBar: AppBar(title: const Text('Stock Management'), elevation: 0),
      body:
          stockState.status == stock_state_alias.StockStatus.loading &&
              stockTransactions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildTopSummary(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildActionButtons(),
                          const SizedBox(height: 24),
                          _buildStockHistory(stockTransactions, materials),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTopSummary() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stock Management',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track and manage your inventory levels',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF45a049)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => _showStockDialog('add'),
              icon: const Icon(Icons.add_circle_outline, size: 24),
              label: const Text(
                'Add Stock',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF44336), Color(0xFFE53935)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => _showStockDialog('remove'),
              icon: const Icon(Icons.remove_circle_outline, size: 24),
              label: const Text(
                'Remove Stock',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialsGrid(List<dynamic> materials) {
    if (materials.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Icon(Icons.inventory_2, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'No materials available',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Material Stock Levels',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: materials.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final material = materials[index];
            return _buildMaterialCard(material);
          },
        ),
      ],
    );
  }

  Widget _buildMaterialCard(dynamic material) {
    final stock = material.minimumStock ?? 0;
    final isLowStock = stock <= 10;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isLowStock ? Colors.red.withOpacity(0.35) : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: isLowStock
                        ? Colors.red.withOpacity(0.1)
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.inventory_2,
                    color: isLowStock
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              material.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 4),
            if (isLowStock)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Low Stock',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Stock: ${stock.toStringAsFixed(0)} ${material.unit}',
              style: const TextStyle(fontSize: 12),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showAddRemoveQuickDialog('add', material),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Icon(Icons.add, size: 16),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _showAddRemoveQuickDialog('remove', material),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Icon(Icons.remove, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockHistory(
    List<StockEntity> transactions,
    List<dynamic> materials,
  ) {
    print(
      '🖥️ [StockHistoryUI] Rendering with ${transactions.length} transactions',
    );
    // Limit to 20 most recent transactions
    final limitedList = transactions.take(20).toList();
    final paginatedTransactions = _paginate(limitedList, _currentPage);
    print(
      '🖥️ [StockHistoryUI] Page $_currentPage shows ${paginatedTransactions.length} items',
    );
    final totalPages = (limitedList.length / _itemsPerPage).ceil();

    final materialNameById = <String, String>{};
    for (final material in materials) {
      final materialId = material.materialId?.toString();
      if (materialId != null && materialId.isNotEmpty) {
        materialNameById[materialId] = (material.name ?? 'Unknown Material')
            .toString();
      }
    }
    print(
      '🖥️ [StockHistoryUI] Material map has ${materialNameById.length} entries',
    );

    // Limit to 20 most recent transactions and sort newest first
    final sortedTransactions = [...transactions]
      ..sort(
        (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );
    final limitedTransactions = sortedTransactions.take(20).toList();

    final runningByMaterialId = <String, double>{};
    final stockAfterByTransactionId = <String, double>{};

    for (final tx in limitedTransactions) {
      final current = runningByMaterialId[tx.materialId] ?? 0.0;
      final isAdd = tx.transactionType.toLowerCase() != 'out';
      final updated = isAdd ? current + tx.quantity : current - tx.quantity;
      final clamped = updated < 0 ? 0.0 : updated;

      runningByMaterialId[tx.materialId] = clamped;
      if (tx.stockId != null) {
        stockAfterByTransactionId[tx.stockId!] = clamped;
      }
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stock History',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Recent stock adjustments',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            limitedList.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No stock adjustments yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Start by adding or removing stock',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      ...paginatedTransactions.map((transaction) {
                        final isAdd =
                            transaction.transactionType.toLowerCase() != 'out';
                        final materialName =
                            materialNameById[transaction.materialId] ??
                            'Material ${transaction.materialId}';

                        final stockAfter = transaction.stockId != null
                            ? (stockAfterByTransactionId[transaction
                                      .stockId!] ??
                                  0)
                            : (runningByMaterialId[transaction.materialId] ??
                                  0);

                        return _buildHistoryRow(
                          transaction,
                          isAdd,
                          materialName,
                          stockAfter,
                        );
                      }).toList(),
                      if (totalPages > 1) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Previous button
                              IconButton(
                                onPressed: _currentPage > 1
                                    ? () {
                                        setState(() {
                                          _currentPage--;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.chevron_left_rounded),
                                style: IconButton.styleFrom(
                                  backgroundColor: _currentPage > 1
                                      ? Theme.of(
                                          context,
                                        ).primaryColor.withOpacity(0.1)
                                      : Colors.grey[300],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Page numbers
                              ...List.generate(totalPages, (index) {
                                final pageNumber = index + 1;
                                final isActive = pageNumber == _currentPage;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _currentPage = pageNumber;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? Theme.of(context).primaryColor
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isActive
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey[400]!,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          pageNumber.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: isActive
                                                ? Colors.white
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(width: 8),
                              // Next button
                              IconButton(
                                onPressed: _currentPage < totalPages
                                    ? () {
                                        setState(() {
                                          _currentPage++;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.chevron_right_rounded),
                                style: IconButton.styleFrom(
                                  backgroundColor: _currentPage < totalPages
                                      ? Theme.of(
                                          context,
                                        ).primaryColor.withOpacity(0.1)
                                      : Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryRow(
    StockEntity transaction,
    bool isAdd,
    String materialName,
    double stockAfter,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAdd
              ? Colors.green.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isAdd
                    ? [const Color(0xFF4CAF50), const Color(0xFF45a049)]
                    : [const Color(0xFFF44336), const Color(0xFFE53935)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (isAdd ? Colors.green : Colors.red).withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              isAdd ? Icons.add_rounded : Icons.remove_rounded,
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
                  materialName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.description ??
                      (isAdd ? 'Stock added' : 'Stock removed'),
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Current Stock: ${stockAfter.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (isAdd ? Colors.green : Colors.red).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${isAdd ? '+' : '-'}${transaction.quantity.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isAdd ? Colors.green[700] : Colors.red[700],
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                transaction.createdAt?.toString().split(' ')[0] ?? '',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<StockEntity> _paginate(List<StockEntity> items, int page) {
    final start = (page - 1) * _itemsPerPage;
    if (start >= items.length) {
      return const [];
    }
    final end = start + _itemsPerPage;
    // Items are already sorted newest first, no need to reverse
    return items.sublist(start, end > items.length ? items.length : end);
  }

  Future<void> _showStockDialog(String actionType) async {
    final materialState = ref.read(materialViewModelProvider);
    final materials = materialState.materials;

    if (materials.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No materials available. Please add materials first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final formKey = GlobalKey<FormState>();
    String? selectedMaterialId = materials.first.materialId;
    final quantityController = TextEditingController();
    final remarksController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(actionType == 'add' ? 'Add Stock' : 'Remove Stock'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedMaterialId,
                        decoration: const InputDecoration(
                          labelText: 'Select Material',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: materials.map((m) {
                          return DropdownMenuItem(
                            value: m.materialId,
                            child: Text(m.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedMaterialId = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: remarksController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Remarks (Optional)',
                          hintText: actionType == 'add'
                              ? 'e.g., New shipment received'
                              : 'e.g., Spoiled items',
                          border: const OutlineInputBorder(),
                          isDense: true,
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

                    final quantity =
                        double.tryParse(quantityController.text) ?? 0;

                    await ref
                        .read(stockViewModelProvider.notifier)
                        .createStockTransaction(
                          materialId: selectedMaterialId!,
                          quantity: quantity,
                          transactionType: actionType == 'add' ? 'in' : 'out',
                          description: remarksController.text.isNotEmpty
                              ? remarksController.text
                              : null,
                        );

                    if (!mounted) {
                      return;
                    }

                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Stock ${actionType == 'add' ? 'added' : 'removed'} successfully',
                        ),
                        backgroundColor: actionType == 'add'
                            ? Colors.green
                            : Colors.red,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionType == 'add'
                        ? Colors.green
                        : Colors.red,
                  ),
                  child: Text(
                    actionType == 'add' ? 'Add Stock' : 'Remove Stock',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAddRemoveQuickDialog(
    String actionType,
    dynamic material,
  ) async {
    final quantityController = TextEditingController();
    final remarksController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            actionType == 'add'
                ? 'Add Stock to ${material.name}'
                : 'Remove Stock from ${material.name}',
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: remarksController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Remarks (Optional)',
                      hintText: actionType == 'add'
                          ? 'e.g., New shipment'
                          : 'e.g., Damaged',
                      border: const OutlineInputBorder(),
                      isDense: true,
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

                final quantity = double.tryParse(quantityController.text) ?? 0;

                await ref
                    .read(stockViewModelProvider.notifier)
                    .createStockTransaction(
                      materialId: material.materialId,
                      quantity: quantity,
                      transactionType: actionType == 'add' ? 'in' : 'out',
                      description: remarksController.text.isNotEmpty
                          ? remarksController.text
                          : null,
                    );

                if (!mounted) {
                  return;
                }

                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Stock ${actionType == 'add' ? 'added' : 'removed'} successfully',
                    ),
                    backgroundColor: actionType == 'add'
                        ? Colors.green
                        : Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: actionType == 'add'
                    ? Colors.green
                    : Colors.red,
              ),
              child: Text(actionType == 'add' ? 'Add Stock' : 'Remove Stock'),
            ),
          ],
        );
      },
    );
  }
}
