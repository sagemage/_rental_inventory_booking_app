import 'package:equatable/equatable.dart';

class InventoryItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> imageUrls;
  final int totalQuantity;
  final int quantityAvailable;
  final double pricePerDay;
  final double pricePerSet;
  final String category;
  final Map<String, dynamic> specifications;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.totalQuantity,
    required this.quantityAvailable,
    required this.pricePerDay,
    this.pricePerSet = 0.0,
    required this.category,
    this.specifications = const {},
    this.tags = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  // Constructor for creating new items
  factory InventoryItem.create({
    required String name,
    required String description,
    required List<String> imageUrls,
    required int totalQuantity,
    required double pricePerDay,
    double pricePerSet = 0.0,
    required String category,
    Map<String, dynamic> specifications = const {},
    List<String> tags = const [],
  }) {
    final now = DateTime.now();
    return InventoryItem(
      id: '',
      name: name,
      description: description,
      imageUrls: imageUrls,
      totalQuantity: totalQuantity,
      quantityAvailable: totalQuantity,
      pricePerDay: pricePerDay,
      pricePerSet: pricePerSet,
      category: category,
      specifications: specifications,
      tags: tags,
      rating: 0.0,
      reviewCount: 0,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  // CopyWith method for updates
  InventoryItem copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? imageUrls,
    int? totalQuantity,
    int? quantityAvailable,
    double? pricePerDay,
    double? pricePerSet,
    String? category,
    Map<String, dynamic>? specifications,
    List<String>? tags,
    double? rating,
    int? reviewCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      pricePerSet: pricePerSet ?? this.pricePerSet,
      category: category ?? this.category,
      specifications: specifications ?? this.specifications,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  bool get hasMultipleImages => imageUrls.length > 1;
  bool get isAvailable => quantityAvailable > 0;
  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';
  String get imageUrl => primaryImage; // For backward compatibility
  
  // Calculate price for rental period
  double calculatePriceForDays(int days) {
    if (days <= 0) return 0.0;
    return pricePerDay * days;
  }

  // Calculate price for sets
  double calculatePriceForSets(int sets) {
    if (sets <= 0 || pricePerSet <= 0) return 0.0;
    return pricePerSet * sets;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrls,
        totalQuantity,
        quantityAvailable,
        pricePerDay,
        pricePerSet,
        category,
        specifications,
        tags,
        rating,
        reviewCount,
        isActive,
        createdAt,
        updatedAt,
      ];
}

