
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_inventory_booking_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:rental_inventory_booking_app/features/inventory/domain/usecases/get_inventory_list.dart';
import 'package:rental_inventory_booking_app/features/inventory/domain/usecases/get_inventory_item_details.dart';
import 'package:rental_inventory_booking_app/features/inventory/domain/usecases/check_availability.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import '../providers/inventory_providers.dart';

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

/// Notifier that holds the use cases as attributes.
class InventoryNotifier extends Notifier<InventoryState> {
  late final GetInventoryList _getInventoryList;
  late final GetInventoryItemDetails _getInventoryItemDetails;
  late final CheckAvailability _checkAvailability;

  @override
  InventoryState build() {
    _getInventoryList = ref.watch(getInventoryListProvider);
    _getInventoryItemDetails = ref.watch(getInventoryItemDetailsProvider);
    _checkAvailability = ref.watch(checkAvailabilityProvider);
    return const InventoryState();
  }

  Future<void> loadInventoryList() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getInventoryList.call();

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: _mapFailureToMessage(failure)),
      (items) => state = state.copyWith(isLoading: false, items: items),
    );
  }

  Future<void> loadInventoryItem(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getInventoryItemDetails.call(id);

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: _mapFailureToMessage(failure)),
      (item) => state = state.copyWith(isLoading: false, selectedItem: item, items: [...state.items, item]),
    );
  }

  Future<void> loadInventoryItemDetails(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getInventoryItemDetails.call(id);

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: _mapFailureToMessage(failure)),
      (item) => state = state.copyWith(isLoading: false, selectedItem: item, items: [...state.items, item]),
    );
  }

  Future<bool> checkItemAvailability(String itemId, DateTime startDate, DateTime endDate, int quantity) async {
    final result = await _checkAvailability.call(
      CheckAvailabilityParams(
        itemId: itemId,
        startDate: startDate,
        endDate: endDate,
        quantity: quantity,
      ),
    );

    return result.fold(
      (failure) => false, // Return false on failure
      (isAvailable) => isAvailable,
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure is ServerFailure ? 'Server error: ${failure.message}' : 'Unexpected error';
  }
}
