import 'package:dartz/dartz.dart';
import '../entities/inventory_item.dart';
import '../repositories/inventory_repository.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

class GetInventoryItemDetails {
  final InventoryRepository repository;

  GetInventoryItemDetails(this.repository);

  Future<Either<Failure, InventoryItem>> call(String id) {
    return repository.getInventoryItemDetails(id);
  }
}