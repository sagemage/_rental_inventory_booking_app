import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../providers/owner_dashboard_providers.dart';

class OwnerInventoryManageScreen extends ConsumerStatefulWidget {
  const OwnerInventoryManageScreen({super.key});

  @override
  ConsumerState<OwnerInventoryManageScreen> createState() => _OwnerInventoryManageScreenState();
}

class _OwnerInventoryManageScreenState extends ConsumerState<OwnerInventoryManageScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(inventoryNotifierProvider.notifier).loadInventoryList();
      ref.read(ownerDashboardNotifierProvider.notifier).loadOwnerBookings('owner'); // Assuming owner id
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(inventoryNotifierProvider);
    final bookingState = ref.watch(ownerDashboardNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Owner Dashboard', style: Theme.of(context).textTheme.headlineLarge),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Inventory'),
            Tab(text: 'Bookings'),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () {
                // For simplicity navigate to edit with id 'new'
                context.go('/owner_dashboard/edit/new');
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          // Inventory Tab
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: inventoryState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: inventoryState.items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = inventoryState.items[index];
                      return ListTile(
                        leading: SizedBox(width: 64, height: 64, child: item.imageUrl.isNotEmpty ? Image.network(item.imageUrl) : Container()),
                        title: Text(item.name, style: Theme.of(context).textTheme.titleLarge),
                        subtitle: Text('Stock: ${item.quantityAvailable} · \$${item.pricePerDay.toStringAsFixed(2)}/day', style: Theme.of(context).textTheme.bodyMedium),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => context.go('/owner_dashboard/edit/${item.id}'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delete not implemented')));
                            },
                          ),
                        ]),
                      );
                    },
                  ),
          ),
          // Bookings Tab
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: bookingState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: bookingState.bookings.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final booking = bookingState.bookings[index];
                      return ListTile(
                        title: Text('Booking ${booking.id}', style: Theme.of(context).textTheme.titleLarge),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${booking.status}', style: Theme.of(context).textTheme.bodyMedium),
                            Text('Dates: ${booking.startDate.toLocal()} - ${booking.endDate.toLocal()}', style: Theme.of(context).textTheme.bodySmall),
                            Text('Items: ${booking.items.length}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'confirm') {
                              ref.read(ownerDashboardNotifierProvider.notifier).updateBookingStatusForId(bookingId: booking.id, status: BookingStatus.confirmed);
                            } else if (value == 'cancel') {
                              ref.read(ownerDashboardNotifierProvider.notifier).updateBookingStatusForId(bookingId: booking.id, status: BookingStatus.cancelled);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'confirm', child: Text('Confirm')),
                            const PopupMenuItem(value: 'cancel', child: Text('Cancel')),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}