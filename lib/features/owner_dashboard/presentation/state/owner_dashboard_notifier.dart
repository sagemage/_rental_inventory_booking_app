import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/owner_dashboard.dart';
import '../../domain/usecases/get_dashboard_overview.dart';
import '../../domain/usecases/get_owner_bookings.dart';
import '../../domain/usecases/update_booking_status.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

// State class
class OwnerDashboardState extends Equatable {
  final OwnerDashboard? dashboard;
  final List<Booking> bookings;
  final bool isLoading;
  final String? errorMessage;

  const OwnerDashboardState({
    this.dashboard,
    this.bookings = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  OwnerDashboardState copyWith({
    OwnerDashboard? dashboard,
    List<Booking>? bookings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OwnerDashboardState(
      dashboard: dashboard ?? this.dashboard,
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [dashboard, bookings, isLoading, errorMessage];
}

// Notifier class
class OwnerDashboardNotifier extends StateNotifier<OwnerDashboardState> {
  final GetDashboardOverview getDashboardOverview;
  final GetOwnerBookings getOwnerBookings;
  final UpdateBookingStatus updateBookingStatus;

  OwnerDashboardNotifier({
    required this.getDashboardOverview,
    required this.getOwnerBookings,
    required this.updateBookingStatus,
  }) : super(const OwnerDashboardState());

  /// Load dashboard overview for the owner
  Future<void> loadDashboardOverview(String ownerId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await getDashboardOverview(ownerId);
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
    final result = await getOwnerBookings(ownerId);
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
    required String status,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await updateBookingStatus(
      bookingId: bookingId,
      status: status,
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
            // Create a new booking with updated status
            // Note: Booking is immutable, so we need to reconstruct it
            return Booking(
              id: booking.id,
              userId: booking.userId,
              items: booking.items,
              startDate: booking.startDate,
              endDate: booking.endDate,
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
