import 'package:flutter_test/flutter_test.dart';
import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';
import 'package:school_planting/modules/my_plantings/data/repositories/my_plantings_repository_impl.dart';
import 'package:school_planting/modules/my_plantings/domain/entities/my_planting_entity.dart';
import 'package:school_planting/modules/my_plantings/domain/repositories/my_plantings_repository.dart';

import '../../helpers/mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('MyPlantingsRepositoryImpl', () {
    late MockMyPlantingsDatasource datasource;
    late MyPlantingsRepository repository;

    setUp(() {
      datasource = MockMyPlantingsDatasource();
      repository = MyPlantingsRepositoryImpl(datasource: datasource);
      AppGlobal(user: UserEntity(id: '1', email: 'e', name: 'n'));
    });

    test('returns plantings on success', () async {
      when(datasource.fetchMyPlantings(any))
          .thenAnswer((_) async => <MyPlantingEntity>[]);

      final result = await repository.getMyPlantings();

      verify(datasource.fetchMyPlantings('1')).called(1);
      expect(result.isRight, true);
    });
  });
}
