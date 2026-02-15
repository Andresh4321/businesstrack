import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;

  ProductEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
