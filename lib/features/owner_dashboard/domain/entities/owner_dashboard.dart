import 'package:equatable/equatable.dart';

class OwnerDashboard extends Equatable {
  final int totalBookings;
  final int pendingBookings;
  final int approvedBookings;
  final int declinedBookings;
  final int inventoryCount;

  const OwnerDashboard({
    required this.totalBookings,
    required this.pendingBookings,
    required this.approvedBookings,
    required this.declinedBookings,
    required this.inventoryCount,
  });

  @override
  List<Object?> get props => [
    totalBookings,
    pendingBookings,
    approvedBookings,
    declinedBookings,
    inventoryCount,
  ];
}