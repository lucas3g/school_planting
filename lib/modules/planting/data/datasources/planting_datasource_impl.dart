import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:school_planting/core/data/clients/supabase/supabase_client_interface.dart';
import 'package:school_planting/shared/utils/image_utils.dart';

import 'planting_datasource.dart';

@Injectable(as: PlantingDatasource)
class PlantingDatasourceImpl implements PlantingDatasource {
  final ISupabaseClient _client;

  PlantingDatasourceImpl({required ISupabaseClient supabaseClient})
    : _client = supabaseClient;

  @override
  Future<void> createPlanting({
    required String userId,
    required String description,
    required File image,
    required String imageName,
    required double lat,
    required double long,
  }) async {
    final File compressed = await compressImage(image);

    await _client.uploadFile(
      bucket: 'escolaverdebucket',
      path: 'private/$imageName',
      file: compressed,
    );

    await _client.insert(
      table: 'user_plantings',
      data: {
        'user_id': userId,
        'description': description,
        'image_url': imageName,
        'lat': lat,
        'long': long,
      },
    );
  }
}
