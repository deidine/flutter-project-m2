import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mapgoog/app/data/provider/api_provider.dart';
import 'package:mapgoog/app/routes/app_pages.dart';
import 'package:mapgoog/citte_client/all_venue/controllers/all_venue_controller.dart';
import 'model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapController extends GetxController with StateMixin {
  List<MapModel> mapModel = <MapModel>[].obs;
  var markers = RxSet<Marker>();
  var isLoading = false.obs;
  final venueController = Get.find<AllVenueController>();

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  fetchLocations() async {
    try {
      isLoading(true);
      http.Response response =
          await http.get(Uri.tryParse('${ApiProvider.map}')!);
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        log(result.toString());
        mapModel.addAll(RxList<Map<String, dynamic>>.from(result)
            .map((e) => MapModel.fromJson(e))
            .toList());
      } else {
        print('error fetching data');
      }
    } catch (e) {
      print('Error while getting data is $e');
    } finally {
      isLoading(false);
      print('finaly: $mapModel');
      createMarkers();
    }
  }

  createMarkers() {
    mapModel.forEach((element) {
      markers.add(Marker(        onTap: () {
          toBookingFieldPage(element.venueId);
        },
        markerId: MarkerId(element.id.toString()),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(element.latitude, element.longitude),
        infoWindow: InfoWindow(
            title: element.venueName,
            snippet: "address:${element.address} nom du cite: ${element.venueName} "),

      ));
    });
  }

  void toBookingFieldPage(int venueId) {
    final arguments = {
      'infoVenue': venueController.venues[venueId],
      'isEditReservation': false,
      'transactionId': 0,
    };

    Get.toNamed(Routes.BOOKING_FIELD, arguments: arguments);
  }
}
