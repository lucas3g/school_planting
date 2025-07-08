import 'package:injectable/injectable.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'map_planting_datasource.dart';

@Injectable(as: MapPlantingDatasource)
class MapPlantingDatasourceImpl implements MapPlantingDatasource {
  @override
  Future<List<PlantingDetailEntity>> fetchPlantings() async {
    final List<dynamic> data = await Supabase.instance.client
        .from('user_plantings')
        .select('description,image_url,lat,long,user_name,user_image_url')
        .order('created_at');

    final List<PlantingDetailEntity> result = [];
    for (final item in data) {
      final String imageName = item['image_url'] as String;
      final String url = Supabase.instance.client.storage
          .from('escolaverdebucket')
          .getPublicUrl('private/$imageName');
      result.add(
        PlantingDetailEntity(
          description: item['description'] as String? ?? '',
          imageUrl: url,
          userName: item['user_name'] as String? ?? '',
          userImageUrl: item['user_image_url'] as String? ?? '',
          latitude: (item['lat'] as num).toDouble(),
          longitude: (item['long'] as num).toDouble(),
        ),
      );
    }

    return result;
  }
}
