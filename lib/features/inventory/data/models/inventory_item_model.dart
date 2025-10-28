import '../../domain/entities/inventory_item.dart';

/// Data model / DTO for inventory items.
///
/// Provides explicit fromMap / toMap methods for (de)serialization.
class InventoryItemModel extends InventoryItem {
  const InventoryItemModel({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required int quantityAvailable,
    required double pricePerDay,
  }) : super(
          id: id,
          name: name,
          description: description,
          imageUrl: imageUrl,
          quantityAvailable: quantityAvailable,
          pricePerDay: pricePerDay,
        );

  /// Create model from a plain Map (e.g. decoded JSON or Firestore document data).
  factory InventoryItemModel.fromMap(Map<String, dynamic> map, String id) {
    return InventoryItemModel(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      quantityAvailable: (map['quantityAvailable'] as num?)?.toInt() ?? 0,
      pricePerDay: (map['pricePerDay'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert model to a plain Map suitable for JSON encoding or Firestore writes.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'quantityAvailable': quantityAvailable,
      'pricePerDay': pricePerDay,
    };
  }

  /// Alias for toMap() when interacting with JSON-based APIs.
  Map<String, dynamic> toJson() => toMap();
}
