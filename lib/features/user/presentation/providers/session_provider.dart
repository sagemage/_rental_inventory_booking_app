import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';
import 'user_providers.dart';

/// Simple session provider exposing the current user's role.
/// This is used by route guards and UI to determine available actions.
final currentUserRoleProvider = Provider<UserRole?>((ref) {
  final userState = ref.watch(userNotifierProvider);
  return userState.currentUser?.role;
});

/// Current authenticated user id
final currentUserIdProvider = Provider<String?>((ref) {
  final userState = ref.watch(userNotifierProvider);
  return userState.currentUser?.id;
});
