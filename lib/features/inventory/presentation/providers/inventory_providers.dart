import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/inventory_remote_data_source_impl.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/usecases/get_inventory_list.dart';
import '../state/inventory_notifier.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final inventoryRemoteDataSourceProvider = Provider<FirebaseInventoryRemoteDataSource>((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return FirebaseInventoryRemoteDataSource(firestore: firestore);
});

final inventoryRepositoryProvider = Provider<InventoryRepositoryImpl>((ref) {
  final remote = ref.read(inventoryRemoteDataSourceProvider);
  return InventoryRepositoryImpl(remoteDataSource: remote);
});

final getInventoryListProvider = Provider<GetInventoryList>((ref) {
  final repo = ref.read(inventoryRepositoryProvider);
  return GetInventoryList(repo);
});

final inventoryNotifierProvider = StateNotifierProvider<InventoryNotifier, InventoryState>((ref) {
  final getList = ref.read(getInventoryListProvider);
  return InventoryNotifier(getInventoryList: getList);
});
