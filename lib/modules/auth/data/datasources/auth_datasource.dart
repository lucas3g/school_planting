import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';

abstract class AuthDatasource {
  Future<UserEntity> loginWithGoogleAccount();
  Future<UserEntity> loginWithAppleAccount();
  Future<UserEntity?> autoLogin();
  Future<void> logout();
}
