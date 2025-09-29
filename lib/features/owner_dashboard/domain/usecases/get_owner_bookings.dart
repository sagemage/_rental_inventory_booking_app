import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';
import '../repositories/owner_dashboard_repository.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

class GetOwnerBookings {
  final OwnerDashboardRepository repository;

  GetOwnerBookings(this.repository);

  Future<Either<Failure, List<Booking>>> call(String ownerId) {
    return repository.getOwnerBookings(ownerId);
  }
}
