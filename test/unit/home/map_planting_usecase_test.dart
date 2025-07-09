import 'package:flutter_test/flutter_test.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';
import 'package:school_planting/modules/home/domain/usecases/get_plantings_usecase.dart';

import '../../helpers/mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('GetPlantingsUseCase', () {
    late MockMapPlantingRepository repository;
    late GetPlantingsUseCase usecase;

    setUp(() {
      repository = MockMapPlantingRepository();
      usecase = GetPlantingsUseCase(repository: repository);
    });

    test('calls repository to get plantings', () async {
      when(repository.getPlantings())
          .thenAnswer((_) async => resolve(<PlantingDetailEntity>[]));

      final result = await usecase(const NoArgs());

      verify(repository.getPlantings()).called(1);
      expect(result.isRight, true);
    });
  });
}
