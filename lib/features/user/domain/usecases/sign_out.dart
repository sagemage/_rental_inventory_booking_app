import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import 'package:rental_inventory_booking_app/features/user/domain/repositories/user_repository.dart';

class SignOut {
  final UserRepository repository;
  SignOut(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.signOut();
  }
}