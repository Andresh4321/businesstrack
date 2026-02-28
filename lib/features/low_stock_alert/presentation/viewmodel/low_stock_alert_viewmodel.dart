import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lowStockAlertViewModelProvider =
    NotifierProvider<LowStockAlertViewModel, LowStockAlertState>(
      () => LowStockAlertViewModel(),
    );

class LowStockAlertViewModel extends Notifier<LowStockAlertState> {
  @override
  LowStockAlertState build() {
    return const LowStockAlertState();
  }

  Future<void> loadLowStockAlerts() async {
    await ref.read(materialViewModelProvider.notifier).getAllMaterials();
    final materialState = ref.read(materialViewModelProvider);

    final materials = materialState.materials;
    _categorizeAlerts(materials);
  }

  void _categorizeAlerts(List<MaterialEntity> materials) {
    final criticalItems = <MaterialEntity>[];
    final lowItems = <MaterialEntity>[];
    final normalItems = <MaterialEntity>[];

    for (final material in materials) {
      // Categorize based on minimum stock value
      // Critical: < 5, Low: 5-10, Normal: > 10
      if (material.minimumStock < 5) {
        criticalItems.add(material);
      } else if (material.minimumStock >= 5 && material.minimumStock <= 10) {
        lowItems.add(material);
      } else {
        normalItems.add(material);
      }
    }

    state = LowStockAlertState(
      allMaterials: materials,
      criticalItems: criticalItems,
      lowItems: lowItems,
      normalItems: normalItems,
    );
  }
}

class LowStockAlertState {
  final List<MaterialEntity> allMaterials;
  final List<MaterialEntity> criticalItems;
  final List<MaterialEntity> lowItems;
  final List<MaterialEntity> normalItems;

  const LowStockAlertState({
    this.allMaterials = const [],
    this.criticalItems = const [],
    this.lowItems = const [],
    this.normalItems = const [],
  });
}
