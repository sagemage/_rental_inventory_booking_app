import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rental_inventory_booking_app/firebase_options.dart';
import 'package:rental_inventory_booking_app/features/inventory/data/models/inventory_item_model.dart';

Future<void> main(List<String> args) async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('Starting inventory seeding...');

  final firestore = FirebaseFirestore.instance;
  final inventoryCollection = firestore.collection('inventory_items');

  // Sample inventory items for UAT
  final sampleInventoryItems = [
    InventoryItemModel(
      id: 'item_001',
      name: 'Mountain Bike',
      description: 'High-performance mountain bike with full suspension',
      imageUrls: ['https://example.com/images/mountain-bike.jpg'],
      totalQuantity: 5,
      quantityAvailable: 5,
      pricePerDay: 25.00,
      category: 'Bikes',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    InventoryItemModel(
      id: 'item_002',
      name: 'Road Bike',
      description: 'Lightweight road bike for speed and efficiency',
      imageUrls: ['https://example.com/images/road-bike.jpg'],
      totalQuantity: 8,
      quantityAvailable: 8,
      pricePerDay: 20.00,
      category: 'Bikes',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    InventoryItemModel(
      id: 'item_003',
      name: 'Camping Tent',
      description: '4-person camping tent with waterproof coating',
      imageUrls: ['https://example.com/images/camping-tent.jpg'],
      totalQuantity: 12,
      quantityAvailable: 12,
      pricePerDay: 15.00,
      category: 'Tents',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    InventoryItemModel(
      id: 'item_004',
      name: 'Hiking Backpack',
      description: '60L hiking backpack with comfortable straps',
      imageUrls: ['https://example.com/images/hiking-backpack.jpg'],
      totalQuantity: 20,
      quantityAvailable: 20,
      pricePerDay: 8.00,
      category: 'Gear',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    InventoryItemModel(
      id: 'item_005',
      name: 'Kayak',
      description: 'Stable kayak suitable for beginners and intermediate paddlers',
      imageUrls: ['https://example.com/images/kayak.jpg'],
      totalQuantity: 4,
      quantityAvailable: 4,
      pricePerDay: 35.00,
      category: 'Water Sports',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    InventoryItemModel(
      id: 'item_006',
      name: 'Fishing Rod Set',
      description: 'Complete fishing rod set with tackle box and accessories',
      imageUrls: ['https://example.com/images/fishing-rod.jpg'],
      totalQuantity: 6,
      quantityAvailable: 6,
      pricePerDay: 12.00,
      category: 'Fishing',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    InventoryItemModel(
      id: 'item_007',
      name: 'Skateboard',
      description: 'Professional-grade skateboard for tricks and commuting',
      imageUrls: ['https://example.com/images/skateboard.jpg'],
      totalQuantity: 10,
      quantityAvailable: 10,
      pricePerDay: 10.00,
      category: 'Skate',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    InventoryItemModel(
      id: 'item_008',
      name: 'Roller Skates',
      description: 'Adjustable roller skates suitable for all ages',
      imageUrls: ['https://example.com/images/roller-skates.jpg'],
      totalQuantity: 15,
      quantityAvailable: 15,
      pricePerDay: 7.00,
      category: 'Skate',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  try {
    // Batch write inventory items
    final batch = firestore.batch();

    for (final item in sampleInventoryItems) {
      final docRef = inventoryCollection.doc(item.id);
      batch.set(docRef, item.toMap());
      print('Prepared inventory item: ${item.name} (\$${item.pricePerDay}/day)');
    }

    await batch.commit();
    print('✓ Successfully seeded ${sampleInventoryItems.length} inventory items to Firestore');
  } catch (e) {
    print('✗ Error seeding inventory items: $e');
    rethrow;
  } finally {
    // Close Firebase connection
    await Firebase.app().delete();
  }
}

// Default Firebase options (placeholder - configure with your Firebase project)
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Replace with your actual Firebase configuration
    return const FirebaseOptions(
      apiKey: 'YOUR_API_KEY',
      appId: 'YOUR_APP_ID',
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
      projectId: 'YOUR_PROJECT_ID',
      authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
      databaseURL: 'https://YOUR_PROJECT_ID.firebaseio.com',
      storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    );
  }
}