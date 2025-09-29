import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';
import 'package:rental_inventory_booking_app/features/user/domain/repositories/user_repository.dart';

class SignUp {
  final UserRepository repository;
  SignUp(this.repository);

  Future<Either<Failure, User>> call({
    required String fullName,
    required String phoneNumber,
    String? email,
    String? address,
    required String password,
    required UserRole role,
  }) {
    return repository.signUp(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      password: password,
      role: role,
    );
  }
}