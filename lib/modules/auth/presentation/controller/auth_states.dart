// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';

abstract class AuthStates {
  AuthLoadingState loading() => AuthLoadingState();

  AuthSuccessState success(UserEntity user) => AuthSuccessState(user: user);

  AuthFailureState failure(String message) => AuthFailureState(message);

  LogoutAccountState logout() => LogoutAccountState();
}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState extends AuthStates {
  UserEntity user;

  AuthSuccessState({required this.user});
}

class AuthFailureState extends AuthStates {
  final String message;

  AuthFailureState(this.message);
}

class LogoutAccountState extends AuthStates {}
