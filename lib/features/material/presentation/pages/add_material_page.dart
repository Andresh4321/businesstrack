import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMaterialPage extends ConsumerStatefulWidget {
  const AddMaterialPage({super.key});

  @override
  ConsumerState<AddMaterialPage> createState() => _AddMaterialPageState();
}

class _AddMaterialPageState extends ConsumerState<AddMaterialPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _unitController;
  late TextEditingController _unitPriceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _unitController = TextEditingController();
    _unitPriceController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _unitController.dispose();
    _unitPriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Material'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Material Name',
                  hintText: 'Enter material name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter material name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter material description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Unit
              TextFormField(
                controller: _unitController,
                decoration: InputDecoration(
                  labelText: 'Unit',
                  hintText: 'e.g., kg, L, pcs',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter unit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Unit Price
              TextFormField(
                controller: _unitPriceController,
                decoration: InputDecoration(
                  labelText: 'Unit Price',
                  hintText: 'Enter unit price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter unit price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Quantity (Minimum Stock)
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Minimum Stock',
                  hintText: 'Enter minimum stock quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter minimum stock';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final name = _nameController.text.trim();
                      final description = _descriptionController.text.trim();
                      final unit = _unitController.text.trim();
                      final unitPrice =
                          double.tryParse(_unitPriceController.text.trim()) ??
                          0;
                      final quantity = int.tryParse(
                        _quantityController.text.trim(),
                      );

                      // Call add material from ViewModel
                      await ref
                          .read(materialViewModelProvider.notifier)
                          .addMaterial(
                            name: name,
                            description: description.isEmpty
                                ? null
                                : description,
                            unit: unit.isEmpty ? null : unit,
                            unitPrice: unitPrice,
                            quantity: quantity,
                          );

                      // Wait a moment then navigate back
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Material added successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Add Material'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
