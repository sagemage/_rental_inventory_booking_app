import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Hide the default AppBar if the shell has one
        child: SizedBox.shrink(),
      ),
      body: Center(
        child: Text(
          'User Profile Screen: To Be Implemented', // Confirmation Text
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}