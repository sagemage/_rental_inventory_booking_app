import 'package:dartz/dartz.dart';
import '../entities/inventory_item.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<InventoryItem>>> getInventoryList();
  Future<Either<Failure, InventoryItem>> getInventoryItemDetails(String id);
  Future<Either<Failure, bool>> checkAvailability(String itemId, DateTime startDate, DateTime endDate, int quantity);
}
