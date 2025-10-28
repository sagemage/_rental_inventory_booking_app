import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';

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

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    throw FormatException('Unsupported date type: ${value.runtimeType}');
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    final itemsJson = (map['items'] as List<dynamic>?) ?? [];
    return BookingModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      items: itemsJson
          .map((e) => BookingItemModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      startDate: _parseDate(map['startDate']),
      endDate: _parseDate(map['endDate']),
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((e) => (e as BookingItemModel).toMap()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
    };
  }
}

class BookingItemModel extends BookingItem {
  const BookingItemModel({required String itemId, required int quantity}) : super(itemId: itemId, quantity: quantity);

  factory BookingItemModel.fromMap(Map<String, dynamic> map) {
    return BookingItemModel(
      itemId: map['itemId'] as String,
      quantity: (map['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'quantity': quantity,
    };
  }
}
