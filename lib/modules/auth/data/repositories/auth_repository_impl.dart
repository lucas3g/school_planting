import 'dart:io';

import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/modules/auth/data/datasources/auth_datasource.dart';
import 'package:school_planting/modules/auth/domain/entities/auth_exception.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';
import 'package:school_planting/modules/auth/domain/repositories/auth_repository.dart';

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
    } on HttpException catch (error) {
      return reject(AuthException(error.message));
    } catch (error) {
      return reject(AuthException(error.toString()));
    }
  }
}
