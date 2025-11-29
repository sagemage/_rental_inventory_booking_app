import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_inventory_booking_app/features/user/data/models/user_model.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';
import 'dart:developer'; // <--- NEW IMPORT for logging

// --- DEFINED TEST PASSWORD ---
// This is the password you will use to log in to ALL seeded accounts.
const String kTestPassword = 'password123';
// -----------------------------

Future<void> main(List<String> args) async {
  // 1. Initialize Firebase
  // Note: WidgetsFlutterBinding.ensureInitialized() is typically needed 
  // if this script is running inside a Flutter environment.
  // Assuming it's initialized correctly in the execution environment.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log('Starting user seeding...'); // Replaced print() with log()

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance; // Initialize Auth
  final usersCollection = firestore.collection('users');

  // Sample users for UAT - Removed placeholder IDs as they are overwritten by Auth UID
  final List<Map<String, dynamic>> initialUsersData = [
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
  
  // List to hold the final UserModel objects with Auth UIDs
  final List<UserModel> seededUsers = [];

  try {
    // 1. AUTHENTICATION (Creation and password assignment)
    log('Starting Firebase Auth creation...'); // Replaced print() with log()
    for (final userData in initialUsersData) {
      final email = userData['email'] as String;
      
      try {
        // Attempt to create the user with email and the test password
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: kTestPassword,
        );
        
        final uid = userCredential.user!.uid;
        log('Created Auth user: $email with UID $uid'); // Replaced print() with log()
        
        // Create the final UserModel using the Auth UID
        final userModel = UserModel(
          id: uid, 
          fullName: userData['fullName'] as String,
          // FIX: Explicitly cast to String, which is guaranteed in the map, 
          // and let the UserModel's nullable definition handle the String? type.
          phoneNumber: userData['phoneNumber'] as String,
          email: email,
          address: userData['address'] as String,
          role: userData['role'] as UserRole,
        );
        seededUsers.add(userModel);

      } on FirebaseAuthException catch (e) {
         // If user already exists, retrieve the existing UID
        if (e.code == 'email-already-in-use') {
          log('Auth account for $email already exists. Skipping Auth creation.'); // Replaced print() with log()
          
          // Sign in to get the existing UID
          final userCredential = await auth.signInWithEmailAndPassword(
            email: email,
            password: kTestPassword,
          );
          
          final uid = userCredential.user!.uid;
          
          // Create the final UserModel using the existing Auth UID
          final userModel = UserModel(
            id: uid, 
            fullName: userData['fullName'] as String,
            // FIX: Explicitly cast to String, which is guaranteed in the map, 
            // and let the UserModel's nullable definition handle the String? type.
            phoneNumber: userData['phoneNumber'] as String,
            email: email,
            address: userData['address'] as String,
            role: userData['role'] as UserRole,
          );
          seededUsers.add(userModel);
          
        } else {
          log('Auth Error for $email: ${e.message}'); // Replaced print() with log()
          // Continue to next user on non-critical Auth errors
        }
      }
    }
    log('✓ Successfully completed Firebase Auth seeding.'); // Replaced print() with log()


    // 2. FIRESTORE (Profile data storage)
    log('Starting Firestore profile creation...'); // Replaced print() with log()
    final batch = firestore.batch();

    for (final user in seededUsers) {
      // Use the Auth UID for the document ID
      final docRef = usersCollection.doc(user.id); 
      batch.set(docRef, user.toMap());
      log('Prepared Firestore profile: ${user.fullName} (${user.role})'); // Replaced print() with log()
    }

    await batch.commit();
    log('✓ Successfully seeded ${seededUsers.length} users to Firestore'); // Replaced print() with log()
  } catch (e) {
    log('✗ Error seeding users: $e'); // Replaced print() with log()
    rethrow;
  } finally {
    // Close Firebase connection
    // Note: If you're running this as a simple Dart script, this might not be necessary
    // or might cause issues depending on the environment.
    // For Flutter/Dart CLI tools, it is safer to leave this out unless explicitly required.
    // await Firebase.app().delete(); 
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