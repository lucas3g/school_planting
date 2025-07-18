import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:school_planting/core/domain/entities/tables_db.dart';
import 'package:school_planting/modules/my_plantings/data/datasources/my_plantings_datasource_impl.dart';
import 'package:school_planting/modules/my_plantings/domain/entities/my_planting_entity.dart';

import '../../helpers/mocks.dart';

void main() {
  group('MyPlantingsDatasourceImpl', () {
    late MockISupabaseClient client;
    late MyPlantingsDatasourceImpl datasource;

    setUp(() {
      client = MockISupabaseClient();
      datasource = MyPlantingsDatasourceImpl(supabaseClient: client);
    });

    test('fetchMyPlantings parses data', () async {
      when(
        client.select(
          table: TablesDB.userInfoWithPlantings.name,
          columns:
              'description,image_url,lat,long,user_name,photourl,created_at',
          filters: {'user_id': '1'},
          orderBy: 'created_at',
        ),
      ).thenAnswer(
        (_) async => [
          {
            'description': 'd',
            'image_url': 'img.jpg',
            'lat': 1,
            'long': 2,
            'created_at': '2024-01-01T00:00:00Z',
          },
        ],
      );
      when(
        client.getImageUrl(
          bucket: 'escolaverdebucket',
          path: 'private/sdfsdgfdsfdsf',
        ),
      ).thenAnswer((_) async => 'url');

      final result = await datasource.fetchMyPlantings('1');

      expect(result, isA<List<MyPlantingEntity>>());
      expect(result.first.imageUrl, 'url');
      verify(
        client.select(
          table: TablesDB.userInfoWithPlantings.name,
          columns:
              'description,image_url,lat,long,user_name,photourl,created_at',
          filters: {'user_id': '1'},
          orderBy: 'created_at',
        ),
      ).called(1);
    });
  });
}
