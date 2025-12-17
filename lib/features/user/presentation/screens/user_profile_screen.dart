import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_providers.dart';
import 'login_screen.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: userState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userState.currentUser == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not logged in', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${userState.currentUser!.fullName}', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Email: ${userState.currentUser!.email ?? 'N/A'}', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 8),

                      Text('Phone: ${userState.currentUser!.phoneNumber}', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      Text('Address: ${userState.currentUser!.deliveryAddress}', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      Text('Role: ${userState.currentUser!.role.name}', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          await ref.read(userNotifierProvider.notifier).logout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out')),
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
    );
  }
}