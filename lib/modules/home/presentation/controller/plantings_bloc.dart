import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/home/domain/usecases/get_plantings_usecase.dart';
import 'plantings_events.dart';
import 'plantings_states.dart';

class PlantingsBloc extends Bloc<PlantingsEvents, PlantingsStates> {
  final GetPlantingsUseCase _usecase;

  PlantingsBloc({required GetPlantingsUseCase usecase})
      : _usecase = usecase,
        super(PlantingsInitialState()) {
    on<LoadPlantingsEvent>(_onLoadPlantings);
  }

  Future<void> _onLoadPlantings(
      LoadPlantingsEvent event, Emitter<PlantingsStates> emit) async {
    emit(state.loading());

    final result = await _usecase(const NoArgs());

    result.get(
      (failure) => emit(state.failure(failure.message)),
      (data) => emit(state.success(data)),
    );
  }
}
