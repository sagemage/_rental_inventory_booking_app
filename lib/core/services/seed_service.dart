import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_inventory_booking_app/features/inventory/data/models/inventory_item_model.dart';
import 'package:rental_inventory_booking_app/features/user/data/models/user_model.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';

class SeedService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  SeedService({required this.firestore, required this.auth});

  Future<void> seedUsers() async {
    final usersCollection = firestore.collection('users');
    const kTestPassword = 'password123';

    final initialUsersData = [
      {
        'fullName': 'John Smith (Client)',
        'phoneNumber': '+1234567890',
        'email': 'john.smith@example.com',
        'address': '123 Main St, City, State 12345',
        'role': UserRole.client,
      },
      {
        'fullName': 'Jane Johnson (Client)',
        'phoneNumber': '+1234567891',
        'email': 'jane.johnson@example.com',
        'address': '456 Oak Ave, City, State 12346',
        'role': UserRole.client,
      },
      {
        'fullName': 'Mike Wilson (Owner)',
        'phoneNumber': '+1234567892',
        'email': 'mike.wilson@example.com',
        'address': '789 Pine Rd, City, State 12347',
        'role': UserRole.owner,
      },
      {
        'fullName': 'Sarah Davis (Owner)',
        'phoneNumber': '+1234567893',
        'email': 'sarah.davis@example.com',
        'address': '321 Elm St, City, State 12348',
        'role': UserRole.owner,
      },
      {
        'fullName': 'Admin User',
        'phoneNumber': '+1234567894',
        'email': 'admin@example.com',
        'address': '999 Admin Ave, City, State 12349',
        'role': UserRole.admin,
      },
    ];

    final seededUsers = <UserModel>[];

    for (final userData in initialUsersData) {
      final phone = userData['phoneNumber'] as String;
      // Create Firebase Auth user with phone-based email for login compatibility
      final authEmail = '${phone.replaceAll(RegExp(r'[^0-9]'), '')}@phone.local';
      try {
        await auth.createUserWithEmailAndPassword(
          email: authEmail,
          password: kTestPassword,
        );
        final uid = auth.currentUser!.uid;


        final userModel = UserModel(
          id: uid,
          fullName: userData['fullName'] as String,
          phoneNumber: phone,
          email: userData['email'] as String, // Store original email in profile
          deliveryAddress: userData['address'] as String,
          role: userData['role'] as UserRole,
          createdAt: DateTime.now(),
        );
        seededUsers.add(userModel);
      } catch (e) {
        // User might already exist, try to get existing
        try {
          await auth.signInWithEmailAndPassword(
            email: authEmail,
            password: kTestPassword,
          );
          final uid = auth.currentUser!.uid;

          final userModel = UserModel(
            id: uid,
            fullName: userData['fullName'] as String,
            phoneNumber: phone,
            email: userData['email'] as String,
            deliveryAddress: userData['address'] as String,
            role: userData['role'] as UserRole,
            createdAt: DateTime.now(),
          );
          seededUsers.add(userModel);
        } catch (e2) {
          // Skip if can't create or login
        }
      }
    }

    final batch = firestore.batch();
    for (final user in seededUsers) {
      final docRef = usersCollection.doc(user.id);
      batch.set(docRef, user.toMap());
    }
    await batch.commit();
  }

  Future<void> seedInventory() async {
    final inventoryCollection = firestore.collection('inventory_items');

    final sampleInventoryItems = [
      InventoryItemModel(
        id: 'item_001',
        name: 'Round Tables (8ft)',
        description: 'Elegant 8ft round tables perfect for dining setups. Seats 8-10 people. White tablecloths included.',
        imageUrls: ['https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400'],
        totalQuantity: 25,
        quantityAvailable: 25,
        pricePerDay: 45.00,
        category: 'Tables',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      InventoryItemModel(
        id: 'item_002',
        name: 'Chiavari Chairs',
        description: 'Classic Chiavari chairs with cushioned seats. Stackable for easy storage. Gold finish.',
        imageUrls: ['https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=400'],
        totalQuantity: 200,
        quantityAvailable: 200,
        pricePerDay: 8.00,
        category: 'Chairs',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      InventoryItemModel(
        id: 'item_003',
        name: 'Wedding Tent (20x40ft)',
        description: 'Large white wedding tent with sidewalls. Perfect for outdoor ceremonies and receptions.',
        imageUrls: ['https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400'],
        totalQuantity: 3,
        quantityAvailable: 3,
        pricePerDay: 850.00,
        category: 'Tents',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      InventoryItemModel(
        id: 'item_004',
        name: 'LED String Lights',
        description: 'Warm white LED string lights. 50ft length with timer function. Creates magical ambiance.',
        imageUrls: ['https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=400'],
        totalQuantity: 15,
        quantityAvailable: 15,
        pricePerDay: 25.00,
        category: 'Decorations',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      InventoryItemModel(
        id: 'item_005',
        name: 'Sound System Package',
        description: 'Complete PA system with speakers, mixer, and wireless microphones. Perfect for speeches and music.',
        imageUrls: ['https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400'],
        totalQuantity: 5,
        quantityAvailable: 5,
        pricePerDay: 150.00,
        category: 'Audio/Visual',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      InventoryItemModel(
        id: 'item_006',
        name: 'Rectangular Tables (6ft)',
        description: '6ft rectangular tables ideal for buffet setups or registration tables. Seats 6-8 people.',
        imageUrls: ['https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400'],
        totalQuantity: 30,
        quantityAvailable: 30,
        pricePerDay: 35.00,
        category: 'Tables',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      InventoryItemModel(
        id: 'item_007',
        name: 'Dance Floor (12x12ft)',
        description: 'Portable dance floor with LED lighting effects. Creates the perfect party atmosphere.',
        imageUrls: ['https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400'],
        totalQuantity: 2,
        quantityAvailable: 2,
        pricePerDay: 200.00,
        category: 'Floors',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      InventoryItemModel(
        id: 'item_008',
        name: 'Bar Setup Package',
        description: 'Complete bar setup with tables, stools, and serving equipment. Includes linens and glassware.',
        imageUrls: ['https://images.unsplash.com/photo-1572116469696-31de0f17cc34?w=400'],
        totalQuantity: 4,
        quantityAvailable: 4,
        pricePerDay: 120.00,
        category: 'Bar',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    final batch = firestore.batch();
    for (final item in sampleInventoryItems) {
      final docRef = inventoryCollection.doc(item.id);
      batch.set(docRef, item.toMap());
    }
    await batch.commit();
  }
}