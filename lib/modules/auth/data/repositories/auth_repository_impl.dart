import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/modules/auth/data/datasources/auth_datasource.dart';
import 'package:school_planting/modules/auth/domain/entities/auth_exception.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';
import 'package:school_planting/modules/auth/domain/repositories/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _authDatasource;

  AuthRepositoryImpl({required AuthDatasource authDatasource})
    : _authDatasource = authDatasource;

  @override
  Future<EitherOf<AppFailure, UserEntity>> loginWithGoogleAccount() async {
    try {
      final user = await _authDatasource.loginWithGoogleAccount();
      return resolve(user);
    } on AppFailure catch (error) {
      return reject(error);
    } catch (error) {
      return reject(AuthException(error.toString()));
    }
  }

  @override
  Future<EitherOf<AppFailure, UserEntity?>> autoLogin() async {
    try {
      final UserEntity? user = await _authDatasource.autoLogin();
      return resolve(user);
    } on AppFailure catch (error) {
      return reject(error);
    } catch (error) {
      return reject(AuthException('Erro ao tentar fazer login'));
    }
  }

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> logout() async {
    try {
      await _authDatasource.logout();

      return resolve(const VoidSuccess());
    } on AppFailure catch (error) {
      return reject(error);
    } catch (error) {
      return reject(AuthException('auth.error.logoutFailed'));
    }
  }
}
