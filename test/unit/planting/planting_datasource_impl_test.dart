import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:school_planting/core/domain/entities/tables_db.dart';
import 'package:school_planting/modules/planting/data/datasources/planting_datasource_impl.dart';

import '../../helpers/mocks.dart';

void main() {
  group('PlantingDatasourceImpl', () {
    late MockISupabaseClient client;
    late PlantingDatasourceImpl datasource;

    setUp(() {
      client = MockISupabaseClient();
      datasource = PlantingDatasourceImpl(supabaseClient: client);
    });

    test('upload and insert are called', () async {
      final file = File('tmp.txt');
      await file.writeAsString('x');

      when(
        client.uploadFile(
          bucket: 'escolaverdebucket',
          path: 'private/img',
          file: file,
        ),
      ).thenAnswer((_) async => {});
      when(
        client.insert(
          table: TablesDB.plantings.name,
          data: {
            'user_id': '1',
            'description': 'd',
            'image_url': 'img',
            'lat': 1,
            'long': 2,
          },
        ),
      ).thenAnswer((_) async => {});

      await datasource.createPlanting(
        userId: '1',
        description: 'd',
        image: file,
        imageName: 'img',
        lat: 1,
        long: 2,
      );

      verify(
        client.uploadFile(
          bucket: 'escolaverdebucket',
          path: 'private/img',
          file: file,
        ),
      ).called(1);
      verify(
        client.insert(
          table: TablesDB.plantings.name,
          data: {
            'user_id': '1',
            'description': 'd',
            'image_url': 'img',
            'lat': 1,
            'long': 2,
          },
        ),
      ).called(1);
    });
  });
}
