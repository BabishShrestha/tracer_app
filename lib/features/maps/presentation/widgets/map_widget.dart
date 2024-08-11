import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracer_app/features/user/domain/app_user.dart';

class MapsView extends ConsumerStatefulWidget {
  const MapsView({super.key});

  @override
  ConsumerState<MapsView> createState() => MapsViewState();
}

class MapsViewState extends ConsumerState<MapsView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(27.7172, 85.3240),
  //   zoom: 14.4746,
  // );
// 27.7172° N, 85.3240° E

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AppUser>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .snapshots()
              .map((event) => AppUser.fromJson(event.docs.first.data())),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return GoogleMap(
              myLocationEnabled: true,
              markers: {
                Marker(
                  markerId: const MarkerId('1'),
                  position: LatLng(
                    snapshot.data?.latitude ?? 27.7172,
                    snapshot.data?.longitude ?? 85.3240,
                  ),
                  icon: BitmapDescriptor.defaultMarker,
                ),
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              mapType: MapType.normal,
              rotateGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  snapshot.data?.latitude ?? 27.7172,
                  snapshot.data?.longitude ?? 85.3240,
                ),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          }),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    try {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
    } catch (e) {
      log('Error loading asset: $e');
      // Provide fallback bytes or handle the error as needed.
      return Uint8List(0);
    }
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.bytes(imageData);
  }

  // Future<Set<Marker>> generateStaffMarkers(List<LatLng> positions) async {
  //   List<Marker> markers = <Marker>[];

  //   for (final location in positions) {
  //     // final icon =
  //     //     await getBitmapDescriptorFromAssetBytes(UIImagePath.vendorTeam, 100);

  //     final marker = Marker(
  //       markerId: MarkerId(location.toString()),
  //       position: LatLng(location.latitude, location.longitude),
  //       infoWindow: const InfoWindow(title: "Staff", snippet: "Vendor Team"),
  //       // icon: icon,
  //     );

  //     markers.add(marker);
  //   }

  //   return markers.toSet();
  // }

  // GoogleMap _buildGoogleMap(Set<Marker> markers) {
  //   return GoogleMap(
  //     myLocationEnabled: true,
  //     markers: markers,
  //     gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
  //       Factory<OneSequenceGestureRecognizer>(
  //         () => EagerGestureRecognizer(),
  //       ),
  //     },
  //     mapType: MapType.normal,
  //     rotateGesturesEnabled: true,
  //     initialCameraPosition: _kGooglePlex,
  //     onMapCreated: (GoogleMapController controller) {
  //       _controller.complete(controller);
  //     },
  //   );
  // }
}
