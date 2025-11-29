import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


// Import your screens here
// Example (replace with your real screens)
import 'package:rental_inventory_booking_app/features/inventory/presentation/screens/inventory_list_screen.dart';
import 'package:rental_inventory_booking_app/features/inventory/presentation/screens/inventory_detail_screen.dart';

// Riverpod provider for GoRouter
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/inventory',
    routes: [
      GoRoute(
        path: '/inventory',
        builder: (context, state) => const InventoryListScreen(),
      ),
      GoRoute(
        path: '/inventory/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return InventoryDetailScreen(id: id);
        },
      ),
    ],
  );
});
