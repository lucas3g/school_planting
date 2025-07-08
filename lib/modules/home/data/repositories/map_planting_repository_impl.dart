import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/modules/home/data/datasources/map_planting_datasource.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';
import 'package:school_planting/modules/home/domain/exceptions/home_exception.dart';
import 'package:school_planting/modules/home/domain/repositories/map_planting_repository.dart';

class MapPlantingRepositoryImpl implements MapPlantingRepository {
  final MapPlantingDatasource _datasource;

  MapPlantingRepositoryImpl({required MapPlantingDatasource datasource})
      : _datasource = datasource;

  @override
  Future<EitherOf<AppFailure, List<PlantingDetailEntity>>> getPlantings() async {
    try {
      final result = await _datasource.fetchPlantings();
      return resolve(result);
    } on AppFailure catch (e) {
      return reject(e);
    } catch (e) {
      return reject(HomeException(e.toString()));
    }
  }
}
