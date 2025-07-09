import 'package:flutter_test/flutter_test.dart';
import 'package:school_planting/modules/my_plantings/data/datasources/my_plantings_datasource_impl.dart';
import 'package:school_planting/modules/my_plantings/domain/entities/my_planting_entity.dart';
import 'package:mockito/mockito.dart';

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
      when(client.select(
        table: anyNamed('table'),
        columns: anyNamed('columns'),
        filters: anyNamed('filters'),
        orderBy: anyNamed('orderBy'),
      )).thenAnswer((_) async => [
            {
              'description': 'd',
              'image_url': 'img.jpg',
              'lat': 1,
              'long': 2,
              'created_at': '2024-01-01T00:00:00Z'
            }
          ]);
      when(client.getImageUrl(
        bucket: anyNamed('bucket'),
        path: anyNamed('path'),
      )).thenAnswer((_) async => 'url');

      final result = await datasource.fetchMyPlantings('1');

      expect(result, isA<List<MyPlantingEntity>>());
      expect(result.first.imageUrl, 'url');
      verify(client.select(table: 'user_plantings_with_userinfo',
              columns: 'description,image_url,lat,long,user_name,photourl,created_at',
              filters: {'user_id': '1'},
              orderBy: 'created_at'))
          .called(1);
    });
  });
}
