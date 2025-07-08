class PlantingDetailEntity {
  final String description;
  final String imageUrl;
  final String userName;
  final String userImageUrl;
  final double latitude;
  final double longitude;

  const PlantingDetailEntity({
    required this.description,
    required this.imageUrl,
    required this.userName,
    required this.userImageUrl,
    required this.latitude,
    required this.longitude,
  });
}
