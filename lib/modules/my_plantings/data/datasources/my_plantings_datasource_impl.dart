import 'package:injectable/injectable.dart';
import 'package:school_planting/core/data/clients/supabase/supabase_client_interface.dart';
import 'package:school_planting/core/domain/entities/tables_db.dart';
import 'package:school_planting/modules/my_plantings/domain/entities/my_planting_entity.dart';

import 'my_plantings_datasource.dart';

@Injectable(as: MyPlantingsDatasource)
class MyPlantingsDatasourceImpl implements MyPlantingsDatasource {
  final ISupabaseClient _client;

  MyPlantingsDatasourceImpl({required ISupabaseClient supabaseClient})
    : _client = supabaseClient;

  @override
  Future<List<MyPlantingEntity>> fetchMyPlantings(String userId) async {
    final List<dynamic> data = await _client.select(
      table: TablesDB.userInfoWithPlantings.name,
      columns: 'description,image_url,lat,long,user_name,photourl,created_at',
      filters: {'user_id': userId},
      orderBy: 'created_at',
    );

    final List<MyPlantingEntity> result = [];

    for (final item in data) {
      final String imageName = item['image_url'] as String;

      final String url = await _client.getImageUrl(
        bucket: 'escolaverdebucket',
        path: 'private/$imageName',
      );

      result.add(
        MyPlantingEntity(
          description: item['description'] as String? ?? '',
          imageUrl: url,
          lat: (item['lat'] as num).toDouble(),
          long: (item['long'] as num).toDouble(),
          createdAt: DateTime.parse(item['created_at'] as String),
        ),
      );
    }

    return result;
  }
}
