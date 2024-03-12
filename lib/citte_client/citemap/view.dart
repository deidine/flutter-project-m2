import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'controller.dart';

class MapView extends GetView<MapController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Obx(
        () => controller.mapModel.isNotEmpty
            ? GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(controller.mapModel.first.latitude,
                      controller.mapModel.first.longitude),
                  zoom: 13,
                ),
                markers: controller.markers,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      )),
    );
  }
}




// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'controller.dart';
// import 'dart:async';

// class MapView extends GetView<MapController> {
//   @override
//   Widget build(BuildContext context) {
//     Completer<GoogleMapController> _controller = Completer();

//     Future<Position> getUserCurrentLocation() async {
//       LocationPermission permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         // Handle case when permission is not granted
//         return Future.error('Location permission not granted');
//       }
//       return await Geolocator.getCurrentPosition();
//     }

//     return Scaffold(
//       body: SafeArea(
//         child: Obx(
//           () => controller.mapModel.isNotEmpty
//               ? FutureBuilder<Position>(
//                   future: getUserCurrentLocation(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       final currentPosition = snapshot.data!;
//                       return GoogleMap(
//                         myLocationEnabled: true,
//                         compassEnabled: true,
//                         onMapCreated: (GoogleMapController controller) {
//                           _controller.complete(controller);
//                         },
//                         initialCameraPosition: CameraPosition(
//                           target: LatLng(currentPosition.latitude,
//                               currentPosition.longitude),
//                           zoom: 13,
//                         ),
//                         markers: controller.markers,
//                       );
//                     } else if (snapshot.hasError) {
//                       // Handle error
//                       return Center(
//                         child: Text('Error: ${snapshot.error}'),
//                       );
//                     } else {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                   },
//                 )
//               : Center(
//                   child: CircularProgressIndicator(),
//                 ),
//         ),
//       ),
//     );
//   }
// }
