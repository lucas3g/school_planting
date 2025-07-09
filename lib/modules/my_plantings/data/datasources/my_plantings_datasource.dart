import 'package:school_planting/modules/my_plantings/domain/entities/my_planting_entity.dart';

abstract class MyPlantingsDatasource {
  Future<List<MyPlantingEntity>> fetchMyPlantings(String userId);
}
