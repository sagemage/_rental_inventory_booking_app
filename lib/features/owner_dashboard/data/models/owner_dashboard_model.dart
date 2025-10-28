import '../../domain/entities/owner_dashboard.dart';

class OwnerDashboardModel extends OwnerDashboard {
  const OwnerDashboardModel({
    required int totalBookings,
    required int pendingBookings,
    required int approvedBookings,
    required int declinedBookings,
    required int inventoryCount,
  }) : super(
          totalBookings: totalBookings,
          pendingBookings: pendingBookings,
          approvedBookings: approvedBookings,
          declinedBookings: declinedBookings,
          inventoryCount: inventoryCount,
        );

  factory OwnerDashboardModel.fromMap(Map<String, dynamic> map) {
    return OwnerDashboardModel(
      totalBookings: (map['totalBookings'] ?? 0) as int,
      pendingBookings: (map['pendingBookings'] ?? 0) as int,
      approvedBookings: (map['approvedBookings'] ?? 0) as int,
      declinedBookings: (map['declinedBookings'] ?? 0) as int,
      inventoryCount: (map['inventoryCount'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalBookings': totalBookings,
      'pendingBookings': pendingBookings,
      'approvedBookings': approvedBookings,
      'declinedBookings': declinedBookings,
      'inventoryCount': inventoryCount,
    };
  }
}
