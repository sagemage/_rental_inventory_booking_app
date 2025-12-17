import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/usecases/create_booking.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/usecases/get_bookings_for_user.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/usecases/get_booking_details.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/usecases/get_all_bookings.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/usecases/cancel_booking.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import '../providers/booking_providers.dart';

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

class BookingNotifier extends Notifier<BookingState> {
  late final CreateBooking _createBooking;
  late final GetBookingsForUser _getBookingsForUser;
  late final GetBookingDetails _getBookingDetails;
  late final GetAllBookings _getAllBookings;
  late final CancelBooking _cancelBooking;

  @override
  BookingState build() {
    _createBooking = ref.watch(createBookingProvider);
    _getBookingsForUser = ref.watch(getBookingsForUserProvider);
    _getBookingDetails = ref.watch(getBookingDetailsProvider);
    _getAllBookings = ref.watch(getAllBookingsProvider);
    _cancelBooking = ref.watch(cancelBookingProvider);
    return const BookingState();
  }

  // Public methods for external access
  Future<void> getBookingsForUser(String userId) => loadBookingsForUser(userId);
  Future<void> cancelBooking(String bookingId) => cancelBookingById(bookingId);

  Future<void> loadBookingsForUser(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getBookingsForUser.call(userId);
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: _mapFailureToMessage(failure),
      ),
      (bookings) => state = state.copyWith(
        isLoading: false,
        bookings: bookings,
      ),
    );
  }

  Future<void> loadAllBookings() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getAllBookings.call();
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: _mapFailureToMessage(failure),
      ),
      (bookings) => state = state.copyWith(
        isLoading: false,
        bookings: bookings,
      ),
    );
  }

  Future<void> loadBookingDetails(String bookingId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getBookingDetails.call(bookingId);
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: _mapFailureToMessage(failure),
      ),
      (booking) => state = state.copyWith(
        isLoading: false,
        selectedBooking: booking,
      ),
    );
  }

  Future<void> makeBooking({
    required String userId,
    required String clientName,
    required String clientPhone,
    String? clientEmail,
    required String deliveryAddress,
    required BookingType eventType,
    String? eventNotes,
    String? deliveryInstructions,
    required String ownerId,
  }) async {
    if (state.startDate == null || state.endDate == null || state.cartItems.isEmpty) {
      state = state.copyWith(error: 'Please select items and dates');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _createBooking.createFromParams(
      clientId: userId,
      clientName: clientName,
      clientPhone: clientPhone,
      clientEmail: clientEmail,
      deliveryAddress: deliveryAddress,
      items: state.cartItems,
      startDate: state.startDate!,
      endDate: state.endDate!,
      eventType: eventType,
      eventNotes: eventNotes,
      deliveryInstructions: deliveryInstructions,
      ownerId: ownerId,
    );
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: _mapFailureToMessage(failure),
      ),
      (booking) => state = state.copyWith(
        isLoading: false,
        selectedBooking: booking,
        // clear cart after successful booking
        cartItems: [],
        startDate: null,
        endDate: null,
      ),
    );
  }

  Future<void> makeBookingForItem({
    required String userId,
    required String clientName,
    required String clientPhone,
    String? clientEmail,
    required String deliveryAddress,
    required String inventoryId,
    required DateTime startDate,
    required DateTime endDate,
    required int quantity,
    required String name,
    required double dailyRate,
    required BookingType eventType,
    String? eventNotes,
    String? deliveryInstructions,
    required String ownerId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    // Create BookingItem with correct constructor
    final bookingItem = BookingItem(
      inventoryId: inventoryId,
      name: name,
      dailyRate: dailyRate,
      quantity: quantity,
      reservedQuantity: quantity,
    );
    
    final result = await _createBooking.createFromParams(
      clientId: userId,
      clientName: clientName,
      clientPhone: clientPhone,
      clientEmail: clientEmail,
      deliveryAddress: deliveryAddress,
      items: [bookingItem],
      startDate: startDate,
      endDate: endDate,
      eventType: eventType,
      eventNotes: eventNotes,
      deliveryInstructions: deliveryInstructions,
      ownerId: ownerId,
    );
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: _mapFailureToMessage(failure),
      ),
      (booking) => state = state.copyWith(
        isLoading: false,
        selectedBooking: booking,
      ),
    );
  }

  Future<void> cancelBookingById(String bookingId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _cancelBooking.call(bookingId);
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: _mapFailureToMessage(failure),
      ),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  // CART MANAGEMENT
  void addOrUpdateCartItem(BookingItem item) {
    final existing = state.cartItems.indexWhere((i) => i.inventoryId == item.inventoryId);
    final List<BookingItem> newList = List.from(state.cartItems);
    if (existing >= 0) {
      newList[existing] = item;
    } else {
      newList.add(item);
    }
    state = state.copyWith(cartItems: newList);
  }

  void removeCartItem(String inventoryId) {
    state = state.copyWith(
      cartItems: state.cartItems.where((i) => i.inventoryId != inventoryId).toList(),
    );
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  String _mapFailureToMessage(Failure failure) {
    return failure is ServerFailure ? 'Server error: ${failure.message}' : 'Unexpected error';
  }
}

