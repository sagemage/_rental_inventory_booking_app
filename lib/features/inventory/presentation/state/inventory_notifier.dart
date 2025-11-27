import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_inventory_booking_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:rental_inventory_booking_app/features/inventory/domain/usecases/get_inventory_list.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

class InventoryState {
  final List<InventoryItem> items;
  final InventoryItem? selectedItem;
  final bool isLoading;
  final String? error;

  const InventoryState({this.items = const [], this.selectedItem, this.isLoading = false, this.error});

  InventoryState copyWith({List<InventoryItem>? items, InventoryItem? selectedItem, bool? isLoading, String? error}) {
    return InventoryState(
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class InventoryNotifier extends StateNotifier<InventoryState> {
  final GetInventoryList getInventoryList;

  InventoryNotifier({required this.getInventoryList}) : super(const InventoryState());

  Future<void> loadInventoryList() async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await getInventoryList.call();
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: (f as ServerFailure).message),
      (list) => state = state.copyWith(isLoading: false, items: list),
    );
  }
}
