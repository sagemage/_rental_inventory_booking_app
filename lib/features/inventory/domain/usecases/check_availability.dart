import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/inventory_item.dart';
import '../repositories/inventory_repository.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

class CheckAvailability {
  final InventoryRepository repository;

  CheckAvailability(this.repository);

  Future<Either<Failure, bool>> call(CheckAvailabilityParams params) {
    return repository.checkAvailability(
      params.itemId,
      params.startDate,
      params.endDate,
      params.quantity,
    );
  }
}

class CheckAvailabilityParams extends Equatable {
  final String itemId;
  final DateTime startDate;
  final DateTime endDate;
  final int quantity;

  const CheckAvailabilityParams({
    required this.itemId,
    required this.startDate,
    required this.endDate,
    required this.quantity,
  });

  @override
  List<Object?> get props => [itemId, startDate, endDate, quantity];
}