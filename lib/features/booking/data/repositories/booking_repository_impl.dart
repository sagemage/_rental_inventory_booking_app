import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/entities/booking.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Booking>> createBooking({required String userId, required List<BookingItem> items, required DateTime startDate, required DateTime endDate}) async {
    try {
      // Map domain BookingItem to BookingItemModel if necessary
      final modelItems = items.map((e) => BookingItemModel(itemId: e.itemId, quantity: e.quantity)).toList();
      final BookingModel result = await remoteDataSource.createBooking(userId: userId, items: modelItems, startDate: startDate, endDate: endDate);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getBookingsForUser(String userId) async {
    try {
      final List<BookingModel> results = await remoteDataSource.getBookingsForUser(userId);
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> getBookingDetails(String bookingId) async {
    try {
      final BookingModel result = await remoteDataSource.getBookingDetails(bookingId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getAllBookings() async {
    try {
      final List<BookingModel> results = await remoteDataSource.getAllBookings();
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    try {
      final res = await remoteDataSource.cancelBooking(bookingId);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
