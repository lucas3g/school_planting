import 'dart:io';

import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';

abstract class PlantNetRepository {
  Future<EitherOf<AppFailure, bool>> isPlant(File image);
}
