import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.clientId,
    required super.clientName,
    required super.clientPhone,
    super.clientEmail,
    required super.deliveryAddress,
    required super.items,
    required super.startDate,
    required super.endDate,
    super.eventTime,
    required super.eventType,
    super.eventNotes,
    super.deliveryInstructions,
    required super.status,
    required super.paymentStatus,
    required super.totalAmount,
    super.partialPayment,
    super.finalPayment,
    super.partialPaymentDate,
    super.finalPaymentDate,
    super.damageFee,
    super.cancellationReason,
    required super.createdAt,
    super.updatedAt,
    required super.ownerId,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel.fromMap({...data, 'id': doc.id});
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      clientPhone: map['clientPhone'] ?? '',
      clientEmail: map['clientEmail'],
      deliveryAddress: map['deliveryAddress'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => BookingItemModel.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      eventTime: map['eventTime'] != null ? DateTime.parse(map['eventTime']) : null,
      eventType: BookingType.values.firstWhere(
        (e) => e.name == map['eventType'],
        orElse: () => BookingType.other,
      ),
      eventNotes: map['eventNotes'],
      deliveryInstructions: map['deliveryInstructions'],
      status: BookingStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => BookingStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == map['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      partialPayment: map['partialPayment']?.toDouble(),
      finalPayment: map['finalPayment']?.toDouble(),
      partialPaymentDate: map['partialPaymentDate'] != null 
          ? DateTime.parse(map['partialPaymentDate']) 
          : null,
      finalPaymentDate: map['finalPaymentDate'] != null 
          ? DateTime.parse(map['finalPaymentDate']) 
          : null,
      damageFee: map['damageFee']?.toDouble(),
      cancellationReason: map['cancellationReason'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      ownerId: map['ownerId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'clientPhone': clientPhone,
      'clientEmail': clientEmail,
      'deliveryAddress': deliveryAddress,
      'items': items.map((item) => (item as BookingItemModel).toMap()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'eventTime': eventTime?.toIso8601String(),
      'eventType': eventType.name,
      'eventNotes': eventNotes,
      'deliveryInstructions': deliveryInstructions,
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'totalAmount': totalAmount,
      'partialPayment': partialPayment,
      'finalPayment': finalPayment,
      'partialPaymentDate': partialPaymentDate?.toIso8601String(),
      'finalPaymentDate': finalPaymentDate?.toIso8601String(),
      'damageFee': damageFee,
      'cancellationReason': cancellationReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'ownerId': ownerId,
    };
  }

  Booking toDomain() {
    return Booking(
      id: id,
      clientId: clientId,
      clientName: clientName,
      clientPhone: clientPhone,
      clientEmail: clientEmail,
      deliveryAddress: deliveryAddress,
      items: items,
      startDate: startDate,
      endDate: endDate,
      eventTime: eventTime,
      eventType: eventType,
      eventNotes: eventNotes,
      deliveryInstructions: deliveryInstructions,
      status: status,
      paymentStatus: paymentStatus,
      totalAmount: totalAmount,
      partialPayment: partialPayment,
      finalPayment: finalPayment,
      partialPaymentDate: partialPaymentDate,
      finalPaymentDate: finalPaymentDate,
      damageFee: damageFee,
      cancellationReason: cancellationReason,
      createdAt: createdAt,
      updatedAt: updatedAt,
      ownerId: ownerId,
    );
  }

  factory BookingModel.fromDomain(Booking booking) {
    return BookingModel(
      id: booking.id,
      clientId: booking.clientId,
      clientName: booking.clientName,
      clientPhone: booking.clientPhone,
      clientEmail: booking.clientEmail,
      deliveryAddress: booking.deliveryAddress,
      items: booking.items.map((item) => BookingItemModel.fromDomain(item)).toList(),
      startDate: booking.startDate,
      endDate: booking.endDate,
      eventTime: booking.eventTime,
      eventType: booking.eventType,
      eventNotes: booking.eventNotes,
      deliveryInstructions: booking.deliveryInstructions,
      status: booking.status,
      paymentStatus: booking.paymentStatus,
      totalAmount: booking.totalAmount,
      partialPayment: booking.partialPayment,
      finalPayment: booking.finalPayment,
      partialPaymentDate: booking.partialPaymentDate,
      finalPaymentDate: booking.finalPaymentDate,
      damageFee: booking.damageFee,
      cancellationReason: booking.cancellationReason,
      createdAt: booking.createdAt,
      updatedAt: booking.updatedAt,
      ownerId: booking.ownerId,
    );
  }
}

class BookingItemModel extends BookingItem {
  const BookingItemModel({
    required super.inventoryId,
    required super.name,
    super.imageUrl,
    required super.dailyRate,
    required super.quantity,
    required super.reservedQuantity,
  });

  factory BookingItemModel.fromMap(Map<String, dynamic> map) {
    return BookingItemModel(
      inventoryId: map['inventoryId'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'],
      dailyRate: map['dailyRate']?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 0,
      reservedQuantity: map['reservedQuantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inventoryId': inventoryId,
      'name': name,
      'imageUrl': imageUrl,
      'dailyRate': dailyRate,
      'quantity': quantity,
      'reservedQuantity': reservedQuantity,
    };
  }

  BookingItem toDomain() {
    return BookingItem(
      inventoryId: inventoryId,
      name: name,
      imageUrl: imageUrl,
      dailyRate: dailyRate,
      quantity: quantity,
      reservedQuantity: reservedQuantity,
    );
  }

  factory BookingItemModel.fromDomain(BookingItem bookingItem) {
    return BookingItemModel(
      inventoryId: bookingItem.inventoryId,
      name: bookingItem.name,
      imageUrl: bookingItem.imageUrl,
      dailyRate: bookingItem.dailyRate,
      quantity: bookingItem.quantity,
      reservedQuantity: bookingItem.reservedQuantity,
    );
  }
}

