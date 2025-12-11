import 'package:flutter/material.dart';

class InventoryDetailsScreen extends StatelessWidget {
  final String itemId;
  const InventoryDetailsScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details: $itemId')),
      body: Center(child: Text('Viewing details for Inventory Item ID: $itemId')),
    );
  }
}