import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:school_planting/modules/impact/data/datasources/impact_datasource_impl.dart';

import '../../helpers/mocks.dart';

void main() {
  group('ImpactDatasourceImpl', () {
    late MockISupabaseClient client;
    late ImpactDatasourceImpl datasource;

    setUp(() {
      client = MockISupabaseClient();
      datasource = ImpactDatasourceImpl(supabaseClient: client);
    });

    test('countPlantings returns length', () async {
      when(
        client.select(
          table: 'user_plantings',
          columns: 'id',
          filters: {'user_id': '1'},
        ),
      ).thenAnswer((_) async => [1, 2, 3]);

      final result = await datasource.countPlantings('1');

      expect(result, 3);
      verify(
        client.select(
          table: 'user_plantings',
          columns: 'id',
          filters: {'user_id': '1'},
        ),
      ).called(1);
    });
  });
}
