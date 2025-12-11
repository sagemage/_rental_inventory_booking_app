import 'package:flutter/material.dart';
// CORRECTED IMPORT: Using the correct file name 'bottom_navigation_bar.dart'
import 'package:rental_inventory_booking_app/core/presentation/widgets/bottom_navigation_bar.dart'; 

class ShellScreen extends StatelessWidget {
  const ShellScreen({
    super.key,
    required this.child,
  });

  final Widget child; 

  int _calculateSelectedIndex(BuildContext context) {
    final location = ModalRoute.of(context)?.settings.name;

    // Check if the location is valid before calling startsWith
    if (location != null) {
      if (location.startsWith('/inventory')) {
        return 0;
      }
      if (location.startsWith('/booking')) {
        return 1;
      }
      if (location.startsWith('/profile')) {
        return 2;
      }
      if (location.startsWith('/owner')) {
        return 3;
      }
    }
    return 0; // Default to the first tab (Inventory)
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child, 

      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: selectedIndex,
      ),
    );
  }
}