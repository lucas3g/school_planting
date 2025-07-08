import 'dart:io';

abstract class PlantingDatasource {
  Future<void> createPlanting({
    required String userId,
    required String description,
    required File image,
    required String imageName,
  });
}
