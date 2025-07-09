// ignore_for_file: public_member_api_docs, sort_constructors_first
class PlantingDetailEntity {
  final String description;
  final String imageUrl;
  final String userName;
  final String userImageUrl;
  final double lat;
  final double long;
  final DateTime createdAt;

  const PlantingDetailEntity({
    required this.description,
    required this.imageUrl,
    required this.userName,
    required this.userImageUrl,
    required this.lat,
    required this.long,
    required this.createdAt,
  });
}
