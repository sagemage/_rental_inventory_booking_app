import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/inventory_providers.dart';

class OwnerInventoryManageScreen extends ConsumerStatefulWidget {
  const OwnerInventoryManageScreen({super.key});

  @override
  ConsumerState<OwnerInventoryManageScreen> createState() => _OwnerInventoryManageScreenState();
}

class _OwnerInventoryManageScreenState extends ConsumerState<OwnerInventoryManageScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(inventoryNotifierProvider.notifier).loadInventoryList());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Manage Inventory', style: Theme.of(context).textTheme.headlineLarge)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For simplicity navigate to edit with id 'new'
          context.go('/owner/inventory/edit/new');
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: state.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return ListTile(
                    leading: SizedBox(width: 64, height: 64, child: item.imageUrl.isNotEmpty ? Image.network(item.imageUrl) : Container()),
                    title: Text(item.name, style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text('Stock: ${item.quantityAvailable} · \$${item.pricePerDay.toStringAsFixed(2)}/day', style: Theme.of(context).textTheme.bodyMedium),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => context.go('/owner/inventory/edit/${item.id}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delete not implemented')));
                        },
                      ),
                    ]),
                  );
                },
              ),
      ),
    );
  }
}
