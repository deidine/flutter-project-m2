import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mapgoog/app/core/themes/custom_snackbar_theme.dart';
import 'package:mapgoog/app/data/model/reservation/reservation_response.dart';
import 'package:mapgoog/app/data/model/user/user_response.dart';
import 'package:mapgoog/app/data/service/booking_service.dart';
import 'package:get/get.dart';
import 'package:mapgoog/app/data/enum/venue_category_enum.dart';
import 'package:mapgoog/app/data/model/venue/venue_response.dart';
import 'package:mapgoog/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../owner_home/controllers/home_owner_controller.dart';

class AllBookingController extends GetxController with StateMixin {
  final refreshController = RefreshController();
  late final VenueResponse infoVenue;

  late DateTime selectedDateTimeFromCalander = DateTime.now();
  var bookings=<ReservationResponse>[].obs;
  var bookingPerdate=<ReservationResponse>[].obs;
  var filteredVenues = <VenueResponse>[].obs;
  final homeController = Get.find<HomeOwnerController>();
  // var bookings = <ReservationResponse>[].obs;
  late List<UserResponse>? dataUsers;
  late final venuId;
  late UserResponse user;
  final DateFormat timeFormat = DateFormat('HH:mm');
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void onInit() {
    parsingArgument();
    fetchData();
    super.onInit();
    print("deidine");

    fetchUserData();
  }

  void parsingArgument() {
    infoVenue = Get.arguments['infoVenue'];
  }

  List<ReservationResponse>? searchBooking(String value) {
    print("${value} search booking ${bookings!.isNotEmpty}");
    if (bookings!.isNotEmpty) {
       
      return bookings!
          .where((element) =>
              element.bookingTime.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    return null;
  }

  UserResponse? getDetailUser(int id) {
    if (dataUsers!.isNotEmpty) {
      return dataUsers!.where((element) => element.idUser == id).first;
    }
    return null;
  }

  UserResponse? getDetailUserEdit() {
    // late final UserResponse infoUser;
    UserResponse infoUser = Get.arguments['infoUser'];
    late int id = Get.arguments['userId'];
    return infoUser;
  }

  ReservationResponse? getDetailBookingEdit() {
    ReservationResponse infoBooking = Get.arguments['infoBooking'];
    late int id = Get.arguments['userId'];
    // print(infoUser.idUser);
    return infoBooking;
  }

  void toBookingFieldPage(int userId, ReservationResponse bookings) {
    UserResponse? user = getDetailUser(userId);
    //  ReservationResponse?  bookings;

    final arguments = {
      'infoUser': user,
      'infoBooking': bookings,
      'userId': userId,
    };
    Get.toNamed(Routes.ALL_PAYMENT, arguments: arguments);
  }
 

  void fetchUserData() async {
    change(false, status: RxStatus.loading());
    dataUsers = await BookingService.getReservationListByUser();
    
    change(true, status: RxStatus.success());
  }

  Future<void> fetchData() async {
    change(false, status: RxStatus.loading());
    bookings.value =
        await BookingService.getReservationListByVenueId(infoVenue.idVenue);
    change(true, status: RxStatus.success());
  }

  void handleSubmitBookingField() async {
    // CustomSnackbar.failedSnackbar(
    //   title: 'Error',
    //   message: 'Please select time',
    // );

    var request = getDetailBookingEdit();
    ReservationResponse booking;
    if ("valid" == getDetailBookingEdit()!.status!) {
      booking = ReservationResponse(
          beginTime: request!.beginTime,
          bookingTime: request!.bookingTime,
          endTime: request!.endTime,
          hours: request!.hours,
          totalPrice: request!.totalPrice,
          status: "invalid",
          transactionId: request!.transactionId,
          userId: request!.userId,
          venueId: request!.venueId);
    } else {
      booking = ReservationResponse(
          beginTime: request!.beginTime,
          bookingTime: request!.bookingTime,
          endTime: request!.endTime,
          hours: request!.hours,
          totalPrice: request!.totalPrice,
          status: "valid",
          transactionId: request!.transactionId,
          userId: request!.userId,
          venueId: request!.venueId);
    }

    editBooking(booking, booking.transactionId);
    Get.back();
    return;
  }

  void editBooking(ReservationResponse request, int? transactionId) async {
    change(false, status: RxStatus.loading());
    await BookingService.updateBookingStatus(request, transactionId!);
    CustomSnackbar.successSnackbar(
      title: 'Success',
      message: 'Success edit Booking',
    );
    handleRefresh();
    change(true, status: RxStatus.success());
  }

  void handleDeleteBookingField() async {
    change(false, status: RxStatus.loading());

    var request = getDetailBookingEdit();
    handleRefresh();

    deleteBooking(request!.transactionId);
    change(true, status: RxStatus.success());
  }

  void deleteBooking(int? transactionId) async {
    change(false, status: RxStatus.loading());
    await BookingService.delete(transactionId!);
    CustomSnackbar.successSnackbar(
      title: 'Success',
      message: 'Success edit Booking',
    );
    change(true, status: RxStatus.success());
  }

  void handleRefresh() async {
    refreshController.requestRefresh();

    fetchData();
    fetchUserData();

    refreshController.refreshCompleted();
  }

  void handleRefreshEdit() async {
    refreshController.requestRefresh();

// toBookingFieldPage();
    refreshController.refreshCompleted();
  }

  void send(int userId, ReservationResponse bookings) {
    UserResponse? user = getDetailUser(userId);
    //  ReservationResponse?  bookings;

    final arguments = {
      'infoUser': user,
      'infoBooking': bookings,
      'userId': userId,
    };
    Get.toNamed(Routes.BOOKING_DETAIL, arguments: arguments);
  }

 DateTime getCurrentDateTime() => DateTime.now().subtract( const Duration(days: 90),);

  DateTime getMaxDateTimeCalendar() => DateTime.now().add(
        const Duration(days: 90),
      );
   void handleUserDatePick(
      DateRangePickerSelectionChangedArgs selectedDate) async {
    selectedDateTimeFromCalander = selectedDate.value;

  
    // refreshController.requestRefresh();

bookingPerdate.value=bookings
        .where((booking) => booking.bookingTime == dateFormat.format(selectedDateTimeFromCalander))
        .toList();
print("$bookingPerdate ${dateFormat.format(selectedDateTimeFromCalander)}");
    // refreshController.refreshCompleted();
 
  }

}
