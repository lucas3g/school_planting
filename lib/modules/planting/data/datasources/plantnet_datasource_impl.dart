import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/core/data/clients/http/client_http.dart';

import 'plantnet_datasource.dart';

@Injectable(as: PlantNetDatasource)
class PlantNetDatasourceImpl implements PlantNetDatasource {
  final ClientHttp _client;

  PlantNetDatasourceImpl({required ClientHttp client}) : _client = client {
    _client.setBaseUrl(PLANTNET_BASE_URL);
  }

  @override
  Future<bool> isPlantImage(File image) async {
    final bytes = await Isolate.run(() async {
      final bytes = await image.readAsBytes();

      return bytes;
    });

    final formData = FormData.fromMap({
      'organs': 'auto',
      'images': MultipartFile.fromBytes(
        bytes,
        filename: image.path.split('/').last,
      ),
    });

    final response = await _client.postFile(
      '/identify/all?api-key=$PLANTNET_API_KEY',
      data: formData,
    );

    if (response.statusCode == HttpStatus.notFound) {
      throw Exception('Foto não é uma planta, flor ou árvore');
    }

    final data = response.data;
    final results = data?['results'] as List?;
    return results != null && results.isNotEmpty;
  }
}
