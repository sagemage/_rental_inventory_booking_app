import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/inventory_providers.dart';

class InventoryDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const InventoryDetailScreen({super.key, required this.id});

  @override
  ConsumerState<InventoryDetailScreen> createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends ConsumerState<InventoryDetailScreen> {
  DateTimeRange? selectedRange;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(inventoryNotifierProvider.notifier).loadInventoryItemDetails(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryNotifierProvider);
    final item = state.selectedItem;

    return Scaffold(
      appBar: AppBar(title: Text('Item Details', style: Theme.of(context).textTheme.headlineLarge)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: item == null
            ? state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(child: Text(state.error ?? 'Item not found', style: Theme.of(context).textTheme.bodyLarge))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.imageUrl.isNotEmpty)
                      Center(child: Image.network(item.imageUrl, height: 200, fit: BoxFit.cover)),
                    const SizedBox(height: 12),
                    Text(item.name, style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 8),
                    Text(item.description, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Text('Price: \$${item.pricePerDay.toStringAsFixed(2)} / day', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Available stock: ${item.quantityAvailable}', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 16),

                    // Date picker
                    Text('Select rental dates', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final now = DateTime.now();
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: now,
                          lastDate: now.add(const Duration(days: 365)),
                          initialDateRange: selectedRange,
                        );
                        if (picked != null) setState(() => selectedRange = picked);
                      },
                      child: Text(selectedRange == null ? 'Pick dates' : '${DateFormat.yMMMd().format(selectedRange!.start)} → ${DateFormat.yMMMd().format(selectedRange!.end)}'),
                    ),

                    const SizedBox(height: 12),
                    // Quantity picker
                    Row(
                      children: [
                        Text('Quantity', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('$quantity', style: Theme.of(context).textTheme.titleLarge),
                        IconButton(
                          onPressed: quantity < item.quantityAvailable ? () => setState(() => quantity++) : null,
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // Availability check / Proceed
                    ElevatedButton(
                      onPressed: (selectedRange != null && quantity > 0 && quantity <= item.quantityAvailable)
                          ? () {
                              // Here you would check bookings and proceed to booking flow.
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proceed to booking (not implemented)')));
                            }
                          : null,
                      child: const Text('Proceed to Booking'),
                    ),
                    const SizedBox(height: 12),
                    Text('If the requested dates/quantity are not available, the app should suggest alternative dates or similar items.', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
      ),
    );
  }
}
