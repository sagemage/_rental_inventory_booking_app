import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';
import 'package:rental_inventory_booking_app/features/user/domain/usecases/get_current_user.dart';
import 'package:rental_inventory_booking_app/features/user/domain/usecases/login.dart';
import 'package:rental_inventory_booking_app/features/user/domain/usecases/sign_out.dart';
import 'package:rental_inventory_booking_app/features/user/domain/usecases/sign_up.dart';
import 'package:rental_inventory_booking_app/features/user/domain/usecases/update_profile.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import '../providers/user_providers.dart';

class UserState {
  final User? currentUser;
  final bool isLoading;
  final String? error;

  const UserState({
    this.currentUser,
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    User? currentUser,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class UserNotifier extends Notifier<UserState> {
  late final GetCurrentUser _getCurrentUser;
  late final SignUp _signUpUsecase;
  late final Login _loginUsecase;
  late final SignOut _signOut;
  late final UpdateProfile _updateProfile;

  @override
  UserState build() {
    _getCurrentUser = ref.watch(getCurrentUserProvider);
    _signUpUsecase = ref.watch(signUpProvider);
    _loginUsecase = ref.watch(loginProvider);
    _signOut = ref.watch(signOutProvider);
    _updateProfile = ref.watch(updateProfileProvider);
    return const UserState();
  }

  Future<void> loadCurrentUser() async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _getCurrentUser.call();
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: _mapFailure(f)),
      (user) => state = state.copyWith(isLoading: false, currentUser: user),
    );
  }


  Future<void> signUp({
    required String fullName,
    required String phoneNumber,
    required String deliveryAddress,
    String? email,
    required String password,
    UserRole role = UserRole.client,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _signUpUsecase.call(
      fullName: fullName,
      phoneNumber: phoneNumber,
      deliveryAddress: deliveryAddress,
      email: email,
      password: password,
      role: role,
    );
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: _mapFailure(f)),
      (user) => state = state.copyWith(isLoading: false, currentUser: user),
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _loginUsecase.call(email: email, password: password);
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: _mapFailure(f)),
      (user) => state = state.copyWith(isLoading: false, currentUser: user),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _signOut.call();
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: _mapFailure(f)),
      (_) => state = state.copyWith(isLoading: false, currentUser: null),
    );
  }

  Future<void> updateUserProfile(User user) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _updateProfile.call(user);
    res.fold(
      (f) => state = state.copyWith(isLoading: false, error: _mapFailure(f)),
      (updatedUser) => state = state.copyWith(isLoading: false, currentUser: updatedUser),
    );
  }

  // Public methods
  Future<void> signOut() => logout();

  String _mapFailure(Failure f) => f is ServerFailure ? 'Server: ${f.message}' : 'Unexpected error';
}