import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import 'package:school_planting/modules/planting/data/datasources/planting_datasource.dart';
import 'package:school_planting/modules/planting/domain/entities/planting_entity.dart';
import 'package:school_planting/modules/planting/domain/exceptions/planting_exception.dart';
import 'package:school_planting/modules/planting/domain/repositories/planting_repository.dart';

@Injectable(as: PlantingRepository)
class PlantingRepositoryImpl implements PlantingRepository {
  final PlantingDatasource _datasource;

  PlantingRepositoryImpl({required PlantingDatasource datasource})
      : _datasource = datasource;

  @override
  Future<EitherOf<AppFailure, VoidSuccess>> createPlanting(
    PlantingEntity planting,
    File image,
  ) async {
    try {
      await _datasource.createPlanting(
        userId: planting.userId,
        description: planting.description,
        image: image,
        imageName: planting.imageName,
      );
      return resolve(const VoidSuccess());
    } on AppFailure catch (e) {
      return reject(e);
    } catch (e) {
      return reject(PlantingException(e.toString()));
    }
  }
}
