import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../app/data/model/reservation/reservation_response.dart';
import '../../../app/data/model/reservation/user_reservation_model.dart';
import '../../../app/data/model/user/user_response.dart';
import '../../../app/data/model/venue/venue_response.dart';
import '../../../app/data/service/reservation_service.dart';
import '../../../app/data/service/user_service.dart';
import '../../all_venue/controllers/all_venue_controller.dart';
import '../../home/controllers/home_controller.dart';

class HistoryBookingController extends GetxController with StateMixin {
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

  void firstTimeFetchData() async {
    change(false, status: RxStatus.loading());

    final username = homeController.username;
    dataUser =  homeController.dataUser!;

    fetchData().then((_) {
      updateBookedFields();
      change(true, status: RxStatus.success());
    });
  }

  VenueResponse? getDetailVenue(int idVenue) {
    if (allvenueController.venues.isNotEmpty) {
      return allvenueController.venues
          .where((element) => element.idVenue == idVenue)
          .first;
    }
    return null;
  }

  int getPricePerHour(int? idVenue) => getDetailVenue(idVenue!)!.pricePerHour;

  String getVenueName(int? idVenue) => getDetailVenue(idVenue!)!.venueName;

  String getVenueImage(int? idVenue) => getDetailVenue(idVenue!)!.image;

  void updateBookedFields() {
    bookedFieldsModel.value = reservations.map(
      (element) {
        element.hours;

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

  Future<void> fetchData() async {
    final userId = dataUser.idUser;
    reservations.value =
        await ReservationService.getReservationListByUserId(userId).then(
      (value) => value.where((element) => element.status == 'invalid').toList(),
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
