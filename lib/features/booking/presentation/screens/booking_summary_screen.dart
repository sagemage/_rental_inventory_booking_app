import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_providers.dart';
import '../../../user/presentation/providers/session_provider.dart';

class BookingSummaryScreen extends ConsumerStatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  ConsumerState<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends ConsumerState<BookingSummaryScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingNotifierProvider);
    final bookingNotifier = ref.read(bookingNotifierProvider.notifier);
    final String? userId = ref.read(currentUserIdProvider);

    double total = 0; // price calculation placeholder

    return Scaffold(
      appBar: AppBar(title: Text('Booking Summary', style: Theme.of(context).textTheme.headlineMedium)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text('Items', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ...bookingState.cartItems.map((c) => ListTile(title: Text(c.itemId), subtitle: Text('Qty: ${c.quantity}'))),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Delivery address'),
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Notes (optional)'),
                        ),
                        const SizedBox(height: 12),
                        Text('Total: \$${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user signed in')));
                    return;
                  }
                  await bookingNotifier.makeBooking(userId: userId);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking submitted (pending)')));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
