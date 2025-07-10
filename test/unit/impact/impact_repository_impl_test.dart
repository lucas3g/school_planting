import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/modules/auth/domain/entities/user_entity.dart';
import 'package:school_planting/modules/impact/data/repositories/impact_repository_impl.dart';
import 'package:school_planting/modules/impact/domain/repositories/impact_repository.dart';

import '../../helpers/mocks.dart';

void main() {
  group('ImpactRepositoryImpl', () {
    late MockImpactDatasource datasource;
    late ImpactRepository repository;

    setUp(() {
      datasource = MockImpactDatasource();
      repository = ImpactRepositoryImpl(datasource: datasource);
      AppGlobal(user: UserEntity(id: '1', email: '', name: ''));
    });

    test('returns metrics on success', () async {
      when(datasource.countPlantings('1')).thenAnswer((_) async => 2);

      final result = await repository.getImpactData();

      verify(datasource.countPlantings('1')).called(1);
      expect(result.isRight, true);
    });
  });
}
