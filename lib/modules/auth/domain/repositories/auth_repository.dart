import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<EitherOf<AppFailure, UserEntity>> loginWithGoogleAccount();
  Future<EitherOf<AppFailure, UserEntity?>> autoLogin();
  Future<EitherOf<AppFailure, VoidSuccess>> logout();
}
