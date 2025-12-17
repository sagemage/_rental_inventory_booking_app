import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_inventory_booking_app/firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('inventory_items').get();
  print('Documents in inventory_items: ${snapshot.docs.length}');
  for (final doc in snapshot.docs) {
    print('${doc.id}: ${doc.data()}');
  }
}
