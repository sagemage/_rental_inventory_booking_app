import 'package:equatable/equatable.dart';


enum BookingStatus {
  pending,      // Waiting for owner confirmation
  confirmed,    // Owner confirmed
  inProgress,   // Items delivered, event ongoing
  completed,    // Returned and completed
  cancelled,    // Cancelled by owner or client
  declined,     // Declined by owner
  modified,     // Modified by owner
}


enum PaymentStatus {
  pending,      // No payment made yet
  partialPaid,  // Partial payment made (30% deposit)
  fullyPaid,    // Fully paid
  overdue,      // Payment overdue
  refunded,     // Refunded
}

enum BookingType {
  birthday,
  wedding,
  corporate,
  party,
  other,
}

class Booking extends Equatable {
  final String id;
  final String clientId;
  final String clientName;
  final String clientPhone;
  final String? clientEmail;
  final String deliveryAddress;
  final List<BookingItem> items;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? eventTime;
  final BookingType eventType;
  final String? eventNotes;
  final String? deliveryInstructions;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final double totalAmount;
  final double? partialPayment;
  final double? finalPayment;
  final DateTime? partialPaymentDate;
  final DateTime? finalPaymentDate;
  final double? damageFee;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String ownerId;

  const Booking({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    this.clientEmail,
    required this.deliveryAddress,
    required this.items,
    required this.startDate,
    required this.endDate,
    this.eventTime,
    required this.eventType,
    this.eventNotes,
    this.deliveryInstructions,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    this.partialPayment,
    this.finalPayment,
    this.partialPaymentDate,
    this.finalPaymentDate,
    this.damageFee,
    this.cancellationReason,
    required this.createdAt,
    this.updatedAt,
    required this.ownerId,
  });

  Booking copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? clientPhone,
    String? clientEmail,
    String? deliveryAddress,
    List<BookingItem>? items,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? eventTime,
    BookingType? eventType,
    String? eventNotes,
    String? deliveryInstructions,
    BookingStatus? status,
    PaymentStatus? paymentStatus,
    double? totalAmount,
    double? partialPayment,
    double? finalPayment,
    DateTime? partialPaymentDate,
    DateTime? finalPaymentDate,
    double? damageFee,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerId,
  }) {
    return Booking(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      clientEmail: clientEmail ?? this.clientEmail,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      items: items ?? this.items,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      eventTime: eventTime ?? this.eventTime,
      eventType: eventType ?? this.eventType,
      eventNotes: eventNotes ?? this.eventNotes,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      totalAmount: totalAmount ?? this.totalAmount,
      partialPayment: partialPayment ?? this.partialPayment,
      finalPayment: finalPayment ?? this.finalPayment,
      partialPaymentDate: partialPaymentDate ?? this.partialPaymentDate,
      finalPaymentDate: finalPaymentDate ?? this.finalPaymentDate,
      damageFee: damageFee ?? this.damageFee,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  // Helper method to get rental duration in days
  int get rentalDays {
    return endDate.difference(startDate).inDays + 1;
  }

  // Helper method to check if booking is for today
  bool get isToday {
    final now = DateTime.now();
    return startDate.year == now.year && 
           startDate.month == now.month && 
           startDate.day == now.day;
  }

  // Helper method to check if booking is upcoming (within next 7 days)
  bool get isUpcoming {
    final now = DateTime.now();
    final difference = startDate.difference(now).inDays;
    return difference >= 0 && difference <= 7;
  }

  // Helper method to get remaining balance
  double get remainingBalance {
    if (partialPayment == null) return totalAmount;
    return totalAmount - partialPayment! - (damageFee ?? 0);
  }

  // Helper method to get total paid amount
  double get totalPaid {
    return (partialPayment ?? 0) + (finalPayment ?? 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'clientPhone': clientPhone,
      'clientEmail': clientEmail,
      'deliveryAddress': deliveryAddress,
      'items': items.map((item) => item.toMap()).toList(),
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

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      clientPhone: map['clientPhone'] ?? '',
      clientEmail: map['clientEmail'],
      deliveryAddress: map['deliveryAddress'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => BookingItem.fromMap(item as Map<String, dynamic>))
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

  @override
  List<Object?> get props => [
    id,
    clientId,
    clientName,
    clientPhone,
    clientEmail,
    deliveryAddress,
    items,
    startDate,
    endDate,
    eventTime,
    eventType,
    eventNotes,
    deliveryInstructions,
    status,
    paymentStatus,
    totalAmount,
    partialPayment,
    finalPayment,
    partialPaymentDate,
    finalPaymentDate,
    damageFee,
    cancellationReason,
    createdAt,
    updatedAt,
    ownerId,
  ];
}

class BookingItem extends Equatable {
  final String inventoryId;
  final String name;
  final String? imageUrl;
  final double dailyRate;
  final int quantity;
  final int reservedQuantity;

  const BookingItem({
    required this.inventoryId,
    required this.name,
    this.imageUrl,
    required this.dailyRate,
    required this.quantity,
    required this.reservedQuantity,
  });

  // Calculate subtotal for this item
  double get subtotal {
    return dailyRate * quantity;
  }

  // Calculate total for rental period
  double get totalAmount {
    // This will be calculated based on rental days when needed
    return dailyRate * quantity;
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

  factory BookingItem.fromMap(Map<String, dynamic> map) {
    return BookingItem(
      inventoryId: map['inventoryId'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'],
      dailyRate: map['dailyRate']?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 0,
      reservedQuantity: map['reservedQuantity'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    inventoryId,
    name,
    imageUrl,
    dailyRate,
    quantity,
    reservedQuantity,
  ];
}

