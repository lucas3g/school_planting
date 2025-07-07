import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';
import 'package:school_planting/modules/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogleAccount implements UseCase<UserEntity, NoArgs> {
  final AuthRepository _authRepository;

  LoginWithGoogleAccount({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<EitherOf<AppFailure, UserEntity>> call(NoArgs args) async {
    return await _authRepository.loginWithGoogleAccount();
  }
}
