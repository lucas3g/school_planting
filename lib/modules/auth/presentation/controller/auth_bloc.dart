import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/auth/domain/usecases/login_with_google_account.dart';
import 'package:school_planting/modules/auth/domain/usecases/login_with_apple_account.dart';
import 'package:school_planting/modules/auth/domain/usecases/logout_account.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_events.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_states.dart';

@injectable
class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final LoginWithGoogleAccountUseCase _loginWithGoogleAccountUseCase;
  final LoginWithAppleAccountUseCase _loginWithAppleAccountUseCase;
  final LogoutAccountUsecase _logoutAccountUsecase;

  AuthBloc({
    required LoginWithGoogleAccountUseCase loginWithGoogleAccountUseCase,
    required LoginWithAppleAccountUseCase loginWithAppleAccountUseCase,
    required LogoutAccountUsecase logoutAccountUsecase,
  }) : _loginWithGoogleAccountUseCase = loginWithGoogleAccountUseCase,
       _loginWithAppleAccountUseCase = loginWithAppleAccountUseCase,
       _logoutAccountUsecase = logoutAccountUsecase,
       super(AuthInitialState()) {
    on<LoginWithGoogleAccountEvent>(_onLoginWithGoogleAccount);
    on<LoginWithAppleAccountEvent>(_onLoginWithAppleAccount);
    on<LogoutAccountEvent>(_onLogoutAccount);
  }

  Future<void> _onLoginWithGoogleAccount(
    LoginWithGoogleAccountEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(state.loading(AuthProvider.google));

    final result = await _loginWithGoogleAccountUseCase(NoArgs());

    result.get(
      (failure) => emit(state.failure(failure.message)),
      (user) => emit(state.success(user, AuthProvider.google)),
    );
  }

  Future<void> _onLoginWithAppleAccount(
    LoginWithAppleAccountEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(state.loading(AuthProvider.apple));

    final result = await _loginWithAppleAccountUseCase(NoArgs());

    result.get(
      (failure) => emit(state.failure(failure.message)),
      (user) => emit(state.success(user, AuthProvider.apple)),
    );
  }

  Future<void> _onLogoutAccount(
    LogoutAccountEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(state.loading(AuthProvider.google));

    await Future.delayed(const Duration(seconds: 1));

    final result = await _logoutAccountUsecase(NoArgs());

    result.get(
      (failure) => emit(state.failure(failure.message)),
      (_) => emit(state.logout()),
    );
  }
}
