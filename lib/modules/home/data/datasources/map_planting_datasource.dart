import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';

abstract class MapPlantingDatasource {
  Future<List<PlantingDetailEntity>> fetchPlantings();
}
