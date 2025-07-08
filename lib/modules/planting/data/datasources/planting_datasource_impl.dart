import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'planting_datasource.dart';

@Injectable(as: PlantingDatasource)
class PlantingDatasourceImpl implements PlantingDatasource {
  final SupabaseClient _client;

  PlantingDatasourceImpl() : _client = Supabase.instance.client;

  @override
  Future<void> createPlanting({
    required String userId,
    required String description,
    required File image,
    required String imageName,
    required double latitude,
    required double longitude,
  }) async {
    await _client.storage
        .from('escolaverdebucket')
        .upload('private/$imageName', image);

    await _client.from('user_plantings').insert({
      'user_id': userId,
      'description': description,
      'image_url': imageName,
      'lat': latitude,
      'long': longitude,
    });
  }
}
