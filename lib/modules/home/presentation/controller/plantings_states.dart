import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';

abstract class PlantingsStates {
  PlantingsLoadingState loading() => PlantingsLoadingState();
  PlantingsFailureState failure(String message) => PlantingsFailureState(message);
  PlantingsSuccessState success(List<PlantingDetailEntity> plantings) =>
      PlantingsSuccessState(plantings);
}

class PlantingsInitialState extends PlantingsStates {}

class PlantingsLoadingState extends PlantingsStates {}

class PlantingsFailureState extends PlantingsStates {
  final String message;
  PlantingsFailureState(this.message);
}

class PlantingsSuccessState extends PlantingsStates {
  final List<PlantingDetailEntity> plantings;
  PlantingsSuccessState(this.plantings);
}
