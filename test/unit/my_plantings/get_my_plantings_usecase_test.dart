import 'package:flutter_test/flutter_test.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/my_plantings/domain/entities/my_planting_entity.dart';
import 'package:school_planting/modules/my_plantings/domain/usecases/get_my_plantings_usecase.dart';

import '../../helpers/mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('GetMyPlantingsUseCase', () {
    late MockMyPlantingsRepository repository;
    late GetMyPlantingsUseCase usecase;

    setUp(() {
      repository = MockMyPlantingsRepository();
      usecase = GetMyPlantingsUseCase(repository: repository);
    });

    test('calls repository to fetch plantings', () async {
      when(repository.getMyPlantings())
          .thenAnswer((_) async => resolve(<MyPlantingEntity>[]));

      final result = await usecase(const NoArgs());

      verify(repository.getMyPlantings()).called(1);
      expect(result.isRight, true);
    });
  });
}
