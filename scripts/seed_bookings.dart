import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rental_inventory_booking_app/firebase_options.dart';

Future<void> main(List<String> args) async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('Starting bookings seeding...');

  final firestore = FirebaseFirestore.instance;
  final bookingsCollection = firestore.collection('bookings');

  // Sample bookings for UAT
  // Note: These reference the user and inventory items created by seed_users.dart and seed_inventory.dart
  final now = DateTime.now();
  
  final sampleBookings = [
    {
      'userId': 'user_001',
      'ownerId': 'owner_001',
      'items': [
        {'itemId': 'item_001', 'quantity': 1},
        {'itemId': 'item_003', 'quantity': 2},
      ],
      'startDate': now.add(const Duration(days: 7)).toIso8601String(),
      'endDate': now.add(const Duration(days: 10)).toIso8601String(),
      'status': 'pending',
      'totalPrice': 120.00,
      'createdAt': now.toIso8601String(),
    },
    {
      'userId': 'user_002',
      'ownerId': 'owner_001',
      'items': [
        {'itemId': 'item_002', 'quantity': 1},
      ],
      'startDate': now.add(const Duration(days: 5)).toIso8601String(),
      'endDate': now.add(const Duration(days: 8)).toIso8601String(),
      'status': 'approved',
      'totalPrice': 60.00,
      'createdAt': now.toIso8601String(),
    },
    {
      'userId': 'user_001',
      'ownerId': 'owner_002',
      'items': [
        {'itemId': 'item_005', 'quantity': 1},
      ],
      'startDate': now.add(const Duration(days: 14)).toIso8601String(),
      'endDate': now.add(const Duration(days: 16)).toIso8601String(),
      'status': 'pending',
      'totalPrice': 70.00,
      'createdAt': now.toIso8601String(),
    },
    {
      'userId': 'user_002',
      'ownerId': 'owner_002',
      'items': [
        {'itemId': 'item_004', 'quantity': 2},
        {'itemId': 'item_006', 'quantity': 1},
      ],
      'startDate': now.subtract(const Duration(days: 3)).toIso8601String(),
      'endDate': now.add(const Duration(days: 2)).toIso8601String(),
      'status': 'confirmed',
      'totalPrice': 44.00,
      'createdAt': now.subtract(const Duration(days: 10)).toIso8601String(),
    },
    {
      'userId': 'user_001',
      'ownerId': 'owner_001',
      'items': [
        {'itemId': 'item_007', 'quantity': 1},
      ],
      'startDate': now.subtract(const Duration(days: 7)).toIso8601String(),
      'endDate': now.subtract(const Duration(days: 5)).toIso8601String(),
      'status': 'cancelled',
      'totalPrice': 20.00,
      'createdAt': now.subtract(const Duration(days: 15)).toIso8601String(),
    },
  ];

  try {
    // Batch write bookings
    final batch = firestore.batch();

    for (int i = 0; i < sampleBookings.length; i++) {
      final bookingData = sampleBookings[i];
      final docRef = bookingsCollection.doc('booking_00${i + 1}');
      batch.set(docRef, bookingData);
      print('Prepared booking: ${bookingData['userId']} - Status: ${bookingData['status']}');
    }

    await batch.commit();
    print('✓ Successfully seeded ${sampleBookings.length} bookings to Firestore');
  } catch (e) {
    print('✗ Error seeding bookings: $e');
    rethrow;
  } finally {
    // Close Firebase connection
    await Firebase.app().delete();
  }
}

