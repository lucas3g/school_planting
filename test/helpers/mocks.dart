import 'package:mockito/mockito.dart';
import 'package:school_planting/core/data/clients/supabase/supabase_client_interface.dart';
import 'package:school_planting/modules/auth/data/datasources/auth_datasource.dart';
import 'package:school_planting/modules/auth/domain/repositories/auth_repository.dart';
import 'package:school_planting/modules/home/data/datasources/map_planting_datasource.dart';
import 'package:school_planting/modules/home/domain/repositories/map_planting_repository.dart';
import 'package:school_planting/modules/my_plantings/data/datasources/my_plantings_datasource.dart';
import 'package:school_planting/modules/my_plantings/domain/repositories/my_plantings_repository.dart';
import 'package:school_planting/modules/planting/data/datasources/planting_datasource.dart';
import 'package:school_planting/modules/planting/domain/repositories/planting_repository.dart';
import 'package:school_planting/modules/impact/data/datasources/impact_datasource.dart';
import 'package:school_planting/modules/impact/domain/repositories/impact_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockAuthDatasource extends Mock implements AuthDatasource {}
class MockISupabaseClient extends Mock implements ISupabaseClient {}
class MockMapPlantingRepository extends Mock implements MapPlantingRepository {}
class MockMapPlantingDatasource extends Mock implements MapPlantingDatasource {}
class MockMyPlantingsRepository extends Mock implements MyPlantingsRepository {}
class MockMyPlantingsDatasource extends Mock implements MyPlantingsDatasource {}
class MockPlantingRepository extends Mock implements PlantingRepository {}
class MockPlantingDatasource extends Mock implements PlantingDatasource {}
class MockSupabaseUser extends Mock implements User {}
class MockImpactDatasource extends Mock implements ImpactDatasource {}
class MockImpactRepository extends Mock implements ImpactRepository {}
