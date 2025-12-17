
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/booking_providers.dart';
import '../../../user/presentation/providers/session_provider.dart';
import '../../../user/presentation/providers/user_providers.dart';
import '../../domain/entities/booking.dart';

class BookingSummaryScreen extends ConsumerStatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  ConsumerState<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends ConsumerState<BookingSummaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _clientEmailController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _deliveryInstructionsController = TextEditingController();
  final _eventNotesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingNotifierProvider);
    final bookingNotifier = ref.read(bookingNotifierProvider.notifier);
    final String? userId = ref.read(currentUserIdProvider);
    final currentUser = ref.read(userNotifierProvider).currentUser;

    // Check if extra data is passed (single item booking)
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final singleItem = extra?['item'];
    final startDate = extra?['startDate'] as DateTime?;
    final endDate = extra?['endDate'] as DateTime?;
    final quantity = extra?['quantity'] as int?;

    double total = 0;
    if (singleItem != null && startDate != null && endDate != null && quantity != null) {
      final days = endDate.difference(startDate).inDays + 1;
      total = singleItem.pricePerDay * quantity * days;
    } else {
      // Calculate from cart
      for (var item in bookingState.cartItems) {
        final days = bookingState.endDate!.difference(bookingState.startDate!).inDays + 1;
        total += item.dailyRate * item.quantity * days;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Summary', style: Theme.of(context).textTheme.headlineMedium)
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text('Items', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  if (singleItem != null)
                    ListTile(
                      title: Text(singleItem.name),
                      subtitle: Text('Qty: $quantity, Dates: ${startDate!.month}/${startDate.day} - ${endDate!.month}/${endDate.day}'),
                    )
                  else
                    ...bookingState.cartItems.map((c) => 
                      ListTile(
                        title: Text(c.name), 
                        subtitle: Text('Qty: ${c.quantity} - ₱${c.dailyRate}/day'),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text('Total: ₱${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text('Client Information', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _clientNameController,
                          decoration: const InputDecoration(labelText: 'Full Name *'),
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _clientPhoneController,
                          decoration: const InputDecoration(labelText: 'Phone Number *'),
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _clientEmailController,
                          decoration: const InputDecoration(labelText: 'Email (optional)'),
                        ),
                        const SizedBox(height: 16),
                        Text('Event Details', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        if (singleItem != null)
                          TextFormField(
                            initialValue: singleItem is Map ? (singleItem['deliveryAddress'] as String?) : null,
                            decoration: const InputDecoration(labelText: 'Delivery Address *'),
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                          )
                        else
                          TextFormField(
                            controller: _deliveryAddressController,
                            decoration: const InputDecoration(labelText: 'Delivery Address *'),
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _deliveryInstructionsController,
                          decoration: const InputDecoration(labelText: 'Delivery Instructions (optional)'),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _eventNotesController,
                          decoration: const InputDecoration(labelText: 'Event Notes (optional)'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Payment Terms: 30% deposit on delivery, remaining balance on return',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600]
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: bookingState.isLoading ? null : () async {
                if (_formKey.currentState?.validate() ?? false) {
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please sign in to make a booking'))
                    );
                    return;
                  }

                  final clientName = _clientNameController.text.trim();
                  final clientPhone = _clientPhoneController.text.trim();
                  final clientEmail = _clientEmailController.text.trim();
                  final deliveryAddress = singleItem != null 
                    ? (extra!['address'] as String) 
                    : _deliveryAddressController.text.trim();
                  final deliveryInstructions = _deliveryInstructionsController.text.trim();
                  final eventNotes = _eventNotesController.text.trim();

                  try {
                    if (singleItem != null) {
                      // Create booking for single item
                      await bookingNotifier.makeBookingForItem(
                        userId: userId,
                        clientName: clientName,
                        clientPhone: clientPhone,
                        clientEmail: clientEmail.isEmpty ? null : clientEmail,
                        deliveryAddress: deliveryAddress,
                        inventoryId: singleItem.id,
                        name: singleItem.name,
                        dailyRate: singleItem.pricePerDay,
                        startDate: startDate!,
                        endDate: endDate!,
                        quantity: quantity!,
                        eventType: BookingType.other, // Default to other
                        eventNotes: eventNotes.isEmpty ? null : eventNotes,
                        deliveryInstructions: deliveryInstructions.isEmpty ? null : deliveryInstructions,
                        ownerId: 'default_owner', // TODO: Get from inventory item
                      );
                    } else {
                      // Create booking from cart
                      await bookingNotifier.makeBooking(
                        userId: userId,
                        clientName: clientName,
                        clientPhone: clientPhone,
                        clientEmail: clientEmail.isEmpty ? null : clientEmail,
                        deliveryAddress: deliveryAddress,
                        eventType: BookingType.other, // Default to other
                        eventNotes: eventNotes.isEmpty ? null : eventNotes,
                        deliveryInstructions: deliveryInstructions.isEmpty ? null : deliveryInstructions,
                        ownerId: 'default_owner', // TODO: Get from inventory items
                      );
                    }

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Booking submitted successfully! You will receive confirmation shortly.'))
                      );
                      context.go('/'); // Go to home or profile
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error creating booking: ${e.toString()}'))
                      );
                    }
                  }
                }
              },
              child: bookingState.isLoading 
                ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)
                  )
                : const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _clientEmailController.dispose();
    _deliveryAddressController.dispose();
    _deliveryInstructionsController.dispose();
    _eventNotesController.dispose();
    super.dispose();
  }
}

