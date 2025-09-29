import 'package:dartz/dartz.dart';
import '../entities/inventory_item.dart';
import '../repositories/inventory_repository.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

class GetInventoryList {
  final InventoryRepository repository;

  GetInventoryList(this.repository);

  Future<Either<Failure, List<InventoryItem>>> call() {
    return repository.getInventoryList();
  }
}
