import '../models/inventory_item_model.dart';

abstract class InventoryRemoteDataSource {
  /// Returns list of inventory item models
  Future<List<InventoryItemModel>> getInventoryList();

  /// Returns single inventory item model by id
  Future<InventoryItemModel> getInventoryItemDetails(String id);
}
