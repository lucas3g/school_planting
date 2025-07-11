// ignore_for_file: public_member_api_docs, sort_constructors_first
class ImpactMetrics {
  final double oxygen; // em kg
  final double carbon; // em kg
  final double water; // em litros
  final double temperature; // em °C
  final int totalPlantings;

  ImpactMetrics({
    required this.oxygen,
    required this.carbon,
    required this.water,
    required this.temperature,
    required this.totalPlantings,
  });
}

class ImpactMetricsFormatter {
  final ImpactMetrics metrics;

  ImpactMetricsFormatter(this.metrics);

  /// Pessoas que respiram com o oxigênio gerado
  int get oxygenPeople {
    const oxygenPerPerson = 80.0; // kg por pessoa por ano
    return (metrics.oxygen / oxygenPerPerson).floor();
  }

  /// Km que seriam evitados com o CO₂ capturado
  int get avoidedKm {
    const co2Per350Km = 88.0; // 88kg CO₂ = 350km
    return ((metrics.carbon / co2Per350Km) * 350).round();
  }

  /// Caixas d'água de 200L que a planta ajuda a reter
  int get waterTanks {
    const tankLiters = 200.0;
    return (metrics.water / tankLiters).round();
  }

  /// Estimativa de visitas de abelhas ou espécies polinizadoras beneficiadas
  int get beeVisits {
    return metrics.totalPlantings * 16; // simbólico
  }

  /// Quantos purificadores equivalentes em uso
  int get purifiers {
    return (metrics.totalPlantings / 5)
        .round()
        .clamp(1, double.infinity)
        .toInt();
  }

  /// Texto de temperatura baseado no valor
  String get temperatureImpact {
    final t = metrics.temperature;

    if (t <= 0.3) {
      return 'Reduz a sensação térmica ao redor da planta';
    } else if (t <= 0.6) {
      return 'Equivale à sombra de uma árvore em dia quente';
    } else if (t <= 9) {
      return 'Ajuda a refrescar o ambiente como 1 ventilador';
    } else {
      return 'Ajuda a refrescar o ambiente como 1 ar-condicionado';
    }
  }
}
