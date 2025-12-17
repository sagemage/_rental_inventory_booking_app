

import 'package:equatable/equatable.dart';



enum UserRole {
  client,
  owner,
  admin,
}




class User extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String deliveryAddress;
  final bool isPhoneVerified;
  final UserRole role;
  final bool agreedToTerms;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final Map<String, String>? savedAddresses;
  final String? profileImageUrl;

  const User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    required this.deliveryAddress,
    this.isPhoneVerified = false,
    this.role = UserRole.client,
    this.agreedToTerms = false,
    required this.createdAt,
    this.lastLoginAt,
    this.savedAddresses,
    this.profileImageUrl,
  });

  // Helper method to check if user is complete for booking
  bool get isProfileComplete {
    return fullName.isNotEmpty && 
           phoneNumber.isNotEmpty &&
           deliveryAddress.isNotEmpty &&
           agreedToTerms;
  }

  // Helper method to check if user can make bookings
  bool get canMakeBookings {
    return role == UserRole.client && isProfileComplete;
  }

  // Helper method to check if user is an owner
  bool get isOwner {
    return role == UserRole.owner;
  }

  @override
  List<Object?> get props => [
    id, 
    fullName, 
    phoneNumber, 
    email, 
    deliveryAddress,
    isPhoneVerified,
    role, 
    agreedToTerms, 
    createdAt, 
    lastLoginAt,
    savedAddresses,
    profileImageUrl,
  ];

  // Copy with method for updates
  User copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? deliveryAddress,
    bool? isPhoneVerified,
    UserRole? role,
    bool? agreedToTerms,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, String>? savedAddresses,
    String? profileImageUrl,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      role: role ?? this.role,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  // Factory method for creating from JSON (if using local storage)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'],
      deliveryAddress: json['deliveryAddress'] ?? '',
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.client,
      ),
      agreedToTerms: json['agreedToTerms'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt']) 
          : null,
      savedAddresses: json['savedAddresses'] != null 
          ? Map<String, String>.from(json['savedAddresses'])
          : null,
      profileImageUrl: json['profileImageUrl'],
    );
  }


  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'deliveryAddress': deliveryAddress,
      'isPhoneVerified': isPhoneVerified,
      'role': role.toString().split('.').last,
      'agreedToTerms': agreedToTerms,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'savedAddresses': savedAddresses,
      'profileImageUrl': profileImageUrl,
    };
  }
}
