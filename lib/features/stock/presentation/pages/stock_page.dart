import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockListPage extends ConsumerStatefulWidget {
  const StockListPage({super.key});

  @override
  ConsumerState<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends ConsumerState<StockListPage> {
  @override
  void initState() {
    super.initState();
    // TODO: Load all stock
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Management'), elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Stock List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'No stock items added yet',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Update Stock',
        onPressed: () {
          // TODO: Navigate to update stock page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
