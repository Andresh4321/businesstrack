import 'package:businesstrack/features/supplier/presentation/pages/supplier_form_page.dart';
import 'package:businesstrack/features/supplier/presentation/state/supplier.state.dart';
import 'package:businesstrack/features/supplier/presentation/view_model/supplier_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupplierListPage extends ConsumerStatefulWidget {
  final String userId;

  const SupplierListPage({super.key, required this.userId});

  @override
  ConsumerState<SupplierListPage> createState() => _SupplierListPageState();
}

class _SupplierListPageState extends ConsumerState<SupplierListPage> {
  String _searchQuery = '';
  String _searchType = 'name'; // 'name' or 'product'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewmodel = ref.read(supplierViewmodelProvider.notifier);
      viewmodel.setUserId(widget.userId);
      viewmodel.getSuppliers();
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });

    if (query.isEmpty) {
      ref.read(supplierViewmodelProvider.notifier).clearSearch();
    } else if (_searchType == 'name') {
      ref.read(supplierViewmodelProvider.notifier).searchSuppliersByName(query);
    } else {
      ref
          .read(supplierViewmodelProvider.notifier)
          .searchSuppliersByProduct(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final supplierState = ref.watch(supplierViewmodelProvider);
    final viewmodel = ref.read(supplierViewmodelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Suppliers',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  value: _searchType,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: 'name',
                      child: Row(
                        children: const [
                          Icon(Icons.business, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Name', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'product',
                      child: Row(
                        children: const [
                          Icon(
                            Icons.inventory_2,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Product',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _searchType = value;
                        _searchQuery = '';
                      });
                    }
                  },
                  dropdownColor: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SupplierFormPage(userId: widget.userId),
            ),
          ).then((_) {
            viewmodel.getSuppliers();
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Supplier'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _handleSearch,
              decoration: InputDecoration(
                hintText:
                    'Search by ${_searchType == "name" ? "supplier name" : "product"}...',
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                          viewmodel.clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: supplierState.status == SupplierStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  )
                : supplierState.status == SupplierStatus.failure
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          supplierState.errorMessage ??
                              'Failed to load suppliers',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => viewmodel.getSuppliers(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : supplierState.suppliers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.business_center,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No suppliers found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first supplier to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: supplierState.suppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = supplierState.suppliers[index];
                      return _SupplierCard(
                        supplier: supplier,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SupplierFormPage(
                                userId: widget.userId,
                                supplier: supplier,
                              ),
                            ),
                          ).then((_) {
                            viewmodel.getSuppliers();
                          });
                        },
                        onDelete: () {
                          _showDeleteConfirmation(
                            context,
                            supplier.id,
                            viewmodel,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String supplierId,
    SupplierViewmodel viewmodel,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Supplier'),
        content: const Text(
          'Are you sure you want to delete this supplier? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewmodel.deleteSupplier(supplierId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  final dynamic supplier;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SupplierCard({
    required this.supplier,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showSupplierDetails(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.business,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supplier.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          supplier.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                        onTap: onEdit,
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      icon: Icons.person,
                      label: 'Contact',
                      value: supplier.contactName,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: List.generate(
                        supplier.productNames.length,
                        (index) => Chip(
                          label: Text(supplier.productNames[index]),
                          backgroundColor: Colors.greenAccent.withOpacity(0.2),
                          labelStyle: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSupplierDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: Colors.blueAccent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplier.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        supplier.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Contact Person',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(supplier.contactName, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            const Text(
              'Products',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(
                supplier.productNames.length,
                (index) => Chip(
                  label: Text(supplier.productNames[index]),
                  backgroundColor: Colors.greenAccent.withOpacity(0.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
