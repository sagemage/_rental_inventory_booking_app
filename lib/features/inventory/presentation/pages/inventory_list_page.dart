import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InventoryListPage extends StatelessWidget {
  const InventoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory List')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Inventory List Page Placeholder'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Example navigation to the details screen
                context.go('/inventory/details/ITEM_123');
              },
              child: const Text('View Item Details'),
            ),
          ],
        ),
      ),
    );
  }
}