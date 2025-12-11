import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rental_inventory_booking_app/core/presentation/shell_screen.dart';
import 'package:rental_inventory_booking_app/features/inventory/presentation/pages/inventory_list_page.dart';
import 'package:rental_inventory_booking_app/features/inventory/presentation/pages/inventory_details_screen.dart';
import 'package:rental_inventory_booking_app/features/booking/presentation/pages/booking_list_page.dart';
import 'package:rental_inventory_booking_app/features/user/presentation/pages/profile_screen.dart';
import 'package:rental_inventory_booking_app/features/owner/presentation/pages/owner_dashboard_page.dart'; 


final GoRouter router = GoRouter(
  // The app will start directly at the Inventory list
  initialLocation: '/inventory', 
  
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ShellScreen(child: child); 
      },
      routes: [
        // Tab 1: Inventory (Index 0)
        GoRoute(path: '/inventory', pageBuilder: (context, state) => const NoTransitionPage(child: InventoryListPage()), routes: [
            GoRoute(path: 'details/:id', builder: (context, state) => InventoryDetailsScreen(itemId: state.pathParameters['id']!)),
        ]),
        
        // Tab 2: Booking (Index 1)
        GoRoute(path: '/booking', pageBuilder: (context, state) => const NoTransitionPage(child: BookingListPage())),

        // Tab 3: Profile (User) (Index 2)
        GoRoute(path: '/profile', pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen())),
        
        // Tab 4: Owner Dashboard (Index 3)
        GoRoute(path: '/owner', pageBuilder: (context, state) => const NoTransitionPage(child: OwnerDashboardPage())),
      ],
    ),
    
    // REMOVED: /login route is now gone
  ],
  
  errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Page not found: ${state.uri}', style: const TextStyle(color: Colors.red)))),
);

final routerProvider = Provider<GoRouter>((ref) => router);