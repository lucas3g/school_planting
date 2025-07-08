import 'package:injectable/injectable.dart';
import 'package:school_planting/core/data/clients/supabase/supabase_client_interface.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';

import 'map_planting_datasource.dart';

@Injectable(as: MapPlantingDatasource)
class MapPlantingDatasourceImpl implements MapPlantingDatasource {
  final ISupabaseClient _client;

  MapPlantingDatasourceImpl({required ISupabaseClient supabaseClient})
    : _client = supabaseClient;

  @override
  Future<List<PlantingDetailEntity>> fetchPlantings() async {
    final List<dynamic> data = await _client.select(
      table: 'user_plantings_with_userinfo',
      columns: 'description,image_url,lat,long,user_name,photourl',
    );

    final List<PlantingDetailEntity> result = [];

    for (final item in data) {
      final String imageName = item['image_url'] as String;

      final String url = await _client.getImageUrl(
        bucket: 'escolaverdebucket',
        path: 'private/$imageName',
      );

      result.add(
        PlantingDetailEntity(
          description: item['description'] as String? ?? '',
          imageUrl: url,
          userName: item['user_name'] as String? ?? '',
          userImageUrl: item['photourl'] as String? ?? '',
          latitude: (item['lat'] as num).toDouble(),
          longitude: (item['long'] as num).toDouble(),
        ),
      );
    }

    return result;
  }
}
