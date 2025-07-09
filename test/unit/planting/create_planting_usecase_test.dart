import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/modules/planting/domain/entities/planting_entity.dart';
import 'package:school_planting/modules/planting/domain/usecases/create_planting_usecase.dart';

import '../../helpers/mocks.dart';

void main() {
  group('CreatePlantingUseCase', () {
    late MockPlantingRepository repository;
    late CreatePlantingUseCase usecase;

    setUp(() {
      repository = MockPlantingRepository();
      usecase = CreatePlantingUseCase(repository: repository);
    });

    test('calls repository to create planting', () async {
      final entity = PlantingEntity(
        description: '',
        imageName: '',
        userId: '',
        latitude: 0,
        longitude: 0,
      );
      final file = File('test.txt');

      when(
        repository.createPlanting(entity, file),
      ).thenAnswer((_) async => resolve(const VoidSuccess()));

      final params = CreatePlantingParams(entity: entity, image: file);

      final result = await usecase(params);

      verify(repository.createPlanting(entity, file)).called(1);
      expect(result.isRight, true);
    });
  });
}
