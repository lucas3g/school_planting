import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/modules/planting/data/datasources/plantnet_datasource.dart';
import 'package:school_planting/modules/planting/domain/exceptions/plantnet_exception.dart';
import 'package:school_planting/modules/planting/domain/repositories/plantnet_repository.dart';

@Injectable(as: PlantNetRepository)
class PlantNetRepositoryImpl implements PlantNetRepository {
  final PlantNetDatasource _datasource;

  PlantNetRepositoryImpl({required PlantNetDatasource datasource})
      : _datasource = datasource;

  @override
  Future<EitherOf<AppFailure, bool>> isPlant(File image) async {
    try {
      final result = await _datasource.isPlantImage(image);
      return resolve(result);
    } on AppFailure catch (e) {
      return reject(e);
    } catch (e) {
      return reject(PlantNetException(e.toString()));
    }
  }
}
