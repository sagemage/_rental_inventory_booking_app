import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_inventory_booking_app/core/error/failures.dart';
import 'package:rental_inventory_booking_app/features/user/data/datasources/user_remote_datasource.dart';
import 'package:rental_inventory_booking_app/features/user/data/models/user_model.dart';
import 'package:rental_inventory_booking_app/features/user/domain/entities/user.dart';
import 'package:rental_inventory_booking_app/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel);
    } on fb_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, User>> signUp({
    required String fullName,
    required String phoneNumber,
    required String deliveryAddress,
    String? email,
    required String password,
    UserRole role = UserRole.client,
  }) async {
    try {
      final userModel = await remoteDataSource.signUp(
        fullName: fullName,
        phoneNumber: phoneNumber,
        deliveryAddress: deliveryAddress,
        email: email,
        password: password,
        role: role,
      );
      return Right(userModel);
    } on fb_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(email: email, password: password);
      return Right(userModel);
    } on fb_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on fb_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, User>> updateProfile(User user) async {
    try {
      // Expecting a UserModel, but domain may pass a User; create a UserModel from it when possible.
      final userModel = (user is UserModel)
          ? user
          : UserModel(
              id: user.id,
              fullName: user.fullName,
              phoneNumber: user.phoneNumber,
              email: user.email,
              deliveryAddress: user.deliveryAddress,
              role: user.role,
              createdAt: user.createdAt,
            );

      final updated = await remoteDataSource.updateProfile(userModel);
      return Right(updated);
    } on fb_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
