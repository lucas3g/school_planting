import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/planting/domain/repositories/plantnet_repository.dart';

@injectable
class ValidatePlantImageUseCase implements UseCase<bool, File> {
  final PlantNetRepository _repository;

  ValidatePlantImageUseCase({required PlantNetRepository repository})
      : _repository = repository;

  @override
  Future<EitherOf<AppFailure, bool>> call(File image) {
    return _repository.isPlant(image);
  }
}
