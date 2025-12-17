import 'package:dartz/dartz.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_data_source.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;

  InventoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<InventoryItem>>> getInventoryList() async {
    try {
      final models = await remoteDataSource.getInventoryList();
      final List<InventoryItem> items = models.map<InventoryItem>((m) => m as InventoryItem).toList();
      return Right(items);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> getInventoryItemDetails(String id) async {
    try {
      final model = await remoteDataSource.getInventoryItemDetails(id);
      return Right(model);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAvailability(String itemId, DateTime startDate, DateTime endDate, int quantity) async {
    try {
      final available = await remoteDataSource.checkAvailability(itemId, startDate, endDate, quantity);
      return Right(available);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
