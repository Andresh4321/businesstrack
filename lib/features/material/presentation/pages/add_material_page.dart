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
  late TextEditingController _unitPriceController;
  late TextEditingController _minimumStockController;
  late TextEditingController _quantityController;

  // Dropdown options for unit
  final List<String> _unitOptions = ['kg', 'liter', 'pieces'];
  String? _selectedUnit;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _unitPriceController = TextEditingController();
    _minimumStockController = TextEditingController();
    _quantityController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: hintColor, fontWeight: FontWeight.w600),
      floatingLabelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
      hintStyle: TextStyle(color: hintColor),
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade700, width: 2),
      ),
      errorStyle: TextStyle(
        color: Colors.red.shade700,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
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
                color: isDark ? const Color(0xFF181818) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                        cursorColor: Theme.of(context).colorScheme.primary,
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
                        style: TextStyle(color: textColor),
                        cursorColor: Theme.of(context).colorScheme.primary,
                        decoration: _decoration(
                          label: 'Description (Optional)',
                          hint: 'Short notes about this material',
                          icon: Icons.notes_outlined,
                        ),
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 420;

                          final unitField = DropdownButtonFormField<String>(
                            value: _selectedUnit,
                            isExpanded: true,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                            dropdownColor: isDark
                                ? const Color(0xFF1E1E1E)
                                : Colors.white,
                            decoration: _decoration(
                              label: 'Unit',
                              hint: 'Select unit',
                              icon: Icons.straighten_outlined,
                            ),
                            items: _unitOptions.map((String unit) {
                              return DropdownMenuItem<String>(
                                value: unit,
                                child: Text(unit),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedUnit = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select unit';
                              }
                              return null;
                            },
                          );

                          final unitPriceField = TextFormField(
                            controller: _unitPriceController,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                            cursorColor: Theme.of(context).colorScheme.primary,
                            decoration: _decoration(
                              label: 'Unit Price',
                              hint: '0.00',
                              icon: Icons.attach_money_outlined,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
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
                          );

                          if (isNarrow) {
                            return Column(
                              children: [
                                unitField,
                                const SizedBox(height: 12),
                                unitPriceField,
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(child: unitField),
                              const SizedBox(width: 12),
                              Expanded(child: unitPriceField),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _minimumStockController,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                        cursorColor: Theme.of(context).colorScheme.primary,
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
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                        cursorColor: Theme.of(context).colorScheme.primary,
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
                            final description = _descriptionController.text
                                .trim();
                            final unit = _selectedUnit;
                            final unitPrice =
                                double.tryParse(_unitPriceController.text) ?? 0;
                            final minimumStock =
                                double.tryParse(
                                  _minimumStockController.text.trim(),
                                ) ??
                                0;
                            final quantity =
                                double.tryParse(
                                  _quantityController.text.trim(),
                                ) ??
                                0;

                            await ref
                                .read(materialViewModelProvider.notifier)
                                .addMaterial(
                                  name: name,
                                  description: description.isEmpty
                                      ? null
                                      : description,
                                  unit: unit,
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
