import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';
import '../models/user_model.dart';
import 'user_remote_datasource.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final fb_auth.FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const UserRemoteDataSourceImpl({required this.auth, required this.firestore});

  CollectionReference<Map<String, dynamic>> get _usersRef => firestore.collection('users');

  @override
  Future<UserModel> getCurrentUser() async {
    final fbUser = auth.currentUser;
    if (fbUser == null) throw Exception('No authenticated user');

    final doc = await _usersRef.doc(fbUser.uid).get();
    if (!doc.exists) throw Exception('User document not found');
    final data = doc.data()!;
    return UserModel.fromMap(data, id: doc.id);
  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String phoneNumber,
    String? email,
    String? address,
    required String password,
    required UserRole role,
  }) async {
    // Firebase Auth primarily supports email/password; map phoneNumber -> synthetic email when needed.
    final signupEmail = (email != null && email.isNotEmpty) ? email : _emailFromPhone(phoneNumber);

    final credential = await auth.createUserWithEmailAndPassword(
      email: signupEmail,
      password: password,
    );

    final uid = credential.user!.uid;

    final model = UserModel(
      id: uid,
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      role: UserModel.roleFromString(role.toString().split('.').last),
    );

    await _usersRef.doc(uid).set(model.toMap());
    return model;
  }

  @override
  Future<UserModel> login({required String phoneNumber, required String password}) async {
    final email = _emailFromPhone(phoneNumber);
    final result = await auth.signInWithEmailAndPassword(email: email, password: password);
    final uid = result.user!.uid;
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) throw Exception('User document not found');
    return UserModel.fromMap(doc.data()!, id: doc.id);
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    await _usersRef.doc(user.id).update(user.toMap());
    final doc = await _usersRef.doc(user.id).get();
    return UserModel.fromMap(doc.data()!, id: doc.id);
  }

  String _emailFromPhone(String phone) => phone.replaceAll(RegExp(r'[^0-9]'), '') + '@phone.local';
}
