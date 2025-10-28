import 'package:cloud_firestore/cloud_firestore.dart';
import 'owner_dashboard_remote_data_source.dart';
import '../models/owner_dashboard_model.dart';
import '../models/booking_model.dart';

class OwnerDashboardRemoteDataSourceImpl implements OwnerDashboardRemoteDataSource {
  final FirebaseFirestore firestore;

  OwnerDashboardRemoteDataSourceImpl({required this.firestore});

  @override
  Future<OwnerDashboardModel> getDashboardOverview(String ownerId) async {
    final bookingsSnapshot = await firestore.collection('bookings').where('ownerId', isEqualTo: ownerId).get();
    final total = bookingsSnapshot.docs.length;

    int pending = 0, approved = 0, declined = 0;
    for (final doc in bookingsSnapshot.docs) {
      final data = doc.data();
      final status = (data['status'] ?? '') as String;
      switch (status) {
        case 'pending':
          pending++;
          break;
        case 'approved':
        case 'confirmed':
          approved++;
          break;
        case 'declined':
        case 'cancelled':
          declined++;
          break;
        default:
          break;
      }
    }

    final inventorySnapshot = await firestore.collection('inventory').where('ownerId', isEqualTo: ownerId).get();
    final inventoryCount = inventorySnapshot.docs.length;

    return OwnerDashboardModel(
      totalBookings: total,
      pendingBookings: pending,
      approvedBookings: approved,
      declinedBookings: declined,
      inventoryCount: inventoryCount,
    );
  }

  @override
  Future<List<BookingModel>> getOwnerBookings(String ownerId) async {
    final query = await firestore.collection('bookings').where('ownerId', isEqualTo: ownerId).get();
    return query.docs.map((d) {
      final data = Map<String, dynamic>.from(d.data());
      data['id'] = d.id;
      return BookingModel.fromMap(data);
    }).toList();
  }

  @override
  Future<void> updateBookingStatus({required String bookingId, required String status}) async {
    final docRef = firestore.collection('bookings').doc(bookingId);
    await docRef.update({'status': status});
  }
}
