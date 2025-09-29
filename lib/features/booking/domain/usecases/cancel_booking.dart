import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import '../repositories/booking_repository.dart';

class CancelBooking {
  final BookingRepository repository;
  CancelBooking(this.repository);

  Future<Either<Failure, void>> call(String bookingId) {
    return repository.cancelBooking(bookingId);
  }
}