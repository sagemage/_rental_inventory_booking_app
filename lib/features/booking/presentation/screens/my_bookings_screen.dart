
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../user/presentation/providers/user_providers.dart';

import '../../../user/domain/entities/user.dart' as user_entities;

import '../../domain/entities/booking.dart';
import '../providers/booking_providers.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> 
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    



  // Load user bookings on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(userNotifierProvider).currentUser;
      if (currentUser != null) {
        ref.read(bookingNotifierProvider.notifier).getBookingsForUser(currentUser.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userNotifierProvider).currentUser;
    final bookingState = ref.watch(bookingNotifierProvider);

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Bookings')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Please log in to view your bookings',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(Icons.pending),
              text: 'Pending',
              height: 60,
            ),
            Tab(
              icon: Icon(Icons.check_circle),
              text: 'Confirmed',
              height: 60,
            ),
            Tab(
              icon: Icon(Icons.play_circle),
              text: 'In Progress',
              height: 60,
            ),
            Tab(
              icon: Icon(Icons.done_all),
              text: 'Completed',
              height: 60,
            ),
            Tab(
              icon: Icon(Icons.cancel),
              text: 'Cancelled',
              height: 60,
            ),
            Tab(
              icon: Icon(Icons.error),
              text: 'Issues',
              height: 60,
            ),
          ],
        ),
        actions: [

          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(bookingNotifierProvider.notifier).getBookingsForUser(currentUser.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/booking');
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingListTab(
            bookingState.bookings.where((b) => b.status == BookingStatus.pending).toList(),
            'No pending bookings',
            'Your bookings awaiting owner confirmation will appear here.',
          ),
          _buildBookingListTab(
            bookingState.bookings.where((b) => b.status == BookingStatus.confirmed).toList(),
            'No confirmed bookings',
            'Your confirmed bookings ready for delivery will appear here.',
          ),
          _buildBookingListTab(
            bookingState.bookings.where((b) => b.status == BookingStatus.inProgress).toList(),
            'No active bookings',
            'Your bookings currently in progress will appear here.',
          ),
          _buildBookingListTab(
            bookingState.bookings.where((b) => b.status == BookingStatus.completed).toList(),
            'No completed bookings',
            'Your completed bookings will appear here.',
          ),
          _buildBookingListTab(
            bookingState.bookings.where((b) => b.status == BookingStatus.cancelled).toList(),
            'No cancelled bookings',
            'Your cancelled bookings will appear here.',
          ),

          _buildBookingListTab(
            bookingState.bookings.where((b) => b.damageFee != null && b.damageFee! > 0).toList(),
            'No bookings with issues',
            'Bookings with damage or disputes will appear here.',
          ),
        ],
      ),
    );
  }

  Widget _buildBookingListTab(List<Booking> bookings, String emptyTitle, String emptySubtitle) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              emptyTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                emptySubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/inventory');
              },
              icon: const Icon(Icons.inventory),
              label: const Text('Browse Inventory'),
            ),
          ],
        ),
      );
    }


    return RefreshIndicator(
      onRefresh: () async {
        final currentUser = ref.read(userNotifierProvider).currentUser;
        if (currentUser != null) {
          ref.read(bookingNotifierProvider.notifier).getBookingsForUser(currentUser.id);
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(bookings[index]);
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final statusColor = _getStatusColor(booking.status);
    final statusIcon = _getStatusIcon(booking.status);
    final paymentStatusColor = _getPaymentStatusColor(booking.paymentStatus);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showBookingDetails(booking),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with booking reference and status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking #${booking.id.substring(0, 8).toUpperCase()}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Created ${DateFormat('MMM d, y').format(booking.createdAt)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          _getStatusText(booking.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),

              // Event details
              if (booking.eventType != null) ...[
                Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      booking.eventType!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],

              // Date range
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('MMM d').format(booking.startDate)} - ${DateFormat('MMM d, y').format(booking.endDate)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Items summary
              Row(
                children: [
                  const Icon(Icons.inventory_2, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${booking.items.length} item(s)',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Financial details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₱${booking.totalAmount.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Payment Status',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: paymentStatusColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getPaymentStatusText(booking.paymentStatus),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Action buttons based on status
              _buildActionButtons(booking),


              // Damage fees warning
              if (booking.damageFee != null && booking.damageFee! > 0)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Damage fee: ₱${booking.damageFee!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Booking booking) {
    switch (booking.status) {
      case BookingStatus.pending:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _cancelBooking(booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.cancel, size: 16),
                label: const Text('Cancel Booking'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _contactOwner(booking),
                icon: const Icon(Icons.phone, size: 16),
                label: const Text('Contact Owner'),
              ),
            ),
          ],
        );

      case BookingStatus.confirmed:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _modifyBooking(booking),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Modify'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _contactOwner(booking),
                icon: const Icon(Icons.phone, size: 16),
                label: const Text('Contact Owner'),
              ),
            ),
          ],
        );

      case BookingStatus.inProgress:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _extendRental(booking),
                icon: const Icon(Icons.add_circle, size: 16),
                label: const Text('Extend Rental'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _reportIssue(booking),
                icon: const Icon(Icons.report_problem, size: 16),
                label: const Text('Report Issue'),
              ),
            ),
          ],
        );

      case BookingStatus.completed:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _rateAndReview(booking),
                icon: const Icon(Icons.star, size: 16),
                label: const Text('Rate & Review'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _bookAgain(booking),
                icon: const Icon(Icons.repeat, size: 16),
                label: const Text('Book Again'),
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
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

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'PENDING';
      case BookingStatus.confirmed:
        return 'CONFIRMED';
      case BookingStatus.inProgress:
        return 'IN PROGRESS';
      case BookingStatus.completed:
        return 'COMPLETED';
      case BookingStatus.cancelled:
        return 'CANCELLED';
      case BookingStatus.declined:
        return 'DECLINED';
      default:
        return 'UNKNOWN';
    }
  }

  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.partialPaid:
        return Colors.blue;
      case PaymentStatus.fullyPaid:
        return Colors.green;
      case PaymentStatus.overdue:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'PENDING';
      case PaymentStatus.partialPaid:
        return 'PARTIAL';
      case PaymentStatus.fullyPaid:
        return 'PAID';
      case PaymentStatus.overdue:
        return 'OVERDUE';
      default:
        return 'UNKNOWN';
    }
  }

  // Action methods
  void _showBookingDetails(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking #${booking.id.substring(0, 8).toUpperCase()}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status: ${_getStatusText(booking.status)}'),
              const SizedBox(height: 8),
              if (booking.eventType != null) ...[
                Text('Event Type: ${booking.eventType}'),
                const SizedBox(height: 4),
              ],
              Text('Dates: ${DateFormat('MMM d').format(booking.startDate)} - ${DateFormat('MMM d, y').format(booking.endDate)}'),
              const SizedBox(height: 4),
              Text('Total Amount: ₱${booking.totalAmount.toStringAsFixed(0)}'),
              const SizedBox(height: 4),
              Text('Payment Status: ${_getPaymentStatusText(booking.paymentStatus)}'),
              const SizedBox(height: 8),
              Text(
                'Items:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              ...booking.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• ${item.name} (Qty: ${item.quantity}) - ₱${item.subtotal.toStringAsFixed(0)}'),
              )),
              if (booking.eventNotes != null && booking.eventNotes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Notes:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(booking.eventNotes!),
              ],
            ],
          ),
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

  void _cancelBooking(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(bookingNotifierProvider.notifier).cancelBooking(booking.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking cancelled successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to cancel booking: ${e.toString()}')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  void _contactOwner(Booking booking) {
    // TODO: Implement contact owner functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact owner feature coming soon')),
    );
  }

  void _modifyBooking(Booking booking) {
    // TODO: Implement modify booking functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Modify booking feature coming soon')),
    );
  }

  void _extendRental(Booking booking) {
    // TODO: Implement extend rental functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Extend rental feature coming soon')),
    );
  }

  void _reportIssue(Booking booking) {
    // TODO: Implement report issue functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report issue feature coming soon')),
    );
  }

  void _rateAndReview(Booking booking) {
    // TODO: Implement rate and review functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rate and review feature coming soon')),
    );
  }

  void _bookAgain(Booking booking) {
    context.go('/inventory');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
