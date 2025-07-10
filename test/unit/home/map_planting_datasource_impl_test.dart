import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:school_planting/core/domain/entities/tables_db.dart';
import 'package:school_planting/modules/home/data/datasources/map_planting_datasource_impl.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';

import '../../helpers/mocks.dart';

void main() {
  group('MapPlantingDatasourceImpl', () {
    late MockISupabaseClient client;
    late MapPlantingDatasourceImpl datasource;

    setUp(() {
      client = MockISupabaseClient();
      datasource = MapPlantingDatasourceImpl(supabaseClient: client);
    });

    test('fetchPlantings parses data correctly', () async {
      when(
        client.select(
          table: TablesDB.userInfoWithPlantings.name,
          columns:
              'description,image_url,lat,long,user_name,photourl,created_at',
        ),
      ).thenAnswer(
        (_) async => [
          {
            'description': 'd',
            'image_url': 'img.jpg',
            'user_name': 'u',
            'photourl': 'p',
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

      final result = await datasource.fetchPlantings();

      expect(result, isA<List<PlantingDetailEntity>>());
      expect(result.first.imageUrl, 'url');
      verify(
        client.select(
          table: TablesDB.userInfoWithPlantings.name,
          columns:
              'description,image_url,lat,long,user_name,photourl,created_at',
        ),
      ).called(1);
    });
  });
}
