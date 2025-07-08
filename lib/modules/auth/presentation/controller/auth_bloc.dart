import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/auth/domain/usecases/login_with_google_account.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_events.dart';
import 'package:school_planting/modules/auth/presentation/controller/auth_states.dart';

@injectable
class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final LoginWithGoogleAccountUseCase _loginWithGoogleAccountUseCase;

  AuthBloc({
    required LoginWithGoogleAccountUseCase loginWithGoogleAccountUseCase,
  }) : _loginWithGoogleAccountUseCase = loginWithGoogleAccountUseCase,
       super(AuthInitialState()) {
    on<LoginWithGoogleAccountEvent>(_onLoginWithGoogleAccount);
  }

  Future<void> _onLoginWithGoogleAccount(
    LoginWithGoogleAccountEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(state.loading());

    final result = await _loginWithGoogleAccountUseCase(NoArgs());

    result.get(
      (failure) => emit(state.failure(failure.message)),
      (user) => emit(state.success(user)),
    );
  }
}
