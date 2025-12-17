

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String fullName,
    required String phoneNumber,
    String? email,
    required String deliveryAddress,
    bool isPhoneVerified = false,
    UserRole role = UserRole.client,
    bool agreedToTerms = false,
    required DateTime createdAt,
    DateTime? lastLoginAt,
    Map<String, String>? savedAddresses,
    String? profileImageUrl,
  }) : super(
          id: id,
          fullName: fullName,
          phoneNumber: phoneNumber,
          email: email,
          deliveryAddress: deliveryAddress,
          isPhoneVerified: isPhoneVerified,
          role: role,
          agreedToTerms: agreedToTerms,
          createdAt: createdAt,
          lastLoginAt: lastLoginAt,
          savedAddresses: savedAddresses,
          profileImageUrl: profileImageUrl,
        );

  factory UserModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return UserModel(
      id: id,
      fullName: map['fullName'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      email: map['email'] as String?,
      deliveryAddress: map['deliveryAddress'] as String? ?? '',
      isPhoneVerified: map['isPhoneVerified'] as bool? ?? false,
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == map['role'],
        orElse: () => UserRole.client,
      ),
      agreedToTerms: map['agreedToTerms'] as bool? ?? false,
      createdAt: map['createdAt'] is Timestamp 
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'] != null 
              ? DateTime.parse(map['createdAt'] as String)
              : DateTime.now(),
      lastLoginAt: map['lastLoginAt'] is Timestamp 
          ? (map['lastLoginAt'] as Timestamp).toDate()
          : map['lastLoginAt'] != null 
              ? DateTime.parse(map['lastLoginAt'] as String)
              : null,
      savedAddresses: map['savedAddresses'] != null 
          ? Map<String, String>.from(map['savedAddresses'])
          : null,
      profileImageUrl: map['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
        'deliveryAddress': deliveryAddress,
        'isPhoneVerified': isPhoneVerified,
        'role': role.toString().split('.').last,
        'agreedToTerms': agreedToTerms,
        'createdAt': Timestamp.fromDate(createdAt),
        if (lastLoginAt != null) 'lastLoginAt': Timestamp.fromDate(lastLoginAt!),
        'savedAddresses': savedAddresses,
        'profileImageUrl': profileImageUrl,
      };

  // Convert to User entity
  User toEntity() {
    return User(
      id: id,
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      deliveryAddress: deliveryAddress,
      isPhoneVerified: isPhoneVerified,
      role: role,
      agreedToTerms: agreedToTerms,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      savedAddresses: savedAddresses,
      profileImageUrl: profileImageUrl,
    );
  }

  // Create from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      phoneNumber: user.phoneNumber,
      email: user.email,
      deliveryAddress: user.deliveryAddress,
      isPhoneVerified: user.isPhoneVerified,
      role: user.role,
      agreedToTerms: user.agreedToTerms,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
      savedAddresses: user.savedAddresses,
      profileImageUrl: user.profileImageUrl,
    );
  }
}
