import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/firebase_booking_remote_data_source.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/usecases/create_booking.dart';
import '../../domain/usecases/get_bookings_for_user.dart';
import '../../domain/usecases/get_booking_details.dart';
import '../../domain/usecases/get_all_bookings.dart';
import '../../domain/usecases/cancel_booking.dart';
import '../state/booking_notifier.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final bookingRemoteDataSourceProvider = Provider<FirebaseBookingRemoteDataSource>((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return FirebaseBookingRemoteDataSource(firestoreInstance: firestore);
});

final bookingRepositoryProvider = Provider<BookingRepositoryImpl>((ref) {
  final remote = ref.read(bookingRemoteDataSourceProvider);
  return BookingRepositoryImpl(remoteDataSource: remote);
});

final createBookingProvider = Provider<CreateBooking>((ref) {
  final repo = ref.read(bookingRepositoryProvider);
  return CreateBooking(repo);
});

final getBookingsForUserProvider = Provider<GetBookingsForUser>((ref) {
  final repo = ref.read(bookingRepositoryProvider);
  return GetBookingsForUser(repo);
});

final getBookingDetailsProvider = Provider<GetBookingDetails>((ref) {
  final repo = ref.read(bookingRepositoryProvider);
  return GetBookingDetails(repo);
});

final getAllBookingsProvider = Provider<GetAllBookings>((ref) {
  final repo = ref.read(bookingRepositoryProvider);
  return GetAllBookings(repo);
});

final cancelBookingProvider = Provider<CancelBooking>((ref) {
  final repo = ref.read(bookingRepositoryProvider);
  return CancelBooking(repo);
});

final bookingNotifierProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  final create = ref.read(createBookingProvider);
  final getForUser = ref.read(getBookingsForUserProvider);
  final getDetails = ref.read(getBookingDetailsProvider);
  final getAll = ref.read(getAllBookingsProvider);
  final cancel = ref.read(cancelBookingProvider);

  return BookingNotifier(
    createBooking: create,
    getBookingsForUser: getForUser,
    getBookingDetails: getDetails,
    getAllBookings: getAll,
    cancelBooking: cancel,
  );
});
