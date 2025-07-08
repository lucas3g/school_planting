import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/planting/domain/entities/planting_entity.dart';
import 'package:school_planting/modules/planting/domain/repositories/planting_repository.dart';

@injectable
class CreatePlantingUseCase implements UseCase<VoidSuccess, CreatePlantingParams> {
  final PlantingRepository _repository;

  CreatePlantingUseCase({required PlantingRepository repository})
      : _repository = repository;

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> call(CreatePlantingParams params) {
    return _repository.createPlanting(params.entity, params.image);
  }
}

class CreatePlantingParams {
  final PlantingEntity entity;
  final File image;

  const CreatePlantingParams({required this.entity, required this.image});
}
