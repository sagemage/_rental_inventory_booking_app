import 'package:flutter_riverpod/legacy.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/usecases/create_booking.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/usecases/get_bookings_for_user.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/usecases/get_booking_details.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/usecases/get_all_bookings.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/usecases/cancel_booking.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

class BookingState {
  final List<Booking> bookings;
  final Booking? selectedBooking;
  final bool isLoading;
  final String? error;

  // Booking creation/cart fields
  final List<BookingItem> cartItems;
  final DateTime? startDate;
  final DateTime? endDate;

  const BookingState({
    this.bookings = const [],
    this.selectedBooking,
    this.isLoading = false,
    this.error,
    this.cartItems = const [],
    this.startDate,
    this.endDate,
  });

  BookingState copyWith({
    List<Booking>? bookings,
    Booking? selectedBooking,
    bool? isLoading,
    String? error,
    List<BookingItem>? cartItems,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      selectedBooking: selectedBooking ?? this.selectedBooking,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      cartItems: cartItems ?? this.cartItems,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class BookingNotifier extends StateNotifier<BookingState> {
  final CreateBooking createBooking;
  final GetBookingsForUser getBookingsForUser;
  final GetBookingDetails getBookingDetails;
  final GetAllBookings getAllBookings;
  final CancelBooking cancelBooking;

  BookingNotifier({
    required this.createBooking,
    required this.getBookingsForUser,
    required this.getBookingDetails,
    required this.getAllBookings,
    required this.cancelBooking,
  }) : super(const BookingState());

  Future<void> loadBookingsForUser(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await getBookingsForUser.call(userId);
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: _mapFailure(f)),
      (list) => state = state.copyWith(isLoading: false, bookings: list),
    );
  }

  Future<void> loadAllBookings() async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await getAllBookings.call();
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: _mapFailure(f)),
      (list) => state = state.copyWith(isLoading: false, bookings: list),
    );
  }

  Future<void> loadBookingDetails(String bookingId) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await getBookingDetails.call(bookingId);
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: _mapFailure(f)),
      (b) => state = state.copyWith(isLoading: false, selectedBooking: b),
    );
  }

  Future<void> makeBooking({required String userId}) async {
    if (state.startDate == null || state.endDate == null || state.cartItems.isEmpty) {
      state = state.copyWith(error: 'Please select items and dates');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    final res = await createBooking.call(
      userId: userId,
      items: state.cartItems,
      startDate: state.startDate!,
      endDate: state.endDate!,
    );

    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: _mapFailure(f)),
      (b) {
        state = state.copyWith(isLoading: false);
        // clear cart
        state = state.copyWith(cartItems: [], startDate: null, endDate: null);
      },
    );
  }

  Future<void> cancelBookingById(String bookingId) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await cancelBooking.call(bookingId);
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: _mapFailure(f)),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  // CART MANAGEMENT
  void addOrUpdateCartItem(BookingItem item) {
    final existing = state.cartItems.indexWhere((i) => i.itemId == item.itemId);
    final List<BookingItem> newList = List.from(state.cartItems);
    if (existing >= 0) {
      newList[existing] = item;
    } else {
      newList.add(item);
    }
    state = state.copyWith(cartItems: newList);
  }

  void removeCartItem(String itemId) {
    state = state.copyWith(cartItems: state.cartItems.where((i) => i.itemId != itemId).toList());
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  String _mapFailure(Failure f) => f is ServerFailure ? 'Server: ${f.message}' : 'Unexpected error';
}
