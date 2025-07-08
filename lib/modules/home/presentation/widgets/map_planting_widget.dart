import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';
import 'package:school_planting/modules/home/presentation/controller/plantings_bloc.dart';
import 'package:school_planting/modules/home/presentation/controller/plantings_events.dart';
import 'package:school_planting/modules/home/presentation/controller/plantings_states.dart';
import 'package:school_planting/modules/home/presentation/widgets/controller/map_planting_controller.dart';

class MapPlantingWidget extends StatefulWidget {
  const MapPlantingWidget({super.key});

  @override
  State<MapPlantingWidget> createState() => _MapPlantingWidgetState();
}

class _MapPlantingWidgetState extends State<MapPlantingWidget> {
  final MapPlantingController _controller = MapPlantingController();
  final PlantingsBloc _bloc = getIt<PlantingsBloc>();

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(-15.7942, -47.8822),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();

    _controller.startLocationUpdates(() => setState(() {}));
    _bloc.add(LoadPlantingsEvent());
  }

  void _showDetail(PlantingDetailEntity detail) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  detail.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(detail.userImageUrl),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      detail.userName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(detail.description),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<PlantingsBloc, PlantingsStates>(
        listener: (context, state) {
          if (state is PlantingsSuccessState) {
            _controller.addPlantings(
              state.plantings,
              () => setState(() {}),
              _showDetail,
            );
          }
        },
        child: Scaffold(
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
        ),
      ),
    );
  }
}
