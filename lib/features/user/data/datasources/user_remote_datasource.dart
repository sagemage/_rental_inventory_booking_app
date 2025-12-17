import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  /// Returns the currently signed in user as a [UserModel].
  ///
  /// Throws an [Exception] for any error.
  Future<UserModel> getCurrentUser();


  Future<UserModel> signUp({
    required String fullName,
    required String phoneNumber,
    required String deliveryAddress,
    String? email,
    required String password,
    UserRole role = UserRole.client,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel> updateProfile(UserModel user);
}
