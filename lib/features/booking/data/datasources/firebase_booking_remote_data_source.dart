import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking_remote_data_source.dart';
import '../models/booking_model.dart';

class FirebaseBookingRemoteDataSource implements BookingRemoteDataSource {
  final FirebaseFirestore firestore;
  final CollectionReference bookingsCollection;

  FirebaseBookingRemoteDataSource({FirebaseFirestore? firestoreInstance})
      : firestore = firestoreInstance ?? FirebaseFirestore.instance,
        bookingsCollection = (firestoreInstance ?? FirebaseFirestore.instance).collection('bookings');

  @override
  Future<BookingModel> createBooking({required String userId, required List<BookingItemModel> items, required DateTime startDate, required DateTime endDate}) async {
    final data = {
      'userId': userId,
      'items': items.map((e) => e.toMap()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': 'pending',
    };

    final docRef = await bookingsCollection.add(data);
    final snapshot = await docRef.get();
    return BookingModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await bookingsCollection.doc(bookingId).update({'status': 'cancelled'});
  }

  @override
  Future<List<BookingModel>> getAllBookings() async {
    final snapshot = await bookingsCollection.get();
    return snapshot.docs.map((d) => BookingModel.fromMap(d.data() as Map<String, dynamic>, d.id)).toList();
  }

  @override
  Future<BookingModel> getBookingDetails(String bookingId) async {
    final doc = await bookingsCollection.doc(bookingId).get();
    if (!doc.exists) throw Exception('Booking not found');
    return BookingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  @override
  Future<List<BookingModel>> getBookingsForUser(String userId) async {
    final query = await bookingsCollection.where('userId', isEqualTo: userId).get();
    return query.docs.map((d) => BookingModel.fromMap(d.data() as Map<String, dynamic>, d.id)).toList();
  }
}
