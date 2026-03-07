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
  late TextEditingController _minimumStockController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _unitController = TextEditingController();
    _unitPriceController = TextEditingController();
    _minimumStockController = TextEditingController();
    _quantityController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _unitController.dispose();
    _unitPriceController.dispose();
    _minimumStockController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  InputDecoration _decoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('Add Material'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: _decoration(
                          label: 'Material Name',
                          hint: 'e.g., Flour',
                          icon: Icons.inventory_2_outlined,
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter material name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: _decoration(
                          label: 'Description (Optional)',
                          hint: 'Short notes about this material',
                          icon: Icons.notes_outlined,
                        ),
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _unitController,
                              decoration: _decoration(
                                label: 'Unit',
                                hint: 'kg, L, pcs',
                                icon: Icons.straighten_outlined,
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter unit';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _unitPriceController,
                              decoration: _decoration(
                                label: 'Unit Price',
                                hint: '0.00',
                                icon: Icons.attach_money_outlined,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter price';
                                }
                                final parsed = double.tryParse(value.trim());
                                if (parsed == null) {
                                  return 'Invalid number';
                                }
                                if (parsed < 0) {
                                  return 'Must be >= 0';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _minimumStockController,
                        decoration: _decoration(
                          label: 'Minimum Stock',
                          hint: 'Low stock alert threshold',
                          icon: Icons.warning_amber_outlined,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter minimum stock';
                          }
                          final parsed = double.tryParse(value.trim());
                          if (parsed == null) {
                            return 'Invalid number';
                          }
                          if (parsed < 0) {
                            return 'Must be >= 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _quantityController,
                        decoration: _decoration(
                          label: 'Initial Stock',
                          hint: 'Defaults to 0 when left empty',
                          icon: Icons.inventory_outlined,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null; // Optional; will default to 0
                          }
                          final parsed = double.tryParse(value.trim());
                          if (parsed == null) {
                            return 'Invalid number';
                          }
                          if (parsed < 0) {
                            return 'Must be >= 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save_outlined),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            final name = _nameController.text.trim();
                            final description =
                                _descriptionController.text.trim();
                            final unit = _unitController.text.trim();
                            final unitPrice =
                                double.tryParse(_unitPriceController.text) ?? 0;
                            final minimumStock = double.tryParse(
                                  _minimumStockController.text.trim(),
                                ) ??
                                0;
                            final quantity = double.tryParse(
                                  _quantityController.text.trim(),
                                ) ??
                                0;

                            await ref
                                .read(materialViewModelProvider.notifier)
                                .addMaterial(
                                  name: name,
                                  description:
                                      description.isEmpty ? null : description,
                                  unit: unit.isEmpty ? null : unit,
                                  unitPrice: unitPrice,
                                  minimumStock: minimumStock,
                                  quantity: quantity,
                                );

                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Material added successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          label: const Text('Save Material'),
                        ),
                      ),
                    ],
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
