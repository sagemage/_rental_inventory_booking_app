import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/seed_service.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../providers/inventory_providers.dart';

class InventoryListScreen extends ConsumerStatefulWidget {
  const InventoryListScreen({super.key});

  @override
  ConsumerState<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends ConsumerState<InventoryListScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Load list on first build
    Future.microtask(() => ref.read(inventoryNotifierProvider.notifier).loadInventoryList());
  }

  Future<void> _seedData() async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final auth = ref.read(firebaseAuthProvider);
    final seedService = SeedService(firestore: firestore, auth: auth);

    try {
      await seedService.seedUsers();
      await seedService.seedInventory();
      // Reload inventory after seeding
      ref.read(inventoryNotifierProvider.notifier).loadInventoryList();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data seeded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Seeding failed: $e')),
        );
      }
    }
  }

  List<String> _getCategories(List items) {
    final categories = items.map((item) => item.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  List _getFilteredItems(List items) {
    if (_selectedCategory == 'All') return items;
    return items.where((item) => item.category == _selectedCategory).toList();
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
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No items found', style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _seedData,
                          child: const Text('Seed Sample Data'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      // Category tabs
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _getCategories(state.items).map((category) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: FilterChip(
                                label: Text(category),
                                selected: _selectedCategory == category,
                                onSelected: (selected) {
                                  setState(() => _selectedCategory = category);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _getFilteredItems(state.items).length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = _getFilteredItems(state.items)[index];
                            return ListTile(

                              leading: SizedBox(
                                width: 64,
                                height: 64,
                                child: item.primaryImage.isNotEmpty
                                    ? Image.network(item.primaryImage, fit: BoxFit.cover)
                                    : Container(color: Colors.grey[300]),
                              ),
                              title: Text(item.name, style: Theme.of(context).textTheme.titleLarge),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('\$${item.pricePerDay.toStringAsFixed(2)} / day', style: Theme.of(context).textTheme.bodyMedium),
                                  Text('Category: ${item.category}', style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                              trailing: Text('Stock: ${item.quantityAvailable}', style: Theme.of(context).textTheme.labelMedium),
                              onTap: () => context.go('/inventory/details/${item.id}'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: state.items.isNotEmpty
          ? FloatingActionButton(
              onPressed: _seedData,
              tooltip: 'Seed More Data',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
