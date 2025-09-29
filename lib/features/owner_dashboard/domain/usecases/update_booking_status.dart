import 'package:dartz/dartz.dart';
import '../repositories/owner_dashboard_repository.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
class UpdateBookingStatus {
  final OwnerDashboardRepository repository;

  UpdateBookingStatus(this.repository);

  Future<Either<Failure, void>> call({
    required String bookingId,
    required String status,
  }) {
    return repository.updateBookingStatus(
      bookingId: bookingId,
      status: status,
    );
  }
}
