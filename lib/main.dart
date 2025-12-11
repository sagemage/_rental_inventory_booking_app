// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';

// Ensure these imports point to the correct, clean files:
import 'package:rental_inventory_booking_app/firebase_options.dart'; 
import 'package:rental_inventory_booking_app/core/theme/theme.dart';
import 'package:rental_inventory_booking_app/core/config/routes.dart'; 

void main() async {
  // Required for Flutter to call native code, like Firebase initialization
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // Initialize Firebase using the auto-generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Wrap the app in ProviderScope for Riverpod state management
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  // Correct method signature for ConsumerWidget
  Widget build(BuildContext context, WidgetRef ref) { 
    // Watch the GoRouter configuration defined in routes.dart
    final GoRouter router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Rental Inventory Booking App',
      
      // Use the router configuration
      routerConfig: router, 
      
      // Apply theming
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Use system setting for light/dark mode
      
      debugShowCheckedModeBanner: false,
    );
  }
}