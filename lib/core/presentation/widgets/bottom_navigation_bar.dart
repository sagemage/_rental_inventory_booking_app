import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap; // <--- 1. NEW REQUIRED PARAMETER

  const BottomNavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap, // <--- 2. Add to constructor
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap, // <--- 3. Pass the function to the internal widget

      // The colors are correctly pulled from theme.dart now
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_online),
          label: 'Booking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Owner',
        ),
      ],
    );
  }
}