import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:school_planting/core/di/dependency_injection.config.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/auth/domain/usecases/auto_login.dart';
import 'package:school_planting/modules/planting/data/datasources/planting_datasource.dart';
import 'package:school_planting/modules/planting/data/datasources/planting_datasource_impl.dart';
import 'package:school_planting/modules/planting/data/repositories/planting_repository_impl.dart';
import 'package:school_planting/modules/planting/domain/repositories/planting_repository.dart';
import 'package:school_planting/modules/planting/domain/usecases/create_planting_usecase.dart';
import 'package:school_planting/modules/planting/presentation/controller/planting_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  _initAppGlobal();

  await getIt.init();

  getIt
    ..registerFactory<PlantingDatasource>(() => PlantingDatasourceImpl())
    ..registerFactory<PlantingRepository>(
        () => PlantingRepositoryImpl(datasource: getIt<PlantingDatasource>()))
    ..registerFactory<CreatePlantingUseCase>(
        () => CreatePlantingUseCase(repository: getIt<PlantingRepository>()))
    ..registerFactory<PlantingBloc>(
        () => PlantingBloc(createPlantingUseCase: getIt<CreatePlantingUseCase>()));

  await _tryAutoLogin();
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  Dio get dio => _dioFactory();
}

Dio _dioFactory() {
  final BaseOptions baseOptions = BaseOptions(
    headers: <String, dynamic>{'Content-Type': 'application/json'},
  );

  return Dio(baseOptions);
}

void _initAppGlobal() {
  AppGlobal(user: null);
}

Future<void> _tryAutoLogin() async {
  final AutoLoginUseCase autoLoginUsecase = getIt<AutoLoginUseCase>();

  await autoLoginUsecase(const NoArgs());
}
