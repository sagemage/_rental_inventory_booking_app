import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../../../user/presentation/providers/user_providers.dart';

class BookingItemScreen extends ConsumerStatefulWidget {
  final String itemId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int quantity;

  const BookingItemScreen({
    super.key,
    required this.itemId,
    this.startDate,
    this.endDate,
    this.quantity = 1,
  });

  @override
  ConsumerState<BookingItemScreen> createState() => _BookingItemScreenState();
}

class _BookingItemScreenState extends ConsumerState<BookingItemScreen> {
  late DateTime startDate;
  late DateTime endDate;
  late int quantity;
  final _notesController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startDate = widget.startDate ?? DateTime.now().add(const Duration(days: 1));
    endDate = widget.endDate ?? startDate.add(const Duration(days: 1));
    quantity = widget.quantity;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _confirmBooking() async {
    final userState = ref.read(userNotifierProvider);
    if (userState.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to make a booking')),
      );
      return;
    }

    final inventoryState = ref.read(inventoryNotifierProvider);
    final item = inventoryState.items.where((item) => item.id == widget.itemId).firstOrNull;

    if (item == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item not found')),
      );
      return;
    }

    // Navigate to booking summary with all details
    context.go('/booking/summary', extra: {
      'item': item,
      'startDate': startDate,
      'endDate': endDate,
      'quantity': quantity,
      'notes': _notesController.text,
      'address': _addressController.text,
      'user': userState.currentUser,
    });
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(inventoryNotifierProvider);
    final userState = ref.watch(userNotifierProvider);
    final item = inventoryState.items.where((item) => item.id == widget.itemId).firstOrNull;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Item Not Found')),
        body: const Center(child: Text('Item not found')),
      );
    }

    final days = endDate.difference(startDate).inDays + 1; // inclusive
    final totalPrice = item.pricePerDay * quantity * days;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: item.imageUrl.isNotEmpty
                          ? Image.network(item.imageUrl, fit: BoxFit.cover)
                          : Container(color: Colors.grey[300]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '\$${item.pricePerDay.toStringAsFixed(2)} × $quantity × $days days = \$${totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Booking Details
            const Text(
              'Booking Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Date
            ListTile(
              title: const Text('Rental Dates'),
              subtitle: Text('${startDate.month}/${startDate.day}/${startDate.year} - ${endDate.month}/${endDate.day}/${endDate.year}'),
              leading: const Icon(Icons.calendar_today),
            ),

            // Quantity
            ListTile(
              title: const Text('Quantity'),
              subtitle: Text('$quantity ${quantity == 1 ? 'unit' : 'units'}'),
              leading: const Icon(Icons.inventory),
            ),

            const SizedBox(height: 16),

            // Delivery Address
            const Text(
              'Delivery Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: 'Enter delivery address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter delivery address';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Special Notes
            const Text(
              'Special Notes (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Any special requests or notes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // Total Price
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Price:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Payment Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Payment Terms: 50% due upon delivery, remaining 50% due upon return. Damage/loss fees may apply.',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Confirm Button
            if (userState.currentUser != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmBooking,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Confirm Booking'),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Please log in to continue with booking',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You need to be logged in to make reservations',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}