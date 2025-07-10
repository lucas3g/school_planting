import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/shared/components/app_circular_indicator_widget.dart';
import 'package:school_planting/shared/components/custom_app_bar.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

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

  Widget _buildItem(
    String label,
    String value,
    IconData icon, {
    Color? color,
    String? description,
  }) {
    final background = color?.withAlpha((0.15 * 255).round());

    return Card(
      color: background,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: AppThemeConstants.mediumPadding),
                Expanded(child: Text(label)),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (description != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(int count) {
    final String text =
        'Você já realizou $count ${count == 1 ? 'plantação' : 'plantações'}!\n\n Veja como isso ajuda o planeta:';
    return Expanded(
      child: Card(
        color: Colors.lightBlue.withAlpha((0.15 * 255).round()),
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
              final oxygenPeople = (m.oxygen / 240).round();
              final avoidedKm = (m.carbon * 350 / 88).round();
              final waterTanks = (m.water / 200).round();
              final beeVisits = (m.totalPlantings * 16);
              final purifiers = (m.totalPlantings / 5).round();

              String textTemp = m.temperature <= 0.3
                  ? 'Reduz a sensação térmica ao redor da planta'
                  : m.temperature >= 0.4 && m.temperature <= 0.6
                  ? 'Equivale à sombra de uma árvore em dia quente'
                  : m.temperature >= 0.6 && m.temperature <= 9
                  ? 'Ajuda a refrescar o ambiente como 1 ventilador'
                  : 'Ajuda a refrescar o ambiente como 1 ar-condicionado';

              return Padding(
                padding: const EdgeInsets.all(AppThemeConstants.padding),
                child: SuperListView(
                  shrinkWrap: true,
                  children: [
                    Row(children: [_buildSummary(m.totalPlantings)]),
                    _buildItem(
                      'Oxigênio gerado',
                      '${m.oxygen.toStringAsFixed(1)} kg/ano',
                      Icons.air,
                      color: Colors.green,
                      description:
                          'Oxigênio para $oxygenPeople pessoas por 2 anos.',
                    ),
                    _buildItem(
                      'Carbono capturado (CO₂)',
                      '${m.carbon.toStringAsFixed(1)} kg/ano',
                      Icons.co2,
                      color: Colors.grey,
                      description: '$avoidedKm km de carro evitados.',
                    ),
                    _buildItem(
                      'Redução de temperatura',
                      '${m.temperature.toStringAsFixed(1)} °C',
                      color: Colors.cyan,
                      Icons.thermostat,
                      description: textTemp,
                    ),
                    _buildItem(
                      'Retenção de água e solo',
                      '${m.water.toStringAsFixed(1)} L/ano',
                      Icons.water_drop,
                      color: Colors.blue,
                      description: '$waterTanks caixa(s) d\'água de reserva.',
                    ),
                    _buildItem(
                      'Biodiversidade (ex: abelhas e polinizadores)',
                      '${m.biodiversity.toStringAsFixed(1)} pts',
                      Icons.bug_report,
                      color: Colors.orange,
                      description:
                          'Atrai até $beeVisits visita${beeVisits == 1 ? '' : 's'} de abelhas por mês.',
                    ),
                    _buildItem(
                      'Melhoria na qualidade do ar',
                      '${m.airQuality.toStringAsFixed(1)} pts',
                      Icons.air_outlined,
                      color: Colors.blueGrey,
                      description:
                          'Equivale a usar $purifiers purificador${purifiers == 1 ? '' : 'es'} de ar por 24h.',
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
