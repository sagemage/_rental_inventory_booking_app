import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, Booking>> createBooking(Booking booking);

  Future<Either<Failure, List<Booking>>> getBookingsForUser(String userId);

  Future<Either<Failure, List<Booking>>> getBookingsForOwner(String ownerId);

  Future<Either<Failure, Booking>> getBookingDetails(String bookingId);

  Future<Either<Failure, List<Booking>>> getAllBookings();

  Future<Either<Failure, void>> updateBookingStatus(String bookingId, BookingStatus status);

  Future<Either<Failure, void>> cancelBooking(String bookingId, {String? reason});

  Future<Either<Failure, void>> updatePaymentStatus(
    String bookingId, 
    PaymentStatus status, {
    double? amount, 
    DateTime? paymentDate,
  });

  Future<Either<Failure, List<Booking>>> getTodayBookings(String ownerId);

  Future<Either<Failure, List<Booking>>> getUpcomingBookings(
    String ownerId, {
    int days = 7,
  });

  Future<Either<Failure, List<Booking>>> getAvailableInventory(
    String inventoryId,
    DateTime startDate,
    DateTime endDate,
  );
}

