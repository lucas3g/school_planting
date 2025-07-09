import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/core/domain/entities/named_routes.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';
import 'package:school_planting/modules/home/presentation/controller/plantings_bloc.dart';
import 'package:school_planting/modules/home/presentation/controller/plantings_events.dart';
import 'package:school_planting/modules/home/presentation/controller/plantings_states.dart';
import 'package:school_planting/modules/home/presentation/widgets/controller/map_planting_controller.dart';
import 'package:school_planting/modules/home/presentation/widgets/modal_planting_info_widget.dart';
import 'package:school_planting/shared/components/app_circular_indicator_widget.dart';
import 'package:school_planting/shared/components/app_snackbar.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';

class MapPlantingWidget extends StatefulWidget {
  const MapPlantingWidget({super.key});

  @override
  State<MapPlantingWidget> createState() => _MapPlantingWidgetState();
}

class _MapPlantingWidgetState extends State<MapPlantingWidget> {
  final MapPlantingController _controller = getIt<MapPlantingController>();
  final PlantingsBloc _platingBloc = getIt<PlantingsBloc>();
  StreamSubscription<PlantingsStates>? _plantingSub;

  bool _loadingLocation = true;
  LatLng? _currentPosition;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(-15.7942, -47.8822),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
    _platingBloc.add(LoadPlantingsEvent());

    _listenPlantingStates();
  }

  void _listenPlantingStates() {
    _plantingSub = _platingBloc.stream.listen((state) {
      if (state is PlantingsSuccessState) {
        _controller.addPlantings(
          state.plantings,
          () => setState(() {}),
          _showDetail,
        );
      }
      if (state is PlantingsFailureState) {
        if (!mounted) return;

        showAppSnackbar(
          context,
          title: 'Erro',
          message: state.message,
          type: TypeSnack.error,
        );
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _loadingLocation = false;
      });
      return;
    }

    final Position current = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters
      ),
    );

    _currentPosition = LatLng(current.latitude, current.longitude);
    setState(() {
      _loadingLocation = false;
    });
  }

  void _showDetail(PlantingDetailEntity detail) {
    final tag = detail.imageUrl.split('/').last.split('?').first;

    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black54,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) =>
            ModalPlantingInfoWidget(detail: detail, tag: tag),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation =
              Tween<Offset>(
                begin: const Offset(0, 1), // de baixo para cima
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _platingBloc.close();
    _plantingSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingLocation) {
      return const Scaffold(body: Center(child: AppCircularIndicatorWidget()));
    }

    return BlocBuilder<PlantingsBloc, PlantingsStates>(
      bloc: _platingBloc,
      builder: (context, state) {
        if (state is! PlantingsSuccessState) {}

        return Scaffold(
          body: GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) async {
              _controller.googleMapController.complete(controller);
              if (_currentPosition != null) {
                final mapController =
                    await _controller.googleMapController.future;
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: _currentPosition!, zoom: 18),
                  ),
                );
              } else {
                _controller.moveCameraToCurrentLocation();
              }
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
          floatingActionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppThemeConstants.largeBorderRadius,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () async {
              await Navigator.pushNamed(context, NamedRoutes.planting.route);

              _platingBloc.add(LoadPlantingsEvent());
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.park_rounded, color: Colors.white),
                SizedBox(
                  height: 20,
                  child: VerticalDivider(color: Colors.white),
                ),
                Text(
                  'Plantar',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
