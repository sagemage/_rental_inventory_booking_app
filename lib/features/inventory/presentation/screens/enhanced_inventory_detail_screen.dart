import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/seed_service.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../providers/inventory_providers.dart';
import '../../domain/entities/inventory_item.dart';

class InventoryDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const InventoryDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<InventoryDetailScreen> createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends ConsumerState<InventoryDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _startDate;
  DateTime? _endDate;
  int _selectedQuantity = 1;
  final PageController _imagePageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load item details
    Future.microtask(() => ref.read(inventoryNotifierProvider.notifier).loadInventoryItem(widget.id));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      
      // Check availability for selected dates
      _checkAvailability();
    }
  }

  Future<void> _checkAvailability() async {
    if (_startDate == null || _endDate == null) return;

    final notifier = ref.read(inventoryNotifierProvider.notifier);
    final isAvailable = await notifier.checkItemAvailability(
      widget.id,
      _startDate!,
      _endDate!,
      _selectedQuantity,
    );

    if (!isAvailable && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selected quantity is not available for these dates'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  int _calculateTotalDays() {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  double _calculateTotalPrice(InventoryItem item) {
    final days = _calculateTotalDays();
    return item.calculatePriceForDays(days) * _selectedQuantity;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryNotifierProvider);
    final item = state.items.firstWhere(
      (element) => element.id == widget.id,
      orElse: () => throw Exception('Item not found'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : item == null
              ? const Center(child: Text('Item not found'))
              : CustomScrollView(
                  slivers: [
                    // Image Gallery
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _imagePageController,
                              itemCount: item.imageUrls.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  item.imageUrls[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            // Image indicators
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  item.imageUrls.length,
                                  (index) => AnimatedBuilder(
                                    animation: _imagePageController,
                                    builder: (context, child) {
                                      final page = _imagePageController.hasClients
                                          ? _imagePageController.page ?? 0
                                          : 0;
                                      final isSelected = (page.round() == index);
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                        width: isSelected ? 12 : 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Theme.of(context).primaryColor
                                              : Colors.white.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Item Details
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ),
                                if (item.rating > 0) ...[
                                  Icon(Icons.star, color: Colors.amber[600], size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item.rating.toStringAsFixed(1)} (${item.reviewCount})',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '\$${item.pricePerDay.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '/ day',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              item.description,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: item.tags.map((tag) {
                                return Chip(
                                  label: Text(tag),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Specifications Tab
                    SliverToBoxAdapter(
                      child: TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Specifications'),
                          Tab(text: 'Reviews'),
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Specifications Tab
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Product Specifications',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                if (item.specifications.isEmpty)
                                  const Text('No specifications available')
                                else
                                  ...item.specifications.entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            child: Text(
                                              '${entry.key}:',
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(entry.value.toString()),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                              ],
                            ),
                          ),
                          // Reviews Tab
                          const Center(
                            child: Text('Reviews coming soon'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      // Booking Section at Bottom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date Selection
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDateRange,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_startDate != null && _endDate != null
                        ? '${_startDate!.day}/${_startDate!.month} - ${_endDate!.day}/${_endDate!.month}'
                        : 'Select Dates'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                    initialValue: '1',
                    onChanged: (value) {
                      final qty = int.tryParse(value) ?? 1;
                      setState(() {
                        _selectedQuantity = qty;
                      });
                      _checkAvailability();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price Summary
            if (_startDate != null && _endDate != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_selectedQuantity × ${_calculateTotalDays()} day${_calculateTotalDays() > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '\$${_calculateTotalPrice(item).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Book Now Button
            ElevatedButton.icon(
              onPressed: (_startDate != null && _endDate != null && item.isAvailable)
                  ? () {
                      context.go(
                        '/booking/item/${item.id}?startDate=${_startDate!.toIso8601String()}&endDate=${_endDate!.toIso8601String()}&quantity=$_selectedQuantity',
                      );
                    }
                  : null,
              icon: const Icon(Icons.shopping_cart),
              label: Text(
                item.isAvailable ? 'Book Now' : 'Not Available',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            // Availability Info
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.isAvailable ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: item.isAvailable ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  item.isAvailable
                      ? '${item.quantityAvailable} available'
                      : 'Currently unavailable',
                  style: TextStyle(
                    fontSize: 12,
                    color: item.isAvailable ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

