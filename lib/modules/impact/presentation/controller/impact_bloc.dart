import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/usecase.dart';

import '../../domain/usecases/get_impact_usecase.dart';
import 'impact_events.dart';
import 'impact_states.dart';

@injectable
class ImpactBloc extends Bloc<ImpactEvents, ImpactStates> {
  final GetImpactUseCase _usecase;

  ImpactBloc({required GetImpactUseCase usecase})
    : _usecase = usecase,
      super(ImpactInitialState()) {
    on<LoadImpactEvent>(_onLoadImpact);
  }

  Future<void> _onLoadImpact(
    LoadImpactEvent event,
    Emitter<ImpactStates> emit,
  ) async {
    emit(state.loading());

    final result = await _usecase(const NoArgs());

    result.get(
      (failure) => emit(state.failure(failure.message)),
      (data) => emit(state.success(data)),
    );
  }
}
