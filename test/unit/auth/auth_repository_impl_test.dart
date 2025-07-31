import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:school_planting/modules/auth/data/repositories/auth_repository_impl.dart';
import 'package:school_planting/modules/auth/domain/entities/auth_exception.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';
import 'package:school_planting/modules/auth/domain/repositories/auth_repository.dart';

import '../../helpers/mocks.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late MockAuthDatasource datasource;
    late AuthRepository repository;

    setUp(() {
      datasource = MockAuthDatasource();
      repository = AuthRepositoryImpl(authDatasource: datasource);
    });

    test('loginWithGoogleAccount returns user on success', () async {
      final user = UserEntity(id: '1', email: 'a', name: 'b');
      when(datasource.loginWithGoogleAccount()).thenAnswer((_) async => user);

      final result = await repository.loginWithGoogleAccount();

      verify(datasource.loginWithGoogleAccount()).called(1);
      expect(result.isRight, true);
    });

    test('loginWithGoogleAccount returns failure on exception', () async {
      when(datasource.loginWithGoogleAccount()).thenThrow(Exception('err'));

      final result = await repository.loginWithGoogleAccount();

      expect(result.isLeft, true);
      result.get((failure) {
        expect(failure, isA<AuthException>());
        return null;
      }, (_) => null);
    });

    test('loginWithAppleAccount returns user on success', () async {
      final user = UserEntity(id: '1', email: 'a', name: 'b');
      when(datasource.loginWithAppleAccount()).thenAnswer((_) async => user);

      final result = await repository.loginWithAppleAccount();

      verify(datasource.loginWithAppleAccount()).called(1);
      expect(result.isRight, true);
    });

    test('loginWithAppleAccount returns failure on exception', () async {
      when(datasource.loginWithAppleAccount()).thenThrow(Exception('err'));

      final result = await repository.loginWithAppleAccount();

      expect(result.isLeft, true);
      result.get((failure) {
        expect(failure, isA<AuthException>());
        return null;
      }, (_) => null);
    });

    test('autoLogin returns data from datasource', () async {
      when(datasource.autoLogin()).thenAnswer((_) async => null);

      final result = await repository.autoLogin();

      verify(datasource.autoLogin()).called(1);
      expect(result.isRight, true);
    });

    test('logout returns success', () async {
      when(datasource.logout()).thenAnswer((_) async => {});

      final result = await repository.logout();

      verify(datasource.logout()).called(1);
      expect(result.isRight, true);
    });
  });
}
