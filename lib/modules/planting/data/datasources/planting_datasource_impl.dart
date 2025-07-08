import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'planting_datasource.dart';

@LazySingleton(as: PlantingDatasource)
class PlantingDatasourceImpl implements PlantingDatasource {
  final SupabaseClient _client;

  PlantingDatasourceImpl() : _client = Supabase.instance.client;

  @override
  Future<void> createPlanting({
    required String userId,
    required String description,
    required File image,
    required String imageName,
  }) async {
    await _client.storage.from('escolaverdebucket').upload(imageName, image);

    await _client.from('user_plantings').insert({
      'user_id': userId,
      'description': description,
      'image_name': imageName,
    });
  }
}
