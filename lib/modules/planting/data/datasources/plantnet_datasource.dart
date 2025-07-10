import 'dart:io';

abstract class PlantNetDatasource {
  Future<bool> isPlantImage(File image);
}
