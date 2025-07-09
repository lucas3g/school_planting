import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';
import 'package:school_planting/modules/my_plantings/domain/usecases/get_my_plantings_usecase.dart';

import 'my_plantings_events.dart';
import 'my_plantings_states.dart';

@injectable
class MyPlantingsBloc extends Bloc<MyPlantingsEvents, MyPlantingsStates> {
  final GetMyPlantingsUseCase _usecase;

  MyPlantingsBloc({required GetMyPlantingsUseCase usecase})
      : _usecase = usecase,
        super(MyPlantingsInitialState()) {
    on<LoadMyPlantingsEvent>(_onLoadMyPlantings);
  }

  Future<void> _onLoadMyPlantings(
    LoadMyPlantingsEvent event,
    Emitter<MyPlantingsStates> emit,
  ) async {
    emit(state.loading());

    final result = await _usecase(const NoArgs());

    result.get(
      (failure) => emit(state.failure(failure.message)),
      (data) => emit(state.success(data)),
    );
  }
}
