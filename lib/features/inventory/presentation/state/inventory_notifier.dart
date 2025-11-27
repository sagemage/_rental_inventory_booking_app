import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_inventory_booking_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:rental_inventory_booking_app/features/inventory/domain/usecases/get_inventory_list.dart';
import 'package:rental_inventory_booking_app/features/inventory/domain/usecases/get_inventory_item_details.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';

/// Presentation state for the Inventory feature.
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
      error: error,
    );
  }
}

/// StateNotifier that holds the use cases as attributes.
class InventoryNotifier extends StateNotifier<InventoryState> {
  final GetInventoryList getInventoryList;
  final GetInventoryItemDetails getInventoryItemDetails;

  InventoryNotifier({required this.getInventoryList, required this.getInventoryItemDetails}) : super(const InventoryState());

  /// Loads the full inventory list and updates state accordingly.
  Future<void> loadInventoryList() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getInventoryList.call();

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: _mapFailureToMessage(failure)),
      (items) => state = state.copyWith(isLoading: false, items: items),
    );
  }

  /// Loads details for a single inventory item and stores it as `selectedItem`.
  Future<void> loadInventoryItemDetails(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getInventoryItemDetails.call(id);

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: _mapFailureToMessage(failure)),
      (item) => state = state.copyWith(isLoading: false, selectedItem: item),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure is ServerFailure ? 'Server error: ${failure.message}' : 'Unexpected error';
  }
}
