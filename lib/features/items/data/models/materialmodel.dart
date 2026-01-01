class MaterialModel {
  final String id;
  final String name;
  final double currentStock;
  final double minimumStock;
  final String unit;
  final double costPerUnit;

  MaterialModel({
    required this.id,
    required this.name,
    required this.currentStock,
    required this.minimumStock,
    required this.unit,
    required this.costPerUnit,
  });
}