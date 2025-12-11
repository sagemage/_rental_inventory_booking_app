import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationBarWidget extends StatelessWidget { 
  const BottomNavigationBarWidget({super.key, required this.selectedIndex});

  final int selectedIndex;

  void _onItemTapped(BuildContext context, int index) {
    const destinations = ['/inventory', '/booking', '/profile', '/owner']; 
    
    
    final currentPath = ModalRoute.of(context)?.settings.name; 
    if (currentPath != null && currentPath != destinations[index]) {
      context.go(destinations[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem( // The Owner Dashboard item
          icon: Icon(Icons.dashboard),
          label: 'Owner',
        ),
      ],
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed, 
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}