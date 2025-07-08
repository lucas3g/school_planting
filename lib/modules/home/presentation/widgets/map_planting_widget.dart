import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:school_planting/modules/home/presentation/widgets/controller/map_planting_controller.dart';

class MapPlantingWidget extends StatefulWidget {
  const MapPlantingWidget({super.key});

  @override
  State<MapPlantingWidget> createState() => _MapPlantingWidgetState();
}

class _MapPlantingWidgetState extends State<MapPlantingWidget> {
  final MapPlantingController _controller = MapPlantingController();

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(-15.7942, -47.8822),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) {
          _controller.googleMapController.complete(controller);
          _controller.moveCameraToCurrentLocation();
        },
        mapType: MapType.normal,
        markers: _controller.markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        trafficEnabled: true,
        buildingsEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
      ),
    );
  }
}
