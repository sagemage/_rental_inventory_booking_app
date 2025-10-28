import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required String id,
    required String userId,
    required List<BookingItem> items,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) : super(
          id: id,
          userId: userId,
          items: items,
          startDate: startDate,
          endDate: endDate,
          status: status,
        );

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    final itemsList = (map['items'] as List<dynamic>?)
            ?.map((e) => BookingItemModel.fromMap(Map<String, dynamic>.from(e)))
            .toList() ??
        <BookingItem>[];

    return BookingModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      items: itemsList,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      status: map['status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'items': items.map((e) {
          if (e is BookingItemModel) return e.toMap();
          return {
            'itemId': e.itemId,
            'quantity': e.quantity,
          };
        }).toList(),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'status': status,
      };
}

class BookingItemModel extends BookingItem {
  const BookingItemModel({required String itemId, required int quantity}) : super(itemId: itemId, quantity: quantity);

  factory BookingItemModel.fromMap(Map<String, dynamic> map) {
    return BookingItemModel(
      itemId: map['itemId'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'itemId': itemId,
        'quantity': quantity,
      };
}
