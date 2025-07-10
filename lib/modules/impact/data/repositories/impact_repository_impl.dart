import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/modules/impact/data/datasources/impact_datasource.dart';
import 'package:school_planting/modules/impact/domain/entities/impact_entity.dart';
import 'package:school_planting/modules/impact/domain/exceptions/impact_exception.dart';
import 'package:school_planting/modules/impact/domain/repositories/impact_repository.dart';

@Injectable(as: ImpactRepository)
class ImpactRepositoryImpl implements ImpactRepository {
  final ImpactDatasource _datasource;

  ImpactRepositoryImpl({required ImpactDatasource datasource})
      : _datasource = datasource;

  @override
  Future<EitherOf<AppFailure, ImpactEntity>> getImpactData() async {
    try {
      final userId = AppGlobal.instance.user?.id.value ?? '';
      final count = await _datasource.countPlantings(userId);
      final impact = ImpactEntity.fromCount(count);
      return resolve(impact);
    } on AppFailure catch (e) {
      return reject(e);
    } catch (e) {
      return reject(ImpactException(e.toString()));
    }
  }
}
