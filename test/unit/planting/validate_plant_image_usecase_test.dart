import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/modules/planting/domain/usecases/validate_plant_image_usecase.dart';

import '../../helpers/mocks.dart';

void main() {
  group('ValidatePlantImageUseCase', () {
    late MockPlantNetRepository repository;
    late ValidatePlantImageUseCase usecase;

    setUp(() {
      repository = MockPlantNetRepository();
      usecase = ValidatePlantImageUseCase(repository: repository);
    });

    test('calls repository to validate image', () async {
      final file = File('img');

      when(repository.isPlant(file)).thenAnswer((_) async => resolve(true));

      final result = await usecase(file);

      verify(repository.isPlant(file)).called(1);
      expect(result.isRight, true);
    });
  });
}
