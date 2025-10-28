import 'package:cloud_firestore/cloud_firestore.dart';

import 'inventory_remote_data_source.dart';
import '../models/inventory_item_model.dart';

class FirebaseInventoryRemoteDataSource implements InventoryRemoteDataSource {
  final FirebaseFirestore firestore;
  final String collectionPath;

  FirebaseInventoryRemoteDataSource({
    required this.firestore,
    this.collectionPath = 'inventory_items',
  });

  CollectionReference<Map<String, dynamic>> get collection => firestore.collection(collectionPath);

  @override
  Future<List<InventoryItemModel>> getInventoryList() async {
    final snapshot = await collection.get();
    return snapshot.docs.map((d) => InventoryItemModel.fromMap(d.data(), d.id)).toList();
  }

  @override
  Future<InventoryItemModel> getInventoryItemDetails(String id) async {
    final doc = await collection.doc(id).get();
    if (!doc.exists) throw Exception('Inventory item not found: $id');
    return InventoryItemModel.fromMap(doc.data() ?? <String, dynamic>{}, doc.id);
  }
}
