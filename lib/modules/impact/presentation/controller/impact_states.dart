import '../../domain/entities/impact_entity.dart';

abstract class ImpactStates {
  ImpactLoadingState loading() => ImpactLoadingState();
  ImpactFailureState failure(String message) => ImpactFailureState(message);
  ImpactSuccessState success(ImpactEntity data) => ImpactSuccessState(data);
}

class ImpactInitialState extends ImpactStates {}

class ImpactLoadingState extends ImpactStates {}

class ImpactFailureState extends ImpactStates {
  final String message;
  ImpactFailureState(this.message);
}

class ImpactSuccessState extends ImpactStates {
  final ImpactEntity metrics;
  ImpactSuccessState(this.metrics);
}
