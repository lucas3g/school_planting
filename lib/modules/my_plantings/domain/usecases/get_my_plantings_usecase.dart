import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/my_plantings/domain/entities/my_planting_entity.dart';
import 'package:school_planting/modules/my_plantings/domain/repositories/my_plantings_repository.dart';

@injectable
class GetMyPlantingsUseCase
    implements UseCase<List<MyPlantingEntity>, NoArgs> {
  final MyPlantingsRepository _repository;

  GetMyPlantingsUseCase({required MyPlantingsRepository repository})
      : _repository = repository;

  @override
  Future<EitherOf<AppFailure, List<MyPlantingEntity>>> call(NoArgs args) {
    return _repository.getMyPlantings();
  }
}
