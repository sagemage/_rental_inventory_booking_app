import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../state/owner_dashboard_notifier.dart';
import '../../data/datasources/owner_dashboard_remote_data_source.dart';
import '../../data/datasources/owner_dashboard_remote_data_source_impl.dart';
import '../../data/repositories/owner_dashboard_repository_impl.dart';
import '../../domain/repositories/owner_dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_overview.dart';
import '../../domain/usecases/get_owner_bookings.dart';
import '../../domain/usecases/update_booking_status.dart';

// Firebase Firestore instance provider
final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

// Remote data source provider
final ownerDashboardRemoteDataSourceProvider = Provider<OwnerDashboardRemoteDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return OwnerDashboardRemoteDataSourceImpl(firestore: firestore);
});

// Repository provider
final ownerDashboardRepositoryProvider = Provider<OwnerDashboardRepository>((ref) {
  final remoteDataSource = ref.watch(ownerDashboardRemoteDataSourceProvider);
  return OwnerDashboardRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Use case providers
final getDashboardOverviewProvider = Provider((ref) {
  final repository = ref.watch(ownerDashboardRepositoryProvider);
  return GetDashboardOverview(repository);
});

final getOwnerBookingsProvider = Provider((ref) {
  final repository = ref.watch(ownerDashboardRepositoryProvider);
  return GetOwnerBookings(repository);
});

final updateBookingStatusProvider = Provider((ref) {
  final repository = ref.watch(ownerDashboardRepositoryProvider);
  return UpdateBookingStatus(repository);
});

// State notifier provider
final ownerDashboardNotifierProvider = StateNotifierProvider<OwnerDashboardNotifier, OwnerDashboardState>((ref) {
  final getDashboardOverview = ref.watch(getDashboardOverviewProvider);
  final getOwnerBookings = ref.watch(getOwnerBookingsProvider);
  final updateBookingStatus = ref.watch(updateBookingStatusProvider);

  return OwnerDashboardNotifier(
    getDashboardOverview: getDashboardOverview,
    getOwnerBookings: getOwnerBookings,
    updateBookingStatus: updateBookingStatus,
  );
});
