import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/inventory_remote_data_source_impl.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/usecases/get_inventory_list.dart';
import '../../domain/usecases/get_inventory_item_details.dart';
import '../../domain/usecases/check_availability.dart';
import '../state/inventory_notifier.dart';
import 'package:rental_inventory_booking_app/core/providers/firebase_providers.dart';

/// Remote data source provider
final inventoryRemoteDataSourceProvider = Provider<FirebaseInventoryRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return FirebaseInventoryRemoteDataSource(firestore: firestore);
});

/// Repository provider
final inventoryRepositoryProvider = Provider<InventoryRepositoryImpl>((ref) {
  final remote = ref.watch(inventoryRemoteDataSourceProvider);
  return InventoryRepositoryImpl(remoteDataSource: remote);
});

/// Use case providers
final getInventoryListProvider = Provider<GetInventoryList>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return GetInventoryList(repo);
});

final getInventoryItemDetailsProvider = Provider<GetInventoryItemDetails>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return GetInventoryItemDetails(repo);
});

final checkAvailabilityProvider = Provider<CheckAvailability>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return CheckAvailability(repo);
});

/// StateNotifier provider (presentation layer)
final inventoryNotifierProvider = NotifierProvider<InventoryNotifier, InventoryState>(() {
  return InventoryNotifier();
});
