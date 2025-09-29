import 'package:dartz/dartz.dart';
import '../entities/owner_dashboard.dart';
import '../repositories/owner_dashboard_repository.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

class GetDashboardOverview {
  final OwnerDashboardRepository repository;

  GetDashboardOverview(this.repository);

  Future<Either<Failure, OwnerDashboard>> call(String ownerId) {
    return repository.getDashboardOverview(ownerId);
  }
}
