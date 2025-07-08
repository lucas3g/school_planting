import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlantingDetail {
  final String description;
  final String imageUrl;
  final String userName;
  final String userImageUrl;

  PlantingDetail({
    required this.description,
    required this.imageUrl,
    required this.userName,
    required this.userImageUrl,
  });
}

class MapPlantingController {
  final Set<Marker> markers = {};
  final Completer<GoogleMapController> googleMapController = Completer();
  StreamSubscription<Position>? _positionStream;

  Future<BitmapDescriptor> _getCircularAvatarMarkerIcon(
    String imageUrl, {
    int size = 80,
  }) async {
    final HttpClient httpClient = HttpClient();
    final HttpClientRequest request = await httpClient.getUrl(Uri.parse(imageUrl));
    final HttpClientResponse response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);

    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: size,
      targetHeight: size,
    );
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Image avatarImage = frame.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final double radius = size / 2;

    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      Paint()..color = Colors.white,
    );

    canvas.save();
    canvas.clipPath(
      Path()
        ..addOval(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius - 4),
        ),
    );
    canvas.drawImage(avatarImage, Offset.zero, Paint());
    canvas.restore();

    final ui.Image finalImage = await recorder.endRecording().toImage(
      size,
      size,
    );
    final ByteData? byteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  // Future<BitmapDescriptor> _getCircularAvatarMarkerIcon(
  //   String imageUrl, {
  //   int size = 80,
  // }) async {
  //   final ClientHttp clientHttp = getIt<ClientHttp>();
  //   final HttpResponseEntity<dynamic> response = await clientHttp.getImage(
  //     imageUrl,
  //   );
  //   final Uint8List imageBytes = response.data;

  //   final ui.Codec codec = await ui.instantiateImageCodec(
  //     imageBytes,
  //     targetWidth: size,
  //     targetHeight: size,
  //   );
  //   final ui.FrameInfo frame = await codec.getNextFrame();
  //   final ui.Image avatarImage = frame.image;

  //   final ui.PictureRecorder recorder = ui.PictureRecorder();
  //   final Canvas canvas = Canvas(recorder);
  //   final Paint paint = Paint();
  //   final double radius = size / 2;

  //   canvas.drawCircle(
  //     Offset(radius, radius),
  //     radius,
  //     Paint()..color = Colors.white,
  //   );

  //   canvas.save();
  //   canvas.clipPath(
  //     Path()..addOval(
  //       Rect.fromCircle(center: Offset(radius, radius), radius: radius - 4),
  //     ),
  //   );
  //   canvas.drawImage(avatarImage, Offset.zero, paint);
  //   canvas.restore();

  //   final ui.Image finalImage = await recorder.endRecording().toImage(
  //     size,
  //     size,
  //   );
  //   final ByteData? byteData = await finalImage.toByteData(
  //     format: ui.ImageByteFormat.png,
  //   );
  //   return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  // }

  Future<void> startLocationUpdates(VoidCallback onUpdated) async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever)
      return;

    // final BitmapDescriptor icon = await _getCircularAvatarMarkerIcon(
    //   AppGlobal.instance.user!.imageUrl.value,
    // );

    final Position current = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final LatLng pos = LatLng(current.latitude, current.longitude);

    markers
      ..clear()
      ..add(
        Marker(markerId: const MarkerId('current_position'), position: pos),
      );

    final controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 18)),
    );

    onUpdated();

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 0,
          ),
        ).listen((Position position) async {
          final LatLng pos = LatLng(position.latitude, position.longitude);

          markers
            ..clear()
            ..add(
              Marker(
                markerId: const MarkerId('current_position'),
                position: pos,
              ),
            );

          final controller = await googleMapController.future;
          controller.animateCamera(CameraUpdate.newLatLng(pos));

          onUpdated(); // Notifica a View para atualizar
        });
  }

  Future<void> loadPlantings(
    VoidCallback onUpdated,
    void Function(PlantingDetail) onTap,
  ) async {
    final List<dynamic> data = await Supabase.instance.client
        .from('user_plantings')
        .select(
            'description,image_url,lat,long,user_name,user_image_url')
        .order('created_at');

    for (final item in data) {
      final double lat = (item['lat'] as num).toDouble();
      final double long = (item['long'] as num).toDouble();
      final String imageName = item['image_url'] as String;
      final String url = Supabase.instance.client.storage
          .from('escolaverdebucket')
          .getPublicUrl('private/$imageName');

      final BitmapDescriptor icon = await _getCircularAvatarMarkerIcon(url);

      final detail = PlantingDetail(
        description: item['description'] as String? ?? '',
        imageUrl: url,
        userName: item['user_name'] as String? ?? '',
        userImageUrl: item['user_image_url'] as String? ?? '',
      );

      markers.add(
        Marker(
          markerId: MarkerId(imageName),
          position: LatLng(lat, long),
          icon: icon,
          infoWindow: InfoWindow(
            title: detail.userName,
            snippet: detail.description,
            onTap: () => onTap(detail),
          ),
        ),
      );
    }

    onUpdated();
  }

  Future<void> moveCameraToCurrentLocation({double zoom = 18}) async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    final Position current = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final LatLng pos = LatLng(current.latitude, current.longitude);

    final controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: zoom)),
    );
  }

  void dispose() {
    _positionStream?.cancel();
  }
}
