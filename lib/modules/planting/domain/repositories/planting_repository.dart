import 'dart:io';

import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/modules/planting/domain/entities/planting_entity.dart';

abstract class PlantingRepository {
  Future<EitherOf<AppFailure, VoidSuccess>> createPlanting(
    PlantingEntity planting,
    File image,
  );
}
