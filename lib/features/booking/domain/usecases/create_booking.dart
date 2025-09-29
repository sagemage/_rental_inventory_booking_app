import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class CreateBooking {
  final BookingRepository repository;
  CreateBooking(this.repository);

  Future<Either<Failure, Booking>> call({
    required String userId,
    required List<BookingItem> items,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return repository.createBooking(
      userId: userId,
      items: items,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
