import 'package:equatable/equatable.dart';

class InventoryItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int quantityAvailable;
  final double pricePerDay;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.quantityAvailable,
    required this.pricePerDay,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl, quantityAvailable, pricePerDay];
}
