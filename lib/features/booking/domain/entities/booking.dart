import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String id;
  final String userId;
  final List<BookingItem> items;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // e.g., pending, confirmed, cancelled

  const Booking({
    required this.id,
    required this.userId,
    required this.items,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  @override
  List<Object?> get props => [id, userId, items, startDate, endDate, status];
}

class BookingItem extends Equatable {
  final String itemId;
  final int quantity;

  const BookingItem({
    required this.itemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [itemId, quantity];
}
