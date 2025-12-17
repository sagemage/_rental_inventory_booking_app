

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/owner_dashboard.dart';
import '../../domain/usecases/get_dashboard_overview.dart';
import '../../domain/usecases/get_owner_bookings.dart';
import '../../domain/usecases/update_booking_status.dart';
import '../../../user/domain/entities/user.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../../../booking/domain/entities/booking.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import '../providers/owner_dashboard_providers.dart';

// Extended State class with UI properties
class OwnerDashboardState extends Equatable {
  final OwnerDashboard? dashboard;
  final List<Booking> bookings;
  final List<InventoryItem> inventory;
  final bool isLoading;
  final String? errorMessage;
  
  // Financial properties
  final double totalRevenue;
  final double pendingPayments;
  final double completedPayments;
  final double damageFees;
  final List<double> recentPayments;

  const OwnerDashboardState({
    this.dashboard,
    this.bookings = const [],
    this.inventory = const [],
    this.isLoading = false,
    this.errorMessage,
    this.totalRevenue = 0.0,
    this.pendingPayments = 0.0,
    this.completedPayments = 0.0,
    this.damageFees = 0.0,
    this.recentPayments = const [],
  });

  OwnerDashboardState copyWith({
    OwnerDashboard? dashboard,
    List<Booking>? bookings,
    List<InventoryItem>? inventory,
    bool? isLoading,
    String? errorMessage,
    double? totalRevenue,
    double? pendingPayments,
    double? completedPayments,
    double? damageFees,
    List<double>? recentPayments,
  }) {
    return OwnerDashboardState(
      dashboard: dashboard ?? this.dashboard,
      bookings: bookings ?? this.bookings,
      inventory: inventory ?? this.inventory,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      pendingPayments: pendingPayments ?? this.pendingPayments,
      completedPayments: completedPayments ?? this.completedPayments,
      damageFees: damageFees ?? this.damageFees,
      recentPayments: recentPayments ?? this.recentPayments,
    );
  }

  @override
  List<Object?> get props => [
    dashboard, bookings, inventory, isLoading, errorMessage,
    totalRevenue, pendingPayments, completedPayments, damageFees, recentPayments
  ];
}

// Notifier class
class OwnerDashboardNotifier extends Notifier<OwnerDashboardState> {
  late final GetDashboardOverview _getDashboardOverview;
  late final GetOwnerBookings _getOwnerBookings;
  late final UpdateBookingStatus _updateBookingStatus;

  @override
  OwnerDashboardState build() {
    _getDashboardOverview = ref.watch(getDashboardOverviewProvider);
    _getOwnerBookings = ref.watch(getOwnerBookingsProvider);
    _updateBookingStatus = ref.watch(updateBookingStatusProvider);
    return const OwnerDashboardState();
  }

  /// Load dashboard overview for the owner
  Future<void> loadDashboardOverview(String ownerId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getDashboardOverview(ownerId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (dashboard) {
        state = state.copyWith(
          dashboard: dashboard,
          isLoading: false,
        );
      },
    );
  }

  /// Load all bookings for the owner
  Future<void> loadOwnerBookings(String ownerId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getOwnerBookings(ownerId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (bookings) {
        state = state.copyWith(
          bookings: bookings,
          isLoading: false,
        );
      },
    );
  }

  /// Map failure to user-friendly error message
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error: ${failure.message}';
    }
    return 'An unexpected error occurred';
  }


  /// Update the status of a booking
  Future<void> updateBookingStatusForId({
    required String bookingId,
    required BookingStatus status,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _updateBookingStatus(
      bookingId: bookingId,
      status: status.name,
    );
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (_) {

        // Update the bookings list locally by modifying the status of the affected booking
        final updatedBookings = state.bookings.map((booking) {
          if (booking.id == bookingId) {
            // Create a new booking with updated status using copyWith
            return booking.copyWith(
              status: status,
            );
          }
          return booking;
        }).toList();
        state = state.copyWith(
          bookings: updatedBookings,
          isLoading: false,
        );
      },
    );
  }
}
