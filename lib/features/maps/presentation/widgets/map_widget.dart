import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracer_app/core/utils/constants.dart';

import '../../domain/user_location.dart';

class MapsView extends ConsumerStatefulWidget {
  const MapsView({super.key});

  @override
  ConsumerState<MapsView> createState() => MapsViewState();
}

class MapsViewState extends ConsumerState<MapsView> {
  late Completer<GoogleMapController> _controller;

  Map<PolylineId, Polyline> polylines = {};

  Future<void> cameraMove(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: latLng,
        zoom: 14.4746,
      ),
    ));
  }

  Future<List<LatLng>> getPolyLinePoints(
      LatLng origin, LatLng destination) async {
    List<LatLng> polyLineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: GOOGLE_MAPS_API_KEY,
        request: PolylineRequest(
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.driving,
        ));
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      log(result.errorMessage.toString());
    }
    return polyLineCoordinates;
  }

  void generatePolyLinesFromPoints(List<LatLng> polyLineCoordinates) {
    const PolylineId polylineId = PolylineId('poly');
    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: Colors.grey,
      points: polyLineCoordinates,
      width: 8,
    );
    // setState(() {
    polylines[polylineId] = polyline;
    // });
  }

  @override
  void initState() {
    super.initState();
    _controller = Completer<GoogleMapController>();
  }

  @override
  void dispose() {
    _controller.future.then((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserLocation>>(
        stream: FirebaseFirestore.instance
            .collectionGroup('Location')
            .orderBy('timestamp', descending: false)
            .snapshots()
            .map((event) => event.docs
                .map((e) => UserLocation.fromJson(e.data()))
                .toList()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final locations = snapshot.data ?? [];
          UserLocation? currentPosition;
          if (locations.isNotEmpty) {
            final firstLocation = locations.first;
            currentPosition = firstLocation;
            getPolyLinePoints(
                    LatLng(
                        locations.first.latitude!, locations.first.longitude!),
                    LatLng(locations.last.latitude!, locations.last.longitude!))
                .then(
                    (coordinates) => generatePolyLinesFromPoints(coordinates));
          }

          return _buildMap(currentPosition);
        });
  }

  Future<Set<Marker>> generateMarkers(List<UserLocation> positions) async {
    List<Marker> markers = <Marker>[];

    for (final location in positions) {
      const icon = BitmapDescriptor.defaultMarker;

      final marker = Marker(
        markerId: MarkerId(location.toString()),
        position: LatLng(location.latitude!, location.longitude!),
        icon: icon,
      );

      markers.add(marker);
    }

    return markers.toSet();
  }

  _buildMap(UserLocation? currentLocation) {
    return GoogleMap(
      markers: currentLocation != null
          ? {
              Marker(
                markerId: const MarkerId('current'),
                position: LatLng(
                  currentLocation.latitude!,
                  currentLocation.longitude!,
                ),
                icon: BitmapDescriptor.defaultMarker,
              )
            }
          : {},
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      polylines: Set<Polyline>.of(polylines.values),
      mapType: MapType.normal,
      rotateGesturesEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          currentLocation?.latitude ?? 27.7172,
          currentLocation?.longitude ?? 85.3240,
        ),
        zoom: 14.4746,
      ),
      onMapCreated: (GoogleMapController controller) async {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
      },
    );
  }
}
