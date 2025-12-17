import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rental_inventory_booking_app/firebase_options.dart';

Future<void> main(List<String> args) async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('Querying inventory items...');

  final firestore = FirebaseFirestore.instance;
  final inventoryCollection = firestore.collection('inventory_items');

  try {
    final querySnapshot = await inventoryCollection.get();
    if (querySnapshot.docs.isEmpty) {
      print('No inventory items found.');
    } else {
      print('Found ${querySnapshot.docs.length} inventory items:');
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        print('- ${data['name'] ?? 'Unknown'} (ID: ${doc.id})');
      }
    }
  } catch (e) {
    print('Error querying inventory items: $e');
    rethrow;
  } finally {
    // Close Firebase connection
    await Firebase.app().delete();
  }
}