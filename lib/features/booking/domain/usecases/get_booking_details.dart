import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetBookingDetails {
  final BookingRepository repository;
  GetBookingDetails(this.repository);

  Future<Either<Failure, Booking>> call(String bookingId) {
    return repository.getBookingDetails(bookingId);
  }
}