import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';
import 'package:rental_inventory_booking_app/features/user/domain/repositories/user_repository.dart';

class Login {
  final UserRepository repository;
  Login(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) {
    return repository.login(
      email: email,
      password: password,
    );
  }
}