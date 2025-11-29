import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/inventory_remote_data_source_impl.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/usecases/get_inventory_list.dart';
import '../../domain/usecases/get_inventory_item_details.dart';
import '../state/inventory_notifier.dart';

/// Firebase instance provider (injected as the root datasource dependency)
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Remote data source provider

import '../../data/datasources/inventory_remote_data_source_impl.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/usecases/get_inventory_list.dart';
import '../state/inventory_notifier.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final inventoryRemoteDataSourceProvider = Provider<FirebaseInventoryRemoteDataSource>((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return FirebaseInventoryRemoteDataSource(firestore: firestore);
});

/// Repository provider
final inventoryRepositoryProvider = Provider<InventoryRepositoryImpl>((ref) {
  final remote = ref.read(inventoryRemoteDataSourceProvider);
  return InventoryRepositoryImpl(remoteDataSource: remote);
});

/// Use case providers
final getInventoryListProvider = Provider<GetInventoryList>((ref) {
  final repo = ref.read(inventoryRepositoryProvider);
  return GetInventoryList(repo);
});

final getInventoryItemDetailsProvider = Provider<GetInventoryItemDetails>((ref) {
  final repo = ref.read(inventoryRepositoryProvider);
  return GetInventoryItemDetails(repo);
});

/// StateNotifier provider (presentation layer)
final inventoryNotifierProvider = StateNotifierProvider<InventoryNotifier, InventoryState>((ref) {
  final getList = ref.read(getInventoryListProvider);
  final getDetails = ref.read(getInventoryItemDetailsProvider);
  return InventoryNotifier(getInventoryList: getList, getInventoryItemDetails: getDetails);
final inventoryNotifierProvider = StateNotifierProvider<InventoryNotifier, InventoryState>((ref) {
  final getList = ref.read(getInventoryListProvider);
  return InventoryNotifier(getInventoryList: getList);
});
