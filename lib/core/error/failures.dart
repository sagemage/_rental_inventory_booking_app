import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;
  const Failure([this.message]);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String? message]) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String? message]) : super(message);
}

class NoUserFailure extends Failure {
  const NoUserFailure([String? message]) : super(message);
}
