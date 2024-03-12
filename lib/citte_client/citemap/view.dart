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
