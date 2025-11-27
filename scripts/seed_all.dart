import 'dart:async';

import 'seed_users.dart' as users;
import 'seed_inventory.dart' as inventory;
import 'seed_bookings.dart' as bookings;

Future<void> main(List<String> args) async {
  print('Running all seeders in sequence...');

  try {
    print('\n=== Seeding users ===');
    await users.main([]);

    print('\n=== Seeding inventory ===');
    await inventory.main([]);

    print('\n=== Seeding bookings ===');
    await bookings.main([]);

    print('\nAll seeders finished successfully.');
  } catch (e) {
    print('One or more seeders failed: $e');
  }
}
