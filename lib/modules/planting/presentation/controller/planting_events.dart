import 'dart:io';

import 'package:school_planting/modules/planting/domain/entities/planting_entity.dart';

abstract class PlantingEvents {}

class CreatePlantingEvent extends PlantingEvents {
  final PlantingEntity entity;
  final File image;

  CreatePlantingEvent({required this.entity, required this.image});
}
