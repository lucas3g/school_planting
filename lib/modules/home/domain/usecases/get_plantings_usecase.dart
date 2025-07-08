import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';
import 'package:school_planting/modules/home/domain/repositories/map_planting_repository.dart';

class GetPlantingsUseCase
    implements UseCase<List<PlantingDetailEntity>, NoArgs> {
  final MapPlantingRepository _repository;

  GetPlantingsUseCase({required MapPlantingRepository repository})
      : _repository = repository;

  @override
  Future<EitherOf<AppFailure, List<PlantingDetailEntity>>> call(
      NoArgs args) {
    return _repository.getPlantings();
  }
}
