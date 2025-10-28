import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking({
    required String userId,
    required List<BookingItemModel> items,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<BookingModel>> getBookingsForUser(String userId);

  Future<BookingModel> getBookingDetails(String bookingId);

  Future<List<BookingModel>> getAllBookings();

  Future<void> cancelBooking(String bookingId);
}
