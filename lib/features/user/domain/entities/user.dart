import 'package:equatable/equatable.dart';

enum UserRole { client, owner, admin }

class User extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? address;
  final UserRole role;

  const User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.address,
    required this.role,
  });

  @override
  List<Object?> get props => [id, fullName, phoneNumber, email, address, role];
}