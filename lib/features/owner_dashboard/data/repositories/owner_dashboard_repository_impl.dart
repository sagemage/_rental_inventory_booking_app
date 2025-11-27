import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import '../../domain/entities/owner_dashboard.dart';
import '../../domain/repositories/owner_dashboard_repository.dart';
import '../datasources/owner_dashboard_remote_data_source.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';

class OwnerDashboardRepositoryImpl implements OwnerDashboardRepository {
  final OwnerDashboardRemoteDataSource remoteDataSource;

  OwnerDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OwnerDashboard>> getDashboardOverview(String ownerId) async {
    try {
      final model = await remoteDataSource.getDashboardOverview(ownerId);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getOwnerBookings(String ownerId) async {
    try {
      final list = await remoteDataSource.getOwnerBookings(ownerId);
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBookingStatus({required String bookingId, required String status}) async {
    try {
      await remoteDataSource.updateBookingStatus(bookingId: bookingId, status: status);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}