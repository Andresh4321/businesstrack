import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:businesstrack/features/supplier/presentation/state/supplier.state.dart';
import 'package:businesstrack/features/supplier/presentation/view_model/supplier_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupplierFormPage extends ConsumerStatefulWidget {
  final String userId;
  final SupplierEntity? supplier;

  const SupplierFormPage({super.key, required this.userId, this.supplier});

  @override
  ConsumerState<SupplierFormPage> createState() => _SupplierFormPageState();
}

class _SupplierFormPageState extends ConsumerState<SupplierFormPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;

  List<TextEditingController> _productControllers = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier?.name ?? '');
    _emailController = TextEditingController(
      text: widget.supplier?.email ?? '',
    );
    _contactController = TextEditingController(
      text: widget.supplier?.contactName ?? '',
    );

    if (widget.supplier != null) {
      _productControllers = widget.supplier!.productNames
          .map((p) => TextEditingController(text: p))
          .toList();
    } else {
      _productControllers = [TextEditingController()];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    for (var controller in _productControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addProductField() {
    setState(() {
      _productControllers.add(TextEditingController());
    });
  }

  void _removeProductField(int index) {
    setState(() {
      _productControllers[index].dispose();
      _productControllers.removeAt(index);
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewmodel = ref.read(supplierViewmodelProvider.notifier);
    final productNames = _productControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => controller.text)
        .toList();

    if (productNames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one product'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.supplier == null) {
      // Add new supplier
      viewmodel.addSupplier(
        name: _nameController.text,
        email: _emailController.text,
        contactName: _contactController.text,
        productNames: productNames,
      );
    } else {
      // Update existing supplier
      viewmodel.updateSupplier(
        id: widget.supplier!.id,
        name: _nameController.text,
        email: _emailController.text,
        contactName: _contactController.text,
        productNames: productNames,
      );
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.supplier == null
              ? 'Supplier added successfully'
              : 'Supplier updated successfully',
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Pop after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supplierViewmodelProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.supplier == null ? 'Add Supplier' : 'Edit Supplier',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blueAccent),
                          SizedBox(width: 12),
                          Text(
                            'Basic Information',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Supplier Name Field
                    _buildTextField(
                      controller: _nameController,
                      label: 'Supplier Name',
                      hint: 'Enter supplier name',
                      icon: Icons.business,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Supplier name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'Enter email address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        ).hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Contact Name Field
                    _buildTextField(
                      controller: _contactController,
                      label: 'Contact Person',
                      hint: 'Enter contact person name',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Contact person name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Products Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.inventory_2, color: Colors.green),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Products & Services',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_productControllers.where((c) => c.text.isNotEmpty).length}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Product Fields
                    ..._productControllers.asMap().entries.map((entry) {
                      int idx = entry.key;
                      TextEditingController controller = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                decoration: InputDecoration(
                                  labelText: 'Product ${idx + 1}',
                                  hintText: 'e.g., Laptops, Software, Services',
                                  prefixIcon: const Icon(Icons.tag),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      value.length < 2) {
                                    return 'Product name too short';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (_productControllers.length > 1)
                              IconButton(
                                onPressed: () => _removeProductField(idx),
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              )
                            else
                              const SizedBox(width: 48),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 8),

                    // Add Product Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _addProductField,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Product'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.status == SupplierStatus.loading
                            ? null
                            : _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state.status == SupplierStatus.loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.supplier == null
                                    ? 'Add Supplier'
                                    : 'Update Supplier',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          if (state.status == SupplierStatus.failure)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.red.withOpacity(0.1),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.errorMessage ?? 'An error occurred',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
    );
  }
}
