import 'package:flutter/material.dart';
import 'material_model.dart';
import 'material_card.dart';
import 'material_dialog.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({super.key});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  final List<MaterialModel> materials = [];

  void _addOrUpdate(MaterialModel material) {
    setState(() {
      final index =
          materials.indexWhere((m) => m.id == material.id);
      if (index == -1) {
        materials.add(material);
      } else {
        materials[index] = material;
      }
    });
  }

  void _delete(MaterialModel material) {
    setState(() {
      materials.remove(material);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Raw Materials")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => MaterialDialog(onSubmit: _addOrUpdate),
        ),
        child: const Icon(Icons.add),
      ),
      body: materials.isEmpty
          ? const Center(child: Text("No materials yet"))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: materials.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {
                final material = materials[index];
                return MaterialCard(
                  material: material,
                  onEdit: () => showDialog(
                    context: context,
                    builder: (_) => MaterialDialog(
                      material: material,
                      onSubmit: _addOrUpdate,
                    ),
                  ),
                  onDelete: () => _delete(material),
                );
              },
            ),
    );
  }
}