import 'package:injectable/injectable.dart';
import 'package:school_planting/core/data/clients/supabase/supabase_client_interface.dart';

import 'impact_datasource.dart';

@Injectable(as: ImpactDatasource)
class ImpactDatasourceImpl implements ImpactDatasource {
  final ISupabaseClient _client;

  ImpactDatasourceImpl({required ISupabaseClient supabaseClient})
      : _client = supabaseClient;

  @override
  Future<int> countPlantings(String userId) async {
    final data = await _client.select(
      table: 'user_plantings',
      columns: 'id',
      filters: {'user_id': userId},
    );
    return data.length;
  }
}
