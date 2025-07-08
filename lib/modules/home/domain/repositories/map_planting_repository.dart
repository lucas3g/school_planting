import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';

abstract class MapPlantingRepository {
  Future<EitherOf<AppFailure, List<PlantingDetailEntity>>> getPlantings();
}
