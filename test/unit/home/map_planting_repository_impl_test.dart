import 'package:flutter_test/flutter_test.dart';
import 'package:school_planting/modules/home/data/repositories/map_planting_repository_impl.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';
import 'package:school_planting/modules/home/domain/exceptions/home_exception.dart';
import 'package:school_planting/modules/home/domain/repositories/map_planting_repository.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';

import '../../helpers/mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('MapPlantingRepositoryImpl', () {
    late MockMapPlantingDatasource datasource;
    late MapPlantingRepository repository;

    setUp(() {
      datasource = MockMapPlantingDatasource();
      repository = MapPlantingRepositoryImpl(datasource: datasource);
    });

    test('returns plantings on success', () async {
      when(datasource.fetchPlantings())
          .thenAnswer((_) async => <PlantingDetailEntity>[]);

      final result = await repository.getPlantings();

      verify(datasource.fetchPlantings()).called(1);
      expect(result.isRight, true);
    });

    test('returns failure on error', () async {
      when(datasource.fetchPlantings()).thenThrow(Exception('err'));

      final result = await repository.getPlantings();

      expect(result.isLeft, true);
      result.get((failure) {
        expect(failure, isA<HomeException>());
        return null;
      }, (_) => null);
    });
  });
}
