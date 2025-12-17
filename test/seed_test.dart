import 'package:flutter_test/flutter_test.dart';
import '../scripts/seed_users.dart' as seed_users;
import '../scripts/seed_inventory.dart' as seed_inventory;
import '../scripts/query_inventory.dart' as query_inventory;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Run seed users script', () async {
    await seed_users.main([]);
  });

  test('Run seed inventory script', () async {
    await seed_inventory.main([]);
  });

  test('Query inventory items', () async {
    await query_inventory.main([]);
  });
}