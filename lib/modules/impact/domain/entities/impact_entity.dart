class ImpactEntity {
  final double oxygen;
  final double carbon;
  final double temperature;
  final double water;
  final double biodiversity;
  final double airQuality;
  final int totalPlantings;

  ImpactEntity({
    required this.oxygen,
    required this.carbon,
    required this.temperature,
    required this.water,
    required this.biodiversity,
    required this.airQuality,
    required this.totalPlantings,
  });

  factory ImpactEntity.fromCount(int count) {
    const double oxygenPerPlant = 120.0;
    const double carbonPerPlant = 22.0;
    const double temperaturePerPlant = 0.1;
    const double waterPerPlant = 50.0;
    const double biodiversityPerPlant = 1.0;
    const double airQualityPerPlant = 1.0;

    return ImpactEntity(
      oxygen: oxygenPerPlant * count,
      carbon: carbonPerPlant * count,
      temperature: temperaturePerPlant * count,
      water: waterPerPlant * count,
      biodiversity: biodiversityPerPlant * count,
      airQuality: airQualityPerPlant * count,
      totalPlantings: count,
    );
  }
}
