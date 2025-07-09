import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/planting/domain/entities/planting_entity.dart';
import 'package:school_planting/modules/planting/domain/usecases/create_planting_usecase.dart';

import '../../helpers/mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('CreatePlantingUseCase', () {
    late MockPlantingRepository repository;
    late CreatePlantingUseCase usecase;

    setUp(() {
      repository = MockPlantingRepository();
      usecase = CreatePlantingUseCase(repository: repository);
    });

    test('calls repository to create planting', () async {
      when(repository.createPlanting(any, any))
          .thenAnswer((_) async => resolve(const VoidSuccess()));

      final entity = PlantingEntity(
          description: 'd',
          imageName: 'img',
          userId: '1',
          latitude: 1,
          longitude: 2);
      final file = File('test.txt');
      final params = CreatePlantingParams(entity: entity, image: file);

      final result = await usecase(params);

      verify(repository.createPlanting(entity, file)).called(1);
      expect(result.isRight, true);
    });
  });
}
