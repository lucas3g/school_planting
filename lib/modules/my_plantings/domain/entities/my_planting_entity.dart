class MyPlantingEntity {
  final String description;
  final String imageUrl;
  final double lat;
  final double long;
  final DateTime createdAt;

  const MyPlantingEntity({
    required this.description,
    required this.imageUrl,
    required this.lat,
    required this.long,
    required this.createdAt,
  });
}
