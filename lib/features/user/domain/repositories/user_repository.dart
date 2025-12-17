import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, User>> signUp({
    required String fullName,
    required String phoneNumber,
    required String deliveryAddress,
    String? email,
    required String password,
    UserRole role = UserRole.client,
  });
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User>> updateProfile(User user);
}