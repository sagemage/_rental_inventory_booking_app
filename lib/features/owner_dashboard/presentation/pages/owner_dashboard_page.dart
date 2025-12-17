


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/presentation/providers/user_providers.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../../../booking/domain/entities/booking.dart';
import '../providers/owner_dashboard_providers.dart';
import '../state/owner_dashboard_notifier.dart';

class OwnerDashboardPage extends ConsumerStatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  ConsumerState<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends ConsumerState<OwnerDashboardPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(ownerDashboardNotifierProvider);
    final dashboardNotifier = ref.read(ownerDashboardNotifierProvider.notifier);
    final currentUser = ref.watch(userNotifierProvider).currentUser;

    // Check if user is owner
    if (currentUser?.role != UserRole.owner) {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 80, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Access Restricted',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Owner privileges required to access this dashboard'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.book_online), text: 'Bookings'),
            Tab(icon: Icon(Icons.inventory), text: 'Inventory'),
            Tab(icon: Icon(Icons.attach_money), text: 'Finance'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),

      onPressed: () => dashboardNotifier.loadDashboardOverview(currentUser!.id),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  context.push('/profile');
                  break;
                case 'logout':
                  ref.read(userNotifierProvider.notifier).signOut();
                  context.go('/auth');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(dashboardState),
          _buildBookingsTab(dashboardState),
          _buildInventoryTab(dashboardState),
          _buildFinanceTab(dashboardState),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(OwnerDashboardState state) {
    final today = DateTime.now();
    final todayBookings = state.bookings.where((b) => b.isToday).toList();
    final upcomingBookings = state.bookings.where((b) => b.isUpcoming).take(5).toList();
    final itemsOut = state.bookings
        .where((b) => b.status == BookingStatus.inProgress)
        .expand((b) => b.items)
        .fold<int>(0, (sum, item) => sum + item.quantity);


    return RefreshIndicator(
      onRefresh: () async => ref.read(ownerDashboardNotifierProvider.notifier).loadOwnerBookings(ref.read(userNotifierProvider).currentUser!.id),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${ref.read(userNotifierProvider).currentUser?.fullName ?? "Owner"}!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('EEEE, MMMM d, y').format(today),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Today's Stats
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                  'Today\'s Bookings',
                  todayBookings.length.toString(),
                  Icons.calendar_today,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Items Out',
                  itemsOut.toString(),
                  Icons.local_shipping,
                  Colors.orange,
                ),
                _buildStatCard(
                  'Pending Approval',
                  state.bookings.where((b) => b.status == BookingStatus.pending).length.toString(),
                  Icons.pending,
                  Colors.red,
                ),
                _buildStatCard(
                  'Total Revenue',
                  '₱${state.totalRevenue.toStringAsFixed(0)}',
                  Icons.monetization_on,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Today's Bookings
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.today),
                        const SizedBox(width: 8),
                        Text('Today\'s Bookings', style: Theme.of(context).textTheme.titleLarge),
                        const Spacer(),
                        TextButton(
                          onPressed: () => _tabController.animateTo(1),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                  if (todayBookings.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No bookings scheduled for today'),
                    )
                  else
                    ...todayBookings.map((booking) => _buildBookingTile(booking)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Upcoming Events
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.upcoming),
                        const SizedBox(width: 8),
                        Text('Upcoming Events', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  if (upcomingBookings.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No upcoming events'),
                    )
                  else
                    ...upcomingBookings.map((booking) => _buildUpcomingEventTile(booking)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Actions
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildQuickAction(
                        'Add Item',
                        Icons.add_box,
                        () => context.push('/owner/inventory/add'),
                      ),
                      _buildQuickAction(
                        'New Booking',
                        Icons.add_shopping_cart,
                        () => _showManualBookingDialog(),
                      ),
                      _buildQuickAction(
                        'Reports',
                        Icons.analytics,
                        () => _tabController.animateTo(3),
                      ),
                      _buildQuickAction(
                        'Settings',
                        Icons.settings,
                        () => context.push('/owner/settings'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsTab(OwnerDashboardState state) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Pending', icon: Icon(Icons.pending)),
              Tab(text: 'Active', icon: Icon(Icons.play_circle)),
              Tab(text: 'History', icon: Icon(Icons.history)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildBookingList(
                  state.bookings.where((b) => b.status == BookingStatus.pending).toList(),
                  'No pending bookings',
                ),
                _buildBookingList(
                  state.bookings.where((b) => 
                    b.status == BookingStatus.confirmed || b.status == BookingStatus.inProgress).toList(),
                  'No active bookings',
                ),
                _buildBookingList(
                  state.bookings.where((b) => 
                    b.status == BookingStatus.completed || b.status == BookingStatus.cancelled).toList(),
                  'No booking history',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryTab(OwnerDashboardState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text('Inventory Overview', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => context.push('/owner/inventory/add'),
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: state.inventory.length,
              itemBuilder: (context, index) {
                final item = state.inventory[index];
                return _buildInventoryCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceTab(OwnerDashboardState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Financial Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(
                'Total Revenue',
                '₱${state.totalRevenue.toStringAsFixed(0)}',
                Icons.monetization_on,
                Colors.green,
              ),
              _buildStatCard(
                'Pending Payments',
                '₱${state.pendingPayments.toStringAsFixed(0)}',
                Icons.pending,
                Colors.orange,
              ),
              _buildStatCard(
                'Completed Payments',
                '₱${state.completedPayments.toStringAsFixed(0)}',
                Icons.check_circle,
                Colors.blue,
              ),
              _buildStatCard(
                'Damage/Loss Fees',
                '₱${state.damageFees.toStringAsFixed(0)}',
                Icons.warning,
                Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Recent Payments', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...(state.recentPayments.isEmpty
            ? [const Text('No recent payments')]
            : state.recentPayments.take(5).map((payment) => _buildPaymentTile(payment)).toList()),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingTile(Booking booking) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getStatusColor(booking.status),
        child: Icon(_getStatusIcon(booking.status), color: Colors.white),
      ),
      title: Text('${booking.clientId} - ${booking.eventType.name}'),
      subtitle: Text(
        '${DateFormat('MMM d').format(booking.startDate)} - ${booking.items.length} items\n'
        '₱${booking.totalAmount.toStringAsFixed(0)}'
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _handleBookingAction(booking, value),
        itemBuilder: (context) => [
          if (booking.status == BookingStatus.pending) ...[
            const PopupMenuItem(value: 'confirm', child: Text('Confirm')),
            const PopupMenuItem(value: 'decline', child: Text('Decline')),
          ] else if (booking.status == BookingStatus.confirmed) ...[
            const PopupMenuItem(value: 'start', child: Text('Start Event')),
            const PopupMenuItem(value: 'modify', child: Text('Modify')),
          ] else if (booking.status == BookingStatus.inProgress) ...[
            const PopupMenuItem(value: 'complete', child: Text('Complete')),
            const PopupMenuItem(value: 'damage', child: Text('Add Damage Fee')),
          ],
          const PopupMenuItem(value: 'view', child: Text('View Details')),
        ],
      ),
      onTap: () => _showBookingDetails(booking),
    );
  }

  Widget _buildUpcomingEventTile(Booking booking) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(DateFormat('d').format(booking.startDate), 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      title: Text(booking.eventType.name),
      subtitle: Text('${booking.clientId} - ${booking.items.length} items'),
      trailing: Text(DateFormat('MMM d').format(booking.startDate)),
      onTap: () => _showBookingDetails(booking),
    );
  }

  Widget _buildBookingList(List<Booking> bookings, String emptyMessage) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(emptyMessage),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) => _buildBookingTile(bookings[index]),
    );
  }


  Widget _buildInventoryCard(InventoryItem item) {
    final availability = item.quantityAvailable;
    final status = availability > 0 ? 'Available' : 'Out of Stock';
    final statusColor = availability > 0 ? Colors.green : Colors.red;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),

              child: item.imageUrls.isNotEmpty
                ? Image.network(item.imageUrls.first, fit: BoxFit.cover)
                : const Icon(Icons.inventory_2, size: 48, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('₱${item.pricePerDay}/day'),
                  Text(
                    '$status ($availability available)',
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => context.push('/owner/inventory/${item.id}/edit'),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                  ),
                ),
                IconButton(
                  onPressed: () => _showItemDetails(item),
                  icon: const Icon(Icons.info, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(dynamic payment) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        child: const Icon(Icons.payment, color: Colors.white),
      ),
      title: Text('Booking Payment'),
      subtitle: Text(DateFormat('MMM d, y').format(DateTime.now())),
      trailing: Text(
        '₱${payment.toStringAsFixed(0)}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: Theme.of(context).primaryColor),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.inProgress:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.grey;
      case BookingStatus.cancelled:
      case BookingStatus.declined:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.pending;
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.inProgress:
        return Icons.play_circle;
      case BookingStatus.completed:
        return Icons.done_all;
      case BookingStatus.cancelled:
      case BookingStatus.declined:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }



  void _handleBookingAction(Booking booking, String action) {
    final bookingNotifier = ref.read(ownerDashboardNotifierProvider.notifier);
    final currentUser = ref.read(userNotifierProvider).currentUser;
    
    switch (action) {
      case 'confirm':
        bookingNotifier.updateBookingStatusForId(
          bookingId: booking.id, 
          status: BookingStatus.confirmed
        );
        break;
      case 'decline':
        bookingNotifier.updateBookingStatusForId(
          bookingId: booking.id, 
          status: BookingStatus.declined
        );
        break;
      case 'start':
        bookingNotifier.updateBookingStatusForId(
          bookingId: booking.id, 
          status: BookingStatus.inProgress
        );
        break;
      case 'complete':
        bookingNotifier.updateBookingStatusForId(
          bookingId: booking.id, 
          status: BookingStatus.completed
        );
        break;
      case 'modify':
        _showModifyBookingDialog(booking);
        break;
      case 'damage':
        _showDamageFeeDialog(booking);
        break;
      case 'view':
        _showBookingDetails(booking);
        break;
    }
  }

  void _showBookingDetails(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking ID: ${booking.id}'),
            Text('Status: ${booking.status.toString()}'),
            Text('Event: ${booking.eventType ?? "N/A"}'),
            Text('Dates: ${DateFormat('MMM d').format(booking.startDate)} - ${DateFormat('MMM d').format(booking.endDate)}'),
            Text('Total: ₱${booking.totalAmount.toStringAsFixed(0)}'),
            Text('Payment Status: ${booking.paymentStatus.toString()}'),
            Text('Items:'),
            ...booking.items.map((item) =>
              Text('• ${item.name} (Qty: ${item.quantity})')
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showModifyBookingDialog(Booking booking) {
    // TODO: Implement modify booking dialog
  }

  void _showDamageFeeDialog(Booking booking) {
    // TODO: Implement damage fee dialog
  }

  void _showManualBookingDialog() {
    // TODO: Implement manual booking dialog
  }


  void _showItemDetails(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${item.description}'),
            Text('Price: ₱${item.pricePerDay}/day'),
            Text('Available: ${item.quantityAvailable}/${item.totalQuantity}'),
            if (item.imageUrls.isNotEmpty)
              Text('Image: ${item.imageUrls.first}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
