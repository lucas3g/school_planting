import 'package:flutter_test/flutter_test.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';
import 'package:school_planting/modules/auth/domain/usecases/auto_login.dart';
import 'package:school_planting/modules/auth/domain/usecases/login_with_google_account.dart';
import 'package:school_planting/modules/auth/domain/usecases/logout_account.dart';

import '../../helpers/mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('Auth usecases', () {
    late MockAuthRepository repository;
    late LoginWithGoogleAccountUseCase login;
    late AutoLoginUseCase autoLogin;
    late LogoutAccountUsecase logout;

    setUp(() {
      repository = MockAuthRepository();
      login = LoginWithGoogleAccountUseCase(authRepository: repository);
      autoLogin = AutoLoginUseCase(authRepository: repository);
      logout = LogoutAccountUsecase(authRepository: repository);
    });

    test('login calls repository', () async {
      final user = UserEntity(id: '1', email: 'a', name: 'b');
      when(repository.loginWithGoogleAccount())
          .thenAnswer((_) async => resolve(user));

      final result = await login(const NoArgs());

      verify(repository.loginWithGoogleAccount()).called(1);
      expect(result.isRight, true);
    });

    test('autoLogin calls repository', () async {
      when(repository.autoLogin()).thenAnswer((_) async => resolve(null));
      final result = await autoLogin(const NoArgs());
      verify(repository.autoLogin()).called(1);
      expect(result.isRight, true);
    });

    test('logout calls repository', () async {
      when(repository.logout())
          .thenAnswer((_) async => resolve(const VoidSuccess()));
      final result = await logout(const NoArgs());
      verify(repository.logout()).called(1);
      expect(result.isRight, true);
    });
  });
}
