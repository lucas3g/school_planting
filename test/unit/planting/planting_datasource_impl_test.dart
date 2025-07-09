import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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
      when(
        client.uploadFile(
          bucket: anyNamed('bucket'),
          path: anyNamed('path'),
          file: anyNamed('file'),
        ),
      ).thenAnswer((_) async => {});
      when(
        client.insert(table: 'user_plantings', data: anyNamed('data')),
      ).thenAnswer((_) async => {});

      final file = File('tmp.txt');
      await file.writeAsString('x');

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
          file: anyNamed('file'),
        ),
      ).called(1);
      verify(
        client.insert(table: 'user_plantings', data: anyNamed('data')),
      ).called(1);
    });
  });
}
