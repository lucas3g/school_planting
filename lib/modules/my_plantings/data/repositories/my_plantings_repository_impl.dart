import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/modules/my_plantings/data/datasources/my_plantings_datasource.dart';
import 'package:school_planting/modules/my_plantings/domain/entities/my_planting_entity.dart';
import 'package:school_planting/modules/my_plantings/domain/exceptions/my_plantings_exception.dart';
import 'package:school_planting/modules/my_plantings/domain/repositories/my_plantings_repository.dart';

@Injectable(as: MyPlantingsRepository)
class MyPlantingsRepositoryImpl implements MyPlantingsRepository {
  final MyPlantingsDatasource _datasource;

  MyPlantingsRepositoryImpl({required MyPlantingsDatasource datasource})
      : _datasource = datasource;

  @override
  Future<EitherOf<AppFailure, List<MyPlantingEntity>>> getMyPlantings() async {
    try {
      final userId = AppGlobal.instance.user?.id.value ?? '';
      final result = await _datasource.fetchMyPlantings(userId);
      return resolve(result);
    } on AppFailure catch (e) {
      return reject(e);
    } catch (e) {
      return reject(MyPlantingsException(e.toString()));
    }
  }
}
