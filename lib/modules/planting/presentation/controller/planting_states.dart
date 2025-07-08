abstract class PlantingStates {
  PlantingLoadingState loading() => PlantingLoadingState();
  PlantingSuccessState success() => PlantingSuccessState();
  PlantingFailureState failure(String message) => PlantingFailureState(message);
}

class PlantingInitialState extends PlantingStates {}

class PlantingLoadingState extends PlantingStates {}

class PlantingSuccessState extends PlantingStates {}

class PlantingFailureState extends PlantingStates {
  final String message;
  PlantingFailureState(this.message);
}
