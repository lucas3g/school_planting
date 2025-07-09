import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:school_planting/modules/planting/data/repositories/planting_repository_impl.dart';
import 'package:school_planting/modules/planting/domain/entities/planting_entity.dart';
import 'package:school_planting/modules/planting/domain/exceptions/planting_exception.dart';
import 'package:school_planting/modules/planting/domain/repositories/planting_repository.dart';

import '../../helpers/mocks.dart';

void main() {
  group('PlantingRepositoryImpl', () {
    late MockPlantingDatasource datasource;
    late PlantingRepository repository;

    setUp(() {
      datasource = MockPlantingDatasource();
      repository = PlantingRepositoryImpl(datasource: datasource);
    });

    test('returns success on createPlanting', () async {
      final entity = PlantingEntity(
        description: '',
        imageName: '',
        userId: '',
        latitude: 0,
        longitude: 0,
      );

      final file = File('f');

      when(
        datasource.createPlanting(
          userId: '',
          description: '',
          image: file,
          imageName: '',
          lat: 0,
          long: 0,
        ),
      ).thenAnswer((_) async => {});

      final result = await repository.createPlanting(entity, file);

      expect(result.isRight, true);
    });

    test('returns failure on error', () async {
      final entity = PlantingEntity(
        description: '',
        imageName: '',
        userId: '',
        latitude: 0,
        longitude: 0,
      );

      final file = File('f');

      when(
        datasource.createPlanting(
          userId: '',
          description: '',
          image: file,
          imageName: '',
          lat: 0,
          long: 0,
        ),
      ).thenThrow(Exception('e'));
      final result = await repository.createPlanting(entity, file);

      expect(result.isLeft, true);
      result.get((failure) {
        expect(failure, isA<PlantingException>());
        return null;
      }, (_) => null);
    });
  });
}
