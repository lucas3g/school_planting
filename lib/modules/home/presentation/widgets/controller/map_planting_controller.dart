import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:school_planting/core/data/clients/http/client_http.dart';
import 'package:school_planting/core/domain/entities/response_entity.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';

@injectable
class MapPlantingController {
  final ClientHttp httpClient;

  final Set<Marker> markers = {};
  final Completer<GoogleMapController> googleMapController = Completer();
  final Map<String, PlantingDetailEntity> _plantings = {};
  final Map<String, Uint8List> _imageCache = {};
  String? _selectedMarkerId;

  MapPlantingController({required this.httpClient});

  Future<BitmapDescriptor> _getRoundedAvatarMarkerIcon(
    String imageUrl, {
    int size = 40,
    Color borderColor = Colors.grey,
  }) async {
    Uint8List bytes;
    if (_imageCache.containsKey(imageUrl)) {
      bytes = _imageCache[imageUrl]!;
    } else {
      final HttpResponseEntity<dynamic> response = await httpClient.getImage(
        imageUrl,
      );
      final dynamic data = response.data;
      if (data is Uint8List) {
        bytes = data;
      } else if (data is List<int>) {
        bytes = Uint8List.fromList(data);
      } else {
        throw Exception('Unsupported image data type');
      }
      _imageCache[imageUrl] = bytes;
    }

    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: size,
      targetHeight: size,
    );
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Image avatarImage = frame.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    const double borderWidth = 3;
    const double radius = 8;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        const Radius.circular(radius),
      ),
      Paint()..color = borderColor,
    );

    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          borderWidth,
          borderWidth,
          size - borderWidth * 2,
          size - borderWidth * 2,
        ),
        const Radius.circular(radius - 1),
      ),
    );
    canvas.drawImageRect(
      avatarImage,
      Rect.fromLTWH(
        0,
        0,
        avatarImage.width.toDouble(),
        avatarImage.height.toDouble(),
      ),
      Rect.fromLTWH(
        borderWidth,
        borderWidth,
        size - borderWidth * 2,
        size - borderWidth * 2,
      ),
      Paint(),
    );
    canvas.restore();

    final ui.Image finalImage = await recorder.endRecording().toImage(
      size,
      size,
    );
    final ByteData? byteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  Future<void> startLocationUpdates(VoidCallback onUpdated) async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final Position current = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final LatLng pos = LatLng(current.latitude, current.longitude);

    final controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 18)),
    );

    onUpdated();
  }

  Future<void> addPlantings(
    List<PlantingDetailEntity> plantings,
    VoidCallback onUpdated,
    void Function(PlantingDetailEntity) onTap,
  ) async {
    for (final item in plantings) {
      final BitmapDescriptor icon = await _getRoundedAvatarMarkerIcon(
        item.imageUrl,
        borderColor: Colors.grey,
      );
      _plantings[item.imageUrl] = item;

      markers.add(
        Marker(
          markerId: MarkerId(item.imageUrl),
          position: LatLng(item.latitude, item.longitude),
          icon: icon,
          onTap: () async {
            final controller = await googleMapController.future;
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(item.latitude, item.longitude),
                  zoom: 18,
                ),
              ),
            );
            _selectedMarkerId = item.imageUrl;
            await _updateMarkerIcons();
            onUpdated();
            onTap(item);
          },
          infoWindow: InfoWindow(
            title: item.userName,
            snippet: item.description,
          ),
        ),
      );
    }

    onUpdated();
  }

  Future<void> _updateMarkerIcons() async {
    final Set<Marker> updated = {};
    for (final entry in _plantings.entries) {
      final oldMarker = markers.firstWhere(
        (m) => m.markerId.value == entry.key,
      );
      final bool isSelected = entry.key == _selectedMarkerId;
      final icon = await _getRoundedAvatarMarkerIcon(
        entry.value.imageUrl,
        borderColor: isSelected ? Colors.green : Colors.grey,
      );
      updated.add(oldMarker.copyWith(iconParam: icon));
    }
    markers
      ..clear()
      ..addAll(updated);
  }

  Future<void> moveCameraToCurrentLocation({double zoom = 18}) async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final Position current = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final LatLng pos = LatLng(current.latitude, current.longitude);

    final controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: zoom)),
    );
  }

  void dispose() {}
}
