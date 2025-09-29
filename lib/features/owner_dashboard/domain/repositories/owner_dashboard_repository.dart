import 'package:dartz/dartz.dart';
import '../entities/owner_dashboard.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

abstract class OwnerDashboardRepository {
  Future<Either<Failure, OwnerDashboard>> getDashboardOverview(String ownerId);
  Future<Either<Failure, List<Booking>>> getOwnerBookings(String ownerId);
  Future<Either<Failure, void>> updateBookingStatus({
    required String bookingId,
    required String status,
  });
}
