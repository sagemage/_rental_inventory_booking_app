
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/inventory_item.dart';

/// Data model / DTO for inventory items.
///
/// Provides explicit fromMap / toMap methods for (de)serialization.
class InventoryItemModel extends InventoryItem {
  const InventoryItemModel({
    required String id,
    required String name,
    required String description,
    required List<String> imageUrls,
    required int totalQuantity,
    required int quantityAvailable,
    required double pricePerDay,
    double pricePerSet = 0.0,
    required String category,
    Map<String, dynamic> specifications = const {},
    List<String> tags = const [],
    double rating = 0.0,
    int reviewCount = 0,
    bool isActive = true,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          name: name,
          description: description,
          imageUrls: imageUrls,
          totalQuantity: totalQuantity,
          quantityAvailable: quantityAvailable,
          pricePerDay: pricePerDay,
          pricePerSet: pricePerSet,
          category: category,
          specifications: specifications,
          tags: tags,
          rating: rating,
          reviewCount: reviewCount,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Create model from a plain Map (e.g. decoded JSON or Firestore document data).
  factory InventoryItemModel.fromMap(Map<String, dynamic> map, String id) {
    return InventoryItemModel(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrls: (map['imageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (map['imageUrl'] != null ? [map['imageUrl'] as String] : []),
      totalQuantity: (map['totalQuantity'] as num?)?.toInt() ??
          (map['quantityAvailable'] as num?)?.toInt() ??
          0,
      quantityAvailable: (map['quantityAvailable'] as num?)?.toInt() ?? 0,
      pricePerDay: (map['pricePerDay'] as num?)?.toDouble() ?? 0.0,
      pricePerSet: (map['pricePerSet'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] as String? ?? 'Other',
      specifications: (map['specifications'] as Map<String, dynamic>?) ?? {},
      tags: (map['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  /// Convert model to a plain Map suitable for JSON encoding or Firestore writes.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrls': imageUrls,
      'totalQuantity': totalQuantity,
      'quantityAvailable': quantityAvailable,
      'pricePerDay': pricePerDay,
      'pricePerSet': pricePerSet,
      'category': category,
      'specifications': specifications,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Alias for toMap() when interacting with JSON-based APIs.
  Map<String, dynamic> toJson() => toMap();

  /// Create from existing InventoryItem
  factory InventoryItemModel.fromEntity(InventoryItem item) {
    return InventoryItemModel(
      id: item.id,
      name: item.name,
      description: item.description,
      imageUrls: item.imageUrls,
      totalQuantity: item.totalQuantity,
      quantityAvailable: item.quantityAvailable,
      pricePerDay: item.pricePerDay,
      pricePerSet: item.pricePerSet,
      category: item.category,
      specifications: item.specifications,
      tags: item.tags,
      rating: item.rating,
      reviewCount: item.reviewCount,
      isActive: item.isActive,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }

  /// Convert to InventoryItem entity
  InventoryItem toEntity() {
    return InventoryItem(
      id: id,
      name: name,
      description: description,
      imageUrls: imageUrls,
      totalQuantity: totalQuantity,
      quantityAvailable: quantityAvailable,
      pricePerDay: pricePerDay,
      pricePerSet: pricePerSet,
      category: category,
      specifications: specifications,
      tags: tags,
      rating: rating,
      reviewCount: reviewCount,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

