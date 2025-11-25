Seed scripts for Firestore (UAT)

Files:
- `seed_users.dart` — seeds `users` collection with sample clients, owners, and admin.
- `seed_inventory.dart` — seeds `inventory_items` collection with sample rental items.
- `seed_bookings.dart` — seeds `bookings` collection referencing the users and items.
- `seed_all.dart` — runs all three seeders in sequence.

Quick usage (run from project root in PowerShell):

```powershell
# Run a single seeder
dart run scripts/seed_users.dart
dart run scripts/seed_inventory.dart
dart run scripts/seed_bookings.dart

# Or run all seeders sequentially
dart run scripts/seed_all.dart
```

Notes:
- Each script initializes Firebase using `DefaultFirebaseOptions.currentPlatform`.
  Replace the placeholder `DefaultFirebaseOptions` values in each script with your
  actual Firebase project's configuration, or generate `lib/firebase_options.dart`
  with the FlutterFire CLI and import that instead.

- The seed scripts use Firestore batch writes and will print status messages to the console.
- Order recommendation: run `seed_users` → `seed_inventory` → `seed_bookings` (or just `seed_all`).
