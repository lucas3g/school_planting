import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/modules/my_plantings/domain/entities/my_planting_entity.dart';

abstract class MyPlantingsRepository {
  Future<EitherOf<AppFailure, List<MyPlantingEntity>>> getMyPlantings();
}
