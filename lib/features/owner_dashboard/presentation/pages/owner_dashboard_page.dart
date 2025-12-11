import 'package:flutter/material.dart';

class OwnerDashboardPage extends StatelessWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Owner Dashboard Placeholder',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Analytics and Management Tools will go here.')
          ],
        ),
      ),
    );
  }
}