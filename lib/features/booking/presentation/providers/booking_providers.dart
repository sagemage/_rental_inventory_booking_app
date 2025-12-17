import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_inventory_booking_app/core/providers/firebase_providers.dart';

import '../../data/datasources/firebase_booking_remote_data_source.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/usecases/create_booking.dart';
import '../../domain/usecases/get_bookings_for_user.dart';
import '../../domain/usecases/get_booking_details.dart';
import '../../domain/usecases/get_all_bookings.dart';
import '../../domain/usecases/cancel_booking.dart';
import '../state/booking_notifier.dart';

final bookingRemoteDataSourceProvider = Provider<FirebaseBookingRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return FirebaseBookingRemoteDataSource(firestoreInstance: firestore);
});

final bookingRepositoryProvider = Provider<BookingRepositoryImpl>((ref) {
  final remote = ref.watch(bookingRemoteDataSourceProvider);
  return BookingRepositoryImpl(remoteDataSource: remote);
});

final createBookingProvider = Provider<CreateBooking>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return CreateBooking(repo);
});

final getBookingsForUserProvider = Provider<GetBookingsForUser>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return GetBookingsForUser(repo);
});

final getBookingDetailsProvider = Provider<GetBookingDetails>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return GetBookingDetails(repo);
});

final getAllBookingsProvider = Provider<GetAllBookings>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return GetAllBookings(repo);
});

final cancelBookingProvider = Provider<CancelBooking>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return CancelBooking(repo);
});

final bookingNotifierProvider = NotifierProvider<BookingNotifier, BookingState>(() {
  return BookingNotifier();
});

