import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import 'package:rental_inventory_booking_app/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:rental_inventory_booking_app/features/booking/data/models/booking_model.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Booking>> createBooking(Booking booking) async {
    try {
      final bookingModel = await remoteDataSource.createBooking(booking);
      return Right(bookingModel.toDomain());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getBookingsForUser(String userId) async {
    try {
      final bookingModels = await remoteDataSource.getBookingsForUser(userId);
      return Right(bookingModels.map((model) => model.toDomain()).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getBookingsForOwner(String ownerId) async {
    try {
      final bookingModels = await remoteDataSource.getBookingsForOwner(ownerId);
      return Right(bookingModels.map((model) => model.toDomain()).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> getBookingDetails(String bookingId) async {
    try {
      final bookingModel = await remoteDataSource.getBookingDetails(bookingId);
      return Right(bookingModel.toDomain());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getAllBookings() async {
    try {
      final bookingModels = await remoteDataSource.getAllBookings();
      return Right(bookingModels.map((model) => model.toDomain()).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBookingStatus(String bookingId, BookingStatus status) async {
    try {
      await remoteDataSource.updateBookingStatus(bookingId, status);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId, {String? reason}) async {
    try {
      await remoteDataSource.cancelBooking(bookingId, reason: reason);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePaymentStatus(
    String bookingId, 
    PaymentStatus status, {
    double? amount, 
    DateTime? paymentDate,
  }) async {
    try {
      await remoteDataSource.updatePaymentStatus(
        bookingId, 
        status, 
        amount: amount, 
        paymentDate: paymentDate,
      );
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getTodayBookings(String ownerId) async {
    try {
      final bookingModels = await remoteDataSource.getTodayBookings(ownerId);
      return Right(bookingModels.map((model) => model.toDomain()).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getUpcomingBookings(
    String ownerId, {
    int days = 7,
  }) async {
    try {
      final bookingModels = await remoteDataSource.getUpcomingBookings(ownerId, days: days);
      return Right(bookingModels.map((model) => model.toDomain()).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getAvailableInventory(
    String inventoryId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // This would require a more complex query to check availability
      // For now, return an empty list - this would need implementation
      return const Right([]);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

