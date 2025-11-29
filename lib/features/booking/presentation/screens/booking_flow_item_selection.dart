import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_inventory_booking_app/features/inventory/presentation/providers/inventory_providers.dart';
import '../providers/booking_providers.dart';
import 'package:rental_inventory_booking_app/features/booking/data/models/booking_model.dart';

class BookingItemSelectionScreen extends ConsumerStatefulWidget {
  const BookingItemSelectionScreen({super.key});

  @override
  ConsumerState<BookingItemSelectionScreen> createState() => _BookingItemSelectionScreenState();
}

class _BookingItemSelectionScreenState extends ConsumerState<BookingItemSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure inventory loaded
    Future.microtask(() => ref.read(inventoryNotifierProvider.notifier).loadInventoryList());
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(inventoryNotifierProvider);
    final bookingNotifier = ref.read(bookingNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Select Items', style: Theme.of(context).textTheme.headlineLarge)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: inventoryState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: inventoryState.items.length,
                itemBuilder: (context, index) {
                  final item = inventoryState.items[index];
                  return ListTile(
                    leading: item.imageUrl.isNotEmpty ? Image.network(item.imageUrl, width: 64, height: 64) : null,
                    title: Text(item.name, style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text('\$${item.pricePerDay.toStringAsFixed(2)} / day', style: Theme.of(context).textTheme.bodyMedium),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Add item to cart with quantity=1 for simplicity
                        bookingNotifier.addOrUpdateCartItem(BookingItemModel(itemId: item.id, quantity: 1));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to booking')));
                      },
                      child: const Text('Add'),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/booking/summary'),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}