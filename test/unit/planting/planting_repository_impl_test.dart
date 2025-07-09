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
      when(
        datasource.createPlanting(
          userId: anyNamed('userId'),
          description: anyNamed('description'),
          image: anyNamed('image'),
          imageName: anyNamed('imageName'),
          lat: anyNamed('lat'),
          long: anyNamed('long'),
        ),
      ).thenAnswer((_) async => {});

      final entity = PlantingEntity(
        description: 'd',
        imageName: 'img',
        userId: '1',
        latitude: 1,
        longitude: 2,
      );

      final file = File('f');
      final result = await repository.createPlanting(entity, file);

      expect(result.isRight, true);
    });

    test('returns failure on error', () async {
      when(
        datasource.createPlanting(
          userId: anyNamed('userId'),
          description: anyNamed('description'),
          image: anyNamed('image'),
          imageName: anyNamed('imageName'),
          lat: anyNamed('lat'),
          long: anyNamed('long'),
        ),
      ).thenThrow(Exception('e'));

      final entity = PlantingEntity(
        description: 'd',
        imageName: 'img',
        userId: '1',
        latitude: 1,
        longitude: 2,
      );

      final file = File('f');
      final result = await repository.createPlanting(entity, file);

      expect(result.isLeft, true);
      result.get((failure) {
        expect(failure, isA<PlantingException>());
        return null;
      }, (_) => null);
    });
  });
}
