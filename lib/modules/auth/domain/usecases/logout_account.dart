import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/either_of.dart';
import '../../../../core/domain/entities/failure.dart';
import '../../../../core/domain/entities/usecase.dart';
import '../repositories/auth_repository.dart';

@injectable
class LogoutAccountUsecase implements UseCase<VoidSuccess, NoArgs> {
  final AuthRepository _authRepository;

  LogoutAccountUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> call(NoArgs args) {
    return _authRepository.logout();
  }
}
