import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mapgoog/app/data/enum/venue_category_enum.dart';
import 'package:mapgoog/app/data/model/user/user_response.dart';
import 'package:mapgoog/app/data/model/venue/venue_response.dart';
import 'package:mapgoog/app/data/service/reservation_service.dart';
import 'package:mapgoog/citte_client/all_venue/controllers/all_venue_controller.dart';
import 'package:mapgoog/citte_client/home/controllers/home_controller.dart';
import 'package:mapgoog/app/routes/app_pages.dart';

import '../../../app/core/themes/custom_snackbar_theme.dart';
import '../../../app/data/model/reservation/reservation_response.dart';
import '../../../app/data/model/reservation/user_reservation_model.dart';

class ActiveBookingController extends GetxController with StateMixin {
  final homeController = Get.find<HomeController>();
  final allvenueController = Get.find<AllVenueController>();

  final refreshController = RefreshController();

  var reservations = <ReservationResponse>[].obs;
  var bookedFieldsModel = <UserReservation>[].obs;

  late final UserResponse dataUser;

  @override
  void onReady() {
    firstTimeFetchData();

    super.onReady();
  }

  void handlePaymentReservation(UserReservation reservation) {
   
    final VenueResponse infoVenue = VenueResponse(
      idVenue: reservation.venueId,
      location: '',
      venueName: reservation.venueName,
      pricePerHour: reservation.pricePerHour,
      category: VenueCategory.basket,
      rating: 0,
      image: '',
    );

    // id tx
    final idTx = reservation.transactionId;

    final arguments = {
      'infoVenue': infoVenue,
      'isPaymentReservation': true,
      'transactionId': idTx,
    };
print("deidine payment");

// Get.to(() => PaymentView(), arguments: arguments);

    Get.toNamed(Routes.PAYMENT , arguments: arguments);
  }

  void handleCancelReservation(String transactionId) {
    Get.defaultDialog(
      title: 'Cancel Reservation',
      middleText: 'Are you sure you want to cancel this reservation?',
      onConfirm: () => requestCancelReservation(transactionId),
      textConfirm: 'Yes',
      confirmTextColor: Colors.white,
      textCancel: 'Cancel',
    );
  }

  void requestCancelReservation(String transactionId) {
    ReservationService.cancelReservation(transactionId).then((_) {
      Get.back();

      CustomSnackbar.successSnackbar(
        title: 'Success',
        message: 'Success cancel reservation',
      );

      handleRefresh();
    });
  }

  void updateBookedFields() {
    bookedFieldsModel.value = reservations.map(
      (element) {
        // element.hours.sort();

        return UserReservation(
          venueId: element.venueId!,
          transactionId: element.transactionId!,
          venueName: getVenueName(element.venueId),
          pricePerHour: getPricePerHour(element.venueId),
          totalPrice: element.totalPrice,
          hours: element.hours,
          bookingTime: element.bookingTime,
          playTime: element.beginTime,
          imageLink: getVenueImage(element.venueId),
        );
      },
    ).toList();
    refresh();
  }

  int getPricePerHour(int? idVenue) => getDetailVenue(idVenue!)!.pricePerHour;

  String getVenueName(int? idVenue) => getDetailVenue(idVenue!)!.venueName;

  String getVenueImage(int? idVenue) => getDetailVenue(idVenue!)!.image;

  VenueResponse? getDetailVenue(int idVenue) {
    if (allvenueController.venues.isNotEmpty) {
      return allvenueController.venues
          .where((element) => element.idVenue == idVenue)
          .first;
    }
    return null;
  }

  void firstTimeFetchData()   {
    change(false, status: RxStatus.loading());

    dataUser      =  homeController.dataUser!;

    fetchData().then((_) {
      updateBookedFields();
      change(true, status: RxStatus.success());
    });
  }

  Future<void> fetchData() async {
    final userId = dataUser.idUser;
    reservations.value =
        await ReservationService.getReservationListByUserId(userId).then(
      (value) => value.where((element) => element.status == 'valid').toList(),
    );
  }

  void handleRefresh() async {
    refreshController.requestRefresh();
    fetchData().then((_) {
      updateBookedFields();
      refreshController.refreshCompleted();
    });
  }
}
