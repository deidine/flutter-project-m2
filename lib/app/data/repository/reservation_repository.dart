import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mapgoog/app/data/model/reservation/reservation_response.dart';
import 'package:mapgoog/app/data/model/reservation/schedule_request.dart';
import 'package:mapgoog/app/data/provider/api_provider.dart';

abstract class ReservationRepository {
  static final getConnect = GetConnect();

  static Future<List<ReservationResponse>> getSchedule(
      ScheduleRequest request) async {
    print("booking function$request");

    // return req.body['data'].cast<int>();

    var url = Uri.parse(
        '${ApiProvider.getSchedule}?venueId=${request.venueId}&date=${request.date}');
        // '${ApiProvider.getSchedule}?venueId=${request.venueId}&date=${request.date}&begin=${request.begin}&end=${request.end}');

    final req = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    // final List<VenueResponse> data =response.body['data'];
    List<ReservationResponse> getData = [];
    var _extractedData = json.decode(req.body) as List;
    if (_extractedData == null) {}
    getData = _extractedData
        .map<ReservationResponse>((json) => ReservationResponse.fromJson(json))
        .toList();
    print("je suios od");
    return getData;
  }

  static Future<List<ReservationResponse>> getReservationListByUserId(
      int userId) async {
    var url = Uri.parse('${ApiProvider.getReservationById}$userId/');

    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    print("la reponse du venu${response}");

    // final List<VenueResponse> data =response.body['data'];
    List<ReservationResponse> getData = [];
    var _extractedData = json.decode(response.body) as List;
    if (_extractedData == null) {}
    getData = _extractedData
        .map<ReservationResponse>((json) => ReservationResponse.fromJson(json))
        .toList();
    print("je suios od");
    return getData;
  }

  static Future<void> cancelReservation(String idTransaction) async {
    try {
      final url = '${ApiProvider.cancelReservation}$idTransaction';

      await getConnect.delete(url);
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> createReservation(ReservationResponse request) async {
    Response<dynamic> req;

    try {
      req = await getConnect.post(
          ApiProvider.createReservation, request.createReservationToJson());
      print(req.statusCode);
      print(req);
      if (req.statusCode == 201) {
        print('reservetion created successfully');
      } else {
        print('Failed to create reservation');
      }
    } catch (e) {
      throw Exception('Failed to send request');
    }
  }

  static Future<void> updateReservation(ReservationResponse request) async {
    try {
      const url = ApiProvider.updateReservation;
      await getConnect.put(url, request.updateReservationToJson());
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<List<int>> getScheduleExcludeTxId(
      ScheduleRequest request) async {
    //   return req.body['data'].cast<int>();
    // }
    var url = Uri.parse(
        '${ApiProvider.getSchedule}?venueId=${request.venueId}&date=${request.date}&begin=${request.begin}&end=${request.end}');

    final req = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    print("la reponse du venu${req}");

    List<int> getData = [];
    var _extractedData = json.decode(req.body) as List<int>;
    if (_extractedData == null) {}
    getData = _extractedData.toList();
    print("je suios od$getData");
    return getData;
  }
}
