
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_inventory_booking_app/features/booking/domain/entities/booking.dart';
import 'booking_remote_data_source.dart';
import '../models/booking_model.dart';

class FirebaseBookingRemoteDataSource implements BookingRemoteDataSource {
  final FirebaseFirestore firestore;
  final CollectionReference bookingsCollection;

  FirebaseBookingRemoteDataSource({FirebaseFirestore? firestoreInstance})
      : firestore = firestoreInstance ?? FirebaseFirestore.instance,
        bookingsCollection = (firestoreInstance ?? FirebaseFirestore.instance).collection('bookings');

  @override
  Future<BookingModel> createBooking(Booking booking) async {
    final data = {
      'clientId': booking.clientId,
      'clientName': booking.clientName,
      'clientPhone': booking.clientPhone,
      'clientEmail': booking.clientEmail,
      'deliveryAddress': booking.deliveryAddress,
      'items': booking.items.map((e) => (e as BookingItemModel).toMap()).toList(),
      'startDate': Timestamp.fromDate(booking.startDate),
      'endDate': Timestamp.fromDate(booking.endDate),
      'eventTime': booking.eventTime != null ? Timestamp.fromDate(booking.eventTime!) : null,
      'eventType': booking.eventType.name,
      'eventNotes': booking.eventNotes,
      'deliveryInstructions': booking.deliveryInstructions,
      'status': booking.status.name,
      'paymentStatus': booking.paymentStatus.name,
      'totalAmount': booking.totalAmount,
      'partialPayment': booking.partialPayment,
      'finalPayment': booking.finalPayment,
      'partialPaymentDate': booking.partialPaymentDate != null ? Timestamp.fromDate(booking.partialPaymentDate!) : null,
      'finalPaymentDate': booking.finalPaymentDate != null ? Timestamp.fromDate(booking.finalPaymentDate!) : null,
      'damageFee': booking.damageFee,
      'cancellationReason': booking.cancellationReason,
      'createdAt': Timestamp.fromDate(booking.createdAt),
      'updatedAt': booking.updatedAt != null ? Timestamp.fromDate(booking.updatedAt!) : null,
      'ownerId': booking.ownerId,
    };

    final docRef = await bookingsCollection.add(data);
    final snapshot = await docRef.get();
    return BookingModel.fromFirestore(snapshot);
  }

  @override
  Future<List<BookingModel>> getBookingsForUser(String userId) async {
    final query = await bookingsCollection.where('clientId', isEqualTo: userId).get();
    return query.docs.map((d) => BookingModel.fromFirestore(d)).toList();
  }

  @override
  Future<List<BookingModel>> getBookingsForOwner(String ownerId) async {
    final query = await bookingsCollection.where('ownerId', isEqualTo: ownerId).get();
    return query.docs.map((d) => BookingModel.fromFirestore(d)).toList();
  }

  @override
  Future<BookingModel> getBookingDetails(String bookingId) async {
    final doc = await bookingsCollection.doc(bookingId).get();
    if (!doc.exists) throw Exception('Booking not found');
    return BookingModel.fromFirestore(doc);
  }

  @override
  Future<List<BookingModel>> getAllBookings() async {
    final snapshot = await bookingsCollection.get();
    return snapshot.docs.map((d) => BookingModel.fromFirestore(d)).toList();
  }

  @override
  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    await bookingsCollection.doc(bookingId).update({
      'status': status.name,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }


  @override
  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    await bookingsCollection.doc(bookingId).update({
      'status': BookingStatus.cancelled.name,
      'cancellationReason': reason,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  @override
  Future<void> updatePaymentStatus(String bookingId, PaymentStatus status, {double? amount, DateTime? paymentDate}) async {
    final updateData = {
      'paymentStatus': status.name,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (amount != null) {
      if (status == PaymentStatus.partial) {
        updateData['partialPayment'] = amount;
        updateData['partialPaymentDate'] = Timestamp.fromDate(paymentDate ?? DateTime.now());
      } else if (status == PaymentStatus.paid) {
        updateData['finalPayment'] = amount;
        updateData['finalPaymentDate'] = Timestamp.fromDate(paymentDate ?? DateTime.now());
      }
    }

    await bookingsCollection.doc(bookingId).update(updateData);
  }

  @override
  Future<List<BookingModel>> getTodayBookings(String ownerId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = await bookingsCollection
        .where('ownerId', isEqualTo: ownerId)
        .where('startDate', isLessThan: Timestamp.fromDate(endOfDay))
        .where('endDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .get();

    return query.docs.map((d) => BookingModel.fromFirestore(d)).toList();
  }

  @override
  Future<List<BookingModel>> getUpcomingBookings(String ownerId, {int days = 7}) async {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));

    final query = await bookingsCollection
        .where('ownerId', isEqualTo: ownerId)
        .where('startDate', isGreaterThan: Timestamp.fromDate(now))
        .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    return query.docs.map((d) => BookingModel.fromFirestore(d)).toList();
  }
}
