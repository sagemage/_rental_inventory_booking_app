import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import '../entities/booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, Booking>> createBooking({
    required String userId,
    required List<BookingItem> items,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, List<Booking>>> getBookingsForUser(String userId);

  Future<Either<Failure, Booking>> getBookingDetails(String bookingId);

  Future<Either<Failure, List<Booking>>> getAllBookings(); // For owner

  Future<Either<Failure, void>> cancelBooking(String bookingId);
}
