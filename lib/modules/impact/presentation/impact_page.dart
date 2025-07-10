import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/core/data/clients/supabase/supabase_client_interface.dart';
import 'package:school_planting/shared/components/app_circular_indicator_widget.dart';
import 'package:school_planting/shared/components/custom_app_bar.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';

import '../domain/usecases/get_impact_usecase.dart';
import '../data/repositories/impact_repository_impl.dart';
import '../data/datasources/impact_datasource_impl.dart';
import 'controller/impact_bloc.dart';
import 'controller/impact_events.dart';
import 'controller/impact_states.dart';

class ImpactPage extends StatefulWidget {
  const ImpactPage({super.key});

  @override
  State<ImpactPage> createState() => _ImpactPageState();
}

class _ImpactPageState extends State<ImpactPage> {
  late final ImpactBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ImpactBloc(
      usecase: GetImpactUseCase(
        repository: ImpactRepositoryImpl(
          datasource: ImpactDatasourceImpl(
            supabaseClient: getIt<ISupabaseClient>(),
          ),
        ),
      ),
    );
    _bloc.add(LoadImpactEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Widget _buildItem(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Impacto Ambiental')),
      body: SafeArea(
        child: BlocBuilder<ImpactBloc, ImpactStates>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is ImpactLoadingState) {
              return const Center(child: AppCircularIndicatorWidget());
            }
            if (state is ImpactSuccessState) {
              final m = state.metrics;
              return Padding(
                padding: const EdgeInsets.all(AppThemeConstants.padding),
                child: Column(
                  children: [
                    _buildItem('Oxig\u00eanio gerado', m.oxygen.toStringAsFixed(1), Icons.air),
                    _buildItem('Carbono sequestrado (CO\u2082)', m.carbon.toStringAsFixed(1), Icons.co2),
                    _buildItem('Redu\u00e7\u00e3o de temperatura', m.temperature.toStringAsFixed(1), Icons.thermostat),
                    _buildItem('Reten\u00e7\u00e3o de \u00e1gua e solo', m.water.toStringAsFixed(1), Icons.water_drop),
                    _buildItem('Biodiversidade', m.biodiversity.toStringAsFixed(1), Icons.bug_report),
                    _buildItem('Melhoria na qualidade do ar', m.airQuality.toStringAsFixed(1), Icons.air_outlined),
                  ],
                ),
              );
            }
            if (state is ImpactFailureState) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
