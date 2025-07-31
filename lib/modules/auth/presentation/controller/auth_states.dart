// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';

enum AuthProvider { google, apple }

abstract class AuthStates {
  AuthLoadingState loading(AuthProvider provider) => AuthLoadingState(provider);

  AuthSuccessState success(UserEntity user, AuthProvider provider) =>
      AuthSuccessState(user: user, provider: provider);

  AuthFailureState failure(String message) => AuthFailureState(message);

  LogoutAccountState logout() => LogoutAccountState();
}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {
  final AuthProvider provider;

  AuthLoadingState(this.provider);
}

class AuthSuccessState extends AuthStates {
  final UserEntity user;
  final AuthProvider provider;

  AuthSuccessState({required this.user, required this.provider});
}

class AuthFailureState extends AuthStates {
  final String message;

  AuthFailureState(this.message);
}

class LogoutAccountState extends AuthStates {}
