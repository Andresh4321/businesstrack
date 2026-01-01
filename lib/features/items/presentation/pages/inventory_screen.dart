import 'package:businesstrack/features/items/data/models/materialmodel.dart';
import 'package:businesstrack/features/items/presentation/widgets/material_item.dart';
import 'package:flutter/material.dart';


class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}


class _InventoryScreenState extends State<InventoryScreen> {
  String searchQuery = "";
  String filter = "all"; // "all", "low", "adequate"
  List<MaterialModel> mockMaterials = [
  MaterialModel(id: "1", name: "Flour", currentStock: 50, minimumStock: 100, unit: "kg", costPerUnit: 2.5),
  MaterialModel(id: "2", name: "Sugar", currentStock: 80, minimumStock: 50, unit: "kg", costPerUnit: 3.0),
  MaterialModel(id: "3", name: "Eggs", currentStock: 120, minimumStock: 200, unit: "pieces", costPerUnit: 0.5),
  MaterialModel(id: "4", name: "Butter", currentStock: 30, minimumStock: 40, unit: "kg", costPerUnit: 8.0),
  MaterialModel(id: "5", name: "Milk", currentStock: 25, minimumStock: 30, unit: "L", costPerUnit: 1.5),
  MaterialModel(id: "6", name: "Chocolate", currentStock: 60, minimumStock: 50, unit: "kg", costPerUnit: 12.0),
  MaterialModel(id: "7", name: "Vanilla Extract", currentStock: 100, minimumStock: 20, unit: "ml", costPerUnit: 0.8),
  MaterialModel(id: "8", name: "Baking Powder", currentStock: 45, minimumStock: 30, unit: "kg", costPerUnit: 4.5),
];

  List<MaterialModel> get filteredMaterials {
    return mockMaterials.where((material) {
      final matchesSearch = material.name.toLowerCase().contains(searchQuery.toLowerCase());
      if (filter == "low") return matchesSearch && material.currentStock <= material.minimumStock;
      if (filter == "adequate") return matchesSearch && material.currentStock > material.minimumStock;
      return matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search materials...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),

          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: ["all", "low", "adequate"].map((f) {
                String label = f == "all" ? "All" : f == "low" ? "Low Stock" : "Adequate";
                bool isSelected = filter == f;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                        foregroundColor: isSelected ? Colors.white : Colors.black,
                      ),
                      onPressed: () => setState(() => filter = f),
                      child: Text(label),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // Materials List
          Expanded(
            child: filteredMaterials.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text("No materials found", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredMaterials.length,
                    itemBuilder: (context, index) {
                      final material = filteredMaterials[index];
                      return MaterialItem(material: material, onTap: () {});
                    },
                  ),
          ),
        ],
      ),

      // Floating Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
