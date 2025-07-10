import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import '../entities/impact_entity.dart';
import '../repositories/impact_repository.dart';

@injectable
class GetImpactUseCase implements UseCase<ImpactEntity, NoArgs> {
  final ImpactRepository _repository;

  GetImpactUseCase({required ImpactRepository repository})
      : _repository = repository;

  @override
  Future<EitherOf<AppFailure, ImpactEntity>> call(NoArgs args) {
    return _repository.getImpactData();
  }
}
