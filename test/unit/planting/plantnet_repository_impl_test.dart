import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:school_planting/modules/planting/data/repositories/plantnet_repository_impl.dart';
import 'package:school_planting/modules/planting/domain/exceptions/plantnet_exception.dart';
import 'package:school_planting/modules/planting/domain/repositories/plantnet_repository.dart';

import '../../helpers/mocks.dart';

void main() {
  group('PlantNetRepositoryImpl', () {
    late MockPlantNetDatasource datasource;
    late PlantNetRepository repository;

    setUp(() {
      datasource = MockPlantNetDatasource();
      repository = PlantNetRepositoryImpl(datasource: datasource);
    });

    test('returns true when datasource success', () async {
      final file = File('x');

      when(datasource.isPlantImage(file)).thenAnswer((_) async => true);

      final result = await repository.isPlant(file);

      verify(datasource.isPlantImage(file)).called(1);
      expect(result.isRight, true);
    });

    test('returns failure on error', () async {
      final file = File('x');

      when(datasource.isPlantImage(file)).thenThrow(Exception('e'));

      final result = await repository.isPlant(file);

      expect(result.isLeft, true);
      result.get((failure) {
        expect(failure, isA<PlantNetException>());
        return null;
      }, (_) => null);
    });
  });
}
