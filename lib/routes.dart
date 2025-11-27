import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';
import 'package:rental_inventory_booking_app/features/user/presentation/providers/session_provider.dart';
import 'package:rental_inventory_booking_app/features/inventory/presentation/screens/inventory_list_screen.dart';
import 'package:rental_inventory_booking_app/features/inventory/presentation/screens/inventory_detail_screen.dart';
import 'package:rental_inventory_booking_app/features/inventory/presentation/screens/owner_inventory_manage_screen.dart';
import 'package:rental_inventory_booking_app/features/inventory/presentation/screens/owner_edit_item_screen.dart';

/// Centralized GoRouter provider wired to Riverpod session state.
final routerProvider = Provider<GoRouter>((ref) {
  // watch current user role so router rebuilds on role changes
  final role = ref.watch(currentUserRoleProvider).state;

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final loc = state.location;

    // Guard owner routes
    if (loc.startsWith('/owner')) {
      if (role != UserRole.owner) {
        return '/inventory';
      }
    }

    // Allow everything else
    return null;
  }

  return GoRouter(
    initialLocation: '/inventory',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/inventory',
      ),
      GoRoute(
        path: '/inventory',
        name: 'inventory_list',
        builder: (context, state) => const InventoryListScreen(),
      ),
      GoRoute(
        path: '/inventory/:id',
        name: 'inventory_detail',
        builder: (context, state) => InventoryDetailScreen(id: state.params['id']!),
      ),
      GoRoute(
        path: '/owner/inventory',
        name: 'owner_inventory',
        builder: (context, state) => const OwnerInventoryManageScreen(),
      ),
      GoRoute(
        path: '/owner/inventory/edit/:id',
        name: 'owner_edit_item',
        builder: (context, state) => OwnerEditItemScreen(id: state.params['id']!),
      ),
    ],
    redirect: (context, state) => redirectLogic(context, state),
  );
});
