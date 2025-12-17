import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_inventory_booking_app/core/providers/firebase_providers.dart';
import 'package:rental_inventory_booking_app/features/user/data/datasources/user_remote_datasource_impl.dart';
import 'package:rental_inventory_booking_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:rental_inventory_booking_app/features/user/domain/usecases/get_current_user.dart';
import 'package:rental_inventory_booking_app/features/user/domain/usecases/login.dart';
import 'package:rental_inventory_booking_app/features/user/domain/usecases/sign_out.dart';
import 'package:rental_inventory_booking_app/features/user/domain/usecases/sign_up.dart';
import 'package:rental_inventory_booking_app/features/user/domain/usecases/update_profile.dart';
import 'package:rental_inventory_booking_app/features/user/presentation/state/user_notifier.dart';

final userRemoteDataSourceProvider = Provider<UserRemoteDataSourceImpl>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  return UserRemoteDataSourceImpl(auth: auth, firestore: firestore);
});

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  final remote = ref.watch(userRemoteDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource: remote);
});

final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return GetCurrentUser(repo);
});

final signUpProvider = Provider<SignUp>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return SignUp(repo);
});

final loginProvider = Provider<Login>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return Login(repo);
});

final signOutProvider = Provider<SignOut>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return SignOut(repo);
});

final updateProfileProvider = Provider<UpdateProfile>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UpdateProfile(repo);
});

final userNotifierProvider = NotifierProvider<UserNotifier, UserState>(() {
  return UserNotifier();
});