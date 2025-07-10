import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:school_planting/modules/planting/domain/usecases/create_planting_usecase.dart';
import 'package:school_planting/modules/planting/domain/usecases/validate_plant_image_usecase.dart';
import 'package:school_planting/modules/planting/presentation/controller/planting_events.dart';
import 'package:school_planting/modules/planting/presentation/controller/planting_states.dart';

@injectable
class PlantingBloc extends Bloc<PlantingEvents, PlantingStates> {
  final CreatePlantingUseCase _createUseCase;
  final ValidatePlantImageUseCase _validateUseCase;

  PlantingBloc({
    required CreatePlantingUseCase createPlantingUseCase,
    required ValidatePlantImageUseCase validatePlantImageUseCase,
  }) : _createUseCase = createPlantingUseCase,
       _validateUseCase = validatePlantImageUseCase,
       super(PlantingInitialState()) {
    on<CreatePlantingEvent>(_onCreatePlanting);
  }

  Future<void> _onCreatePlanting(
    CreatePlantingEvent event,
    Emitter<PlantingStates> emit,
  ) async {
    emit(state.loading());

    final validation = await _validateUseCase(event.image);

    validation.get(
      (failure) => emit(state.failure(failure.message)),
      (_) => emit(state.success()),
    );

    final result = await _createUseCase(
      CreatePlantingParams(entity: event.entity, image: event.image),
    );

    result.get(
      (failure) => emit(state.failure(failure.message)),
      (_) => emit(state.success()),
    );
  }
}
