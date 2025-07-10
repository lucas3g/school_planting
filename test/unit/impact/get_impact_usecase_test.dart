import 'package:flutter_test/flutter_test.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/impact/domain/entities/impact_entity.dart';
import 'package:school_planting/modules/impact/domain/usecases/get_impact_usecase.dart';

import '../../helpers/mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('GetImpactUseCase', () {
    late MockImpactRepository repository;
    late GetImpactUseCase usecase;

    setUp(() {
      repository = MockImpactRepository();
      usecase = GetImpactUseCase(repository: repository);
    });

    test('calls repository to get impact', () async {
      when(repository.getImpactData())
          .thenAnswer((_) async => resolve(ImpactEntity.fromCount(1)));

      final result = await usecase(const NoArgs());

      verify(repository.getImpactData()).called(1);
      expect(result.isRight, true);
    });
  });
}
