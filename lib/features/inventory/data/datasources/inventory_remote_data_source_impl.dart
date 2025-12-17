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

  @override
  Future<bool> checkAvailability(String itemId, DateTime startDate, DateTime endDate, int quantity) async {
    // Get the item to check available stock
    final item = await getInventoryItemDetails(itemId);

    // Query bookings that overlap with the requested dates and are confirmed or pending
    final bookingsQuery = firestore.collection('bookings').where('status', whereIn: ['confirmed', 'pending']);

    final bookingsSnapshot = await bookingsQuery.get();

    int bookedQuantity = 0;
    for (final doc in bookingsSnapshot.docs) {
      final data = doc.data();
      final bookingStart = (data['startDate'] as Timestamp).toDate();
      final bookingEnd = (data['endDate'] as Timestamp).toDate();
      final items = data['items'] as List<dynamic>;

      // Check if dates overlap
      if (!(endDate.isBefore(bookingStart) || startDate.isAfter(bookingEnd))) {
        // Overlap, check if item is in booking
        for (final itemData in items) {
          if (itemData['itemId'] == itemId) {
            bookedQuantity += itemData['quantity'] as int;
          }
        }
      }
    }

    // Check if available stock can cover booked + requested
    return item.quantityAvailable >= bookedQuantity + quantity;
  }
}
