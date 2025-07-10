import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/shared/components/app_circular_indicator_widget.dart';
import 'package:school_planting/shared/components/custom_app_bar.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';

import 'controller/impact_bloc.dart';
import 'controller/impact_events.dart';
import 'controller/impact_states.dart';

class ImpactPage extends StatefulWidget {
  const ImpactPage({super.key});

  @override
  State<ImpactPage> createState() => _ImpactPageState();
}

class _ImpactPageState extends State<ImpactPage> {
  final ImpactBloc _impactBloc = getIt<ImpactBloc>();

  @override
  void initState() {
    super.initState();

    _impactBloc.add(LoadImpactEvent());
  }

  @override
  void dispose() {
    _impactBloc.close();
    super.dispose();
  }

  Widget _buildItem(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSummary(int count) {
    final String text =
        'Você já realizou $count ${count == 1 ? 'plantação' : 'plantações'}! Veja como isso ajuda o planeta:';
    return Card(
      margin: const EdgeInsets.only(bottom: AppThemeConstants.padding),
      child: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Impacto Ambiental')),
      body: SafeArea(
        child: BlocBuilder<ImpactBloc, ImpactStates>(
          bloc: _impactBloc,
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
                      _buildSummary(m.totalPlantings),
                    _buildItem(
                      'Oxigênio gerado',
                      '${m.oxygen.toStringAsFixed(1)} kg/ano',
                      Icons.air,
                    ),
                    _buildItem(
                      'Carbono capturado (CO₂)',
                      '${m.carbon.toStringAsFixed(1)} kg/ano',
                      Icons.co2,
                    ),
                    _buildItem(
                      'Redução de temperatura',
                      '${m.temperature.toStringAsFixed(1)} °C',
                      Icons.thermostat,
                    ),
                    _buildItem(
                      'Retenção de água e solo',
                      '${m.water.toStringAsFixed(1)} L/ano',
                      Icons.water_drop,
                    ),
                    _buildItem(
                      'Biodiversidade (ex: abelhas e polinizadores)',
                      '${m.biodiversity.toStringAsFixed(1)} pts',
                      Icons.bug_report,
                    ),
                    _buildItem(
                      'Melhoria na qualidade do ar',
                      '${m.airQuality.toStringAsFixed(1)} pts',
                      Icons.air_outlined,
                    ),
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
