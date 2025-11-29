import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';

/// Simple session provider exposing the current user's role.
///
/// This is used by route guards and UI to determine available actions.
/// In a real app this would be populated from authentication + user profile data.
final currentUserRoleProvider = StateProvider<UserRole?>((ref) => UserRole.client);
