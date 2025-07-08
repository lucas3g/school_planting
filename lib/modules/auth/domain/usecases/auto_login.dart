import 'package:injectable/injectable.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';

import '../../../../core/domain/entities/either_of.dart';
import '../../../../core/domain/entities/failure.dart';
import '../../../../core/domain/entities/usecase.dart';
import '../repositories/auth_repository.dart';

@injectable
class AutoLoginUseCase implements UseCase<UserEntity?, NoArgs> {
  final AuthRepository _authRepository;

  AutoLoginUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<EitherOf<AppFailure, UserEntity?>> call(NoArgs noArgs) {
    return _authRepository.autoLogin();
  }
}
