class MaterialModel {
  final String id;
  String name;
  String unit;
  double quantity;
  double costPerUnit;
  double minimumStock;

  MaterialModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.costPerUnit,
    required this.minimumStock,
  });

  double get totalValue => quantity * costPerUnit;

  bool get isLowStock => quantity <= minimumStock;
}