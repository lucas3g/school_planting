import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:school_planting/core/domain/entities/app_assets.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';

@injectable
class MapPlantingController {
  final Set<Marker> markers = {};
  final Completer<GoogleMapController> googleMapController = Completer();

  MapPlantingController();

  Future<BitmapDescriptor> _getMarkerIcon() async {
    return BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(50, 50)),
      AppAssets.marker,
    );
  }

  Future<void> startLocationUpdates(VoidCallback onUpdated) async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final Position current = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
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
      final BitmapDescriptor icon = await _getMarkerIcon();
      final Marker marker = Marker(
        markerId: MarkerId(item.imageUrl),
        position: LatLng(item.lat, item.long),
        icon: icon,
        onTap: () async {
          final controller = await googleMapController.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(item.lat, item.long), zoom: 18),
            ),
          );
          onUpdated();
          onTap(item);
        },
        // infoWindow: InfoWindow(
        //   title: item.userName,
        //   snippet: item.description,
        // ),
      );
      markers.add(marker);
    }

    onUpdated();
  }

  Future<void> moveCameraToCurrentLocation({double zoom = 18}) async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final Position current = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    final LatLng pos = LatLng(current.latitude, current.longitude);

    final controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: zoom)),
    );
  }

  void dispose() {}
}
