import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/inventory_notifier.dart';
import '../providers/inventory_providers.dart';

class InventoryListScreen extends ConsumerStatefulWidget {
  const InventoryListScreen({super.key});

  @override
  ConsumerState<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends ConsumerState<InventoryListScreen> {
  @override
  void initState() {
    super.initState();
    // Load list on first build
    Future.microtask(() => ref.read(inventoryNotifierProvider.notifier).loadInventoryList());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Inventory', style: Theme.of(context).textTheme.headlineLarge)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.items.isEmpty
                ? Center(child: Text('No items found', style: Theme.of(context).textTheme.bodyLarge))
                : ListView.separated(
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        leading: SizedBox(
                          width: 64,
                          height: 64,
                          child: item.imageUrl.isNotEmpty
                              ? Image.network(item.imageUrl, fit: BoxFit.cover)
                              : Container(color: Colors.grey[300]),
                        ),
                        title: Text(item.name, style: Theme.of(context).textTheme.titleLarge),
                        subtitle: Text('\$${item.pricePerDay.toStringAsFixed(2)} / day', style: Theme.of(context).textTheme.bodyMedium),
                        trailing: Text('Stock: ${item.quantityAvailable}', style: Theme.of(context).textTheme.labelMedium),
                        onTap: () => context.go('/inventory/${item.id}'),
                      );
                    },
                  ),
      ),
    );
  }
}
