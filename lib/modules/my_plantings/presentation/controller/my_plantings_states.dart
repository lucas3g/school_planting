import 'package:school_planting/modules/my_plantings/domain/entities/my_planting_entity.dart';

abstract class MyPlantingsStates {
  MyPlantingsLoadingState loading() => MyPlantingsLoadingState();
  MyPlantingsFailureState failure(String message) => MyPlantingsFailureState(message);
  MyPlantingsSuccessState success(List<MyPlantingEntity> plantings) =>
      MyPlantingsSuccessState(plantings);
}

class MyPlantingsInitialState extends MyPlantingsStates {}

class MyPlantingsLoadingState extends MyPlantingsStates {}

class MyPlantingsFailureState extends MyPlantingsStates {
  final String message;
  MyPlantingsFailureState(this.message);
}

class MyPlantingsSuccessState extends MyPlantingsStates {
  final List<MyPlantingEntity> plantings;
  MyPlantingsSuccessState(this.plantings);
}
