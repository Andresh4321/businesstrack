import 'package:businesstrack/features/items/data/models/materialmodel.dart';
import 'package:flutter/material.dart';

class MaterialItem extends StatelessWidget {
  final MaterialModel material;
  final VoidCallback onTap;

  const MaterialItem({
    super.key,
    required this.material,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isLowStock = material.currentStock <= material.minimumStock;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(material.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'Stock: ${material.currentStock} ${material.unit} | Min: ${material.minimumStock} | Cost: \$${material.costPerUnit}',
        ),
        trailing: isLowStock
            ? const Icon(Icons.warning, color: Colors.red)
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
