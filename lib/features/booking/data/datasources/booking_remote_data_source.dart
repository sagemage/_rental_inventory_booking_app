
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking(Booking booking);

  Future<List<BookingModel>> getBookingsForUser(String userId);

  Future<List<BookingModel>> getBookingsForOwner(String ownerId);

  Future<BookingModel> getBookingDetails(String bookingId);

  Future<List<BookingModel>> getAllBookings();

  Future<void> updateBookingStatus(String bookingId, BookingStatus status);

  Future<void> cancelBooking(String bookingId, {String? reason});

  Future<void> updatePaymentStatus(String bookingId, PaymentStatus status, {double? amount, DateTime? paymentDate});

  Future<List<BookingModel>> getTodayBookings(String ownerId);

  Future<List<BookingModel>> getUpcomingBookings(String ownerId, {int days = 7});
}
