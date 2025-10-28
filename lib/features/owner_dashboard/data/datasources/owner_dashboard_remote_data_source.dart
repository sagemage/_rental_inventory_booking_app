import '../models/owner_dashboard_model.dart';
import '../models/booking_model.dart';

abstract class OwnerDashboardRemoteDataSource {
  Future<OwnerDashboardModel> getDashboardOverview(String ownerId);
  Future<List<BookingModel>> getOwnerBookings(String ownerId);
  Future<void> updateBookingStatus({required String bookingId, required String status});
}
