import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:equatable/equatable.dart';

enum MaterialStatus { initial, loading, loaded, error }

class MaterialState extends Equatable {
  final MaterialStatus status;
  final List<MaterialEntity> materials;
  final MaterialEntity? selectedMaterial;
  final String? errorMessage;

  const MaterialState({
    this.status = MaterialStatus.initial,
    this.materials = const [],
    this.selectedMaterial,
    this.errorMessage,
  });

  MaterialState copyWith({
    MaterialStatus? status,
    List<MaterialEntity>? materials,
    MaterialEntity? selectedMaterial,
    String? errorMessage,
  }) {
    return MaterialState(
      status: status ?? this.status,
      materials: materials ?? this.materials,
      selectedMaterial: selectedMaterial ?? this.selectedMaterial,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    materials,
    selectedMaterial,
    errorMessage,
  ];
}
