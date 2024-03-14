import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mapgoog/app/data/model/venue/venue_response.dart';
import 'package:mapgoog/app/data/provider/api_provider.dart';
import 'package:mapgoog/app/routes/app_pages.dart';
import 'package:mapgoog/citte_client/all_venue/controllers/all_venue_controller.dart';
import 'package:mapgoog/citte_client/booking_field/widgets/dialog_venue_map.dart';
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
    mapModel.asMap().forEach((index, element) {
      markers.add(Marker(
        onTap: () {
          showModel(element.id);
        },
        markerId: MarkerId(element.id.toString()),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(element.latitude, element.longitude),
        infoWindow: InfoWindow(
            title: element.venueName,
            snippet:
                "address:${element.address} nom du cite: ${element.venueName} "),
      ));
    });
  }

  showModel(int id) {
    VenueResponse? foundItem;
    for (VenueResponse item in venueController.venues) {
      if (item.idVenue == id) {
        foundItem = item;
        break; // Exit the loop once the item is found
      }
  }
      final dialogModel = DialogContentMapVenueModel(
        id: id,
        adress: foundItem!.location,
        onConfirm: () {
          final arguments = {
            'infoVenue': foundItem!,
            'isEditReservation': false,
            'transactionId': 0,
          };
          Get.toNamed(Routes.BOOKING_FIELD, arguments: arguments);
        },
        pricePerHour: foundItem!.pricePerHour.toString(),
        venueName: foundItem!.venueName,
      );
      showOrderDialogSummary(dialogModel);
  
  }
}
