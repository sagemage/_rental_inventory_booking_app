import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rental_inventory_booking_app/core/presentation/shell_screen.dart';

import 'package:rental_inventory_booking_app/features/inventory/presentation/screens/inventory_list_screen.dart';
import 'package:rental_inventory_booking_app/features/inventory/presentation/screens/inventory_detail_screen.dart';
import 'package:rental_inventory_booking_app/features/booking/presentation/screens/booking_item_screen.dart';
import 'package:rental_inventory_booking_app/features/booking/presentation/screens/booking_flow_item_selection.dart';

import 'package:rental_inventory_booking_app/features/booking/presentation/screens/booking_summary_screen.dart';

import 'package:rental_inventory_booking_app/features/user/presentation/screens/user_profile_screen.dart';
import 'package:rental_inventory_booking_app/features/user/presentation/providers/session_provider.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';

import 'package:rental_inventory_booking_app/features/owner_dashboard/presentation/screens/owner_edit_item_screen.dart';
import 'package:rental_inventory_booking_app/features/owner_dashboard/presentation/screens/owner_inventory_manage_screen.dart';



// Riverpod provider for GoRouter

final routerProvider = Provider<GoRouter>((ref) {


  return GoRouter(
    initialLocation: '/inventory',
    // Redirect guard for owner routes
    redirect: (context, state) {
      // Removed redirect for demo - allow access to all routes
      return null;
    },

    routes: [
      // 1. ShellRoute: This wraps all the main tabs in your Bottom Navigation Bar.
      ShellRoute(
        builder: (context, state, child) {
          // The ShellScreen contains the BottomNavigationBar
          // and manages which of the children (child) is displayed.
          return ShellScreen(child: child);
        },
        routes: [

          // 1.1. Inventory Branch (Path: /inventory)
          GoRoute(
            path: '/inventory',
            builder: (context, state) => const InventoryListScreen(),
            routes: [
              // Deep Link: /inventory/details/ID
              GoRoute(
                path: 'details/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return InventoryDetailScreen(id: id);
                },
              ),
            ],
          ),

          // 1.2. Booking Branch (Path: /booking)
          GoRoute(
            path: '/booking',
            builder: (context, state) => const BookingItemSelectionScreen(),
            routes: [
              GoRoute(
                path: 'summary',
                builder: (context, state) => const BookingSummaryScreen(),
              ),
            ],
          ),


          GoRoute(
            path: 'item/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final startDateStr = state.uri.queryParameters['startDate'];
              final endDateStr = state.uri.queryParameters['endDate'];
              final quantityStr = state.uri.queryParameters['quantity'];
              final startDate = startDateStr != null ? DateTime.parse(startDateStr) : null;
              final endDate = endDateStr != null ? DateTime.parse(endDateStr) : null;
              final quantity = quantityStr != null ? int.parse(quantityStr) : 1;
              return BookingItemScreen(itemId: id, startDate: startDate, endDate: endDate, quantity: quantity);
            },
          ),

          // 1.3. User Branch (Path: /user)
          GoRoute(
            path: '/user',
            builder: (context, state) => const UserProfileScreen(),
          ),


          // 1.4. Owner Dashboard Branch (Path: /owner_dashboard)
          GoRoute(
            path: '/owner_dashboard',
            builder: (context, state) => const OwnerInventoryManageScreen(),
            routes: [
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) => OwnerEditItemScreen(
                  id: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});