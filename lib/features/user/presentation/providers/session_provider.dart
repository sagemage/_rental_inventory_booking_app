import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';

/// Holds current user session info for simple route-guarding and testing.
final currentUserRoleProvider = StateProvider<UserRole?>((ref) => UserRole.client);

/// Current authenticated user id (for testing default to a seeded user)
final currentUserIdProvider = StateProvider<String?>((ref) => 'user_001');
