import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String fullName,
    required String phoneNumber,
    String? email,
    String? address,
    required UserRole role,
  }) : super(
          id: id,
          fullName: fullName,
          phoneNumber: phoneNumber,
          email: email,
          address: address,
          role: role,
        );

  factory UserModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final roleStr = map['role'] as String? ?? 'client';
    return UserModel(
      id: id ?? (map['id'] as String? ?? ''),
      fullName: map['fullName'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      email: map['email'] as String?,
      address: map['address'] as String?,
      role: roleFromString(roleStr),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'role': roleToString(role),
    };
  }

  static UserRole roleFromString(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return UserRole.owner;
      case 'admin':
        return UserRole.admin;
      case 'client':
      default:
        return UserRole.client;
    }
  }

  static String roleToString(UserRole role) => role.toString().split('.').last;
}
