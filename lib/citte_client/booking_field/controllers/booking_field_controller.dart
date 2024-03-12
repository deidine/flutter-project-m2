import 'package:mapgoog/app/data/model/reservation/reservation_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mapgoog/app/core/themes/custom_snackbar_theme.dart';
import 'package:mapgoog/app/data/model/reservation/schedule_request.dart';
import 'package:mapgoog/app/data/model/venue/venue_response.dart';
import 'package:mapgoog/app/data/service/reservation_service.dart';
import 'package:mapgoog/app/helper/formatted_price.dart';
import 'package:mapgoog/citte_client/booking_field/widgets/dialog_content.dart';
import 'package:mapgoog/citte_client/home/controllers/home_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

const millisecondToHour = 3600000;

class BookingFieldController extends GetxController {
  late final VenueResponse infoVenue;
  late final bool isEditReservation;
  late final int transactionId;

  final homeController = Get.find<HomeController>();
  final refreshController = RefreshController();

  int userPickDateSinceEpoch = 0;
 late DateTime selectedDateTimeFromCalander ;
  late List<int> hours;
  var temporaryHours = <int>[].obs;

  List<int> userHours = [];

  @override
  void onInit() {
    parsingArgument();

    super.onInit();
  }

  @override
  void onReady() {
    initializeDate();

    isEditReservation ? initalizeHourEdit() : initalizeHour();

    super.onReady();
  }

  void parsingArgument() {
    infoVenue = Get.arguments['infoVenue'];
    isEditReservation = Get.arguments['isEditReservation'];
    transactionId = Get.arguments['transactionId'];
  }

  Future<void> refreshSchedule(bool isSubmitRequest) async {
    final request = ScheduleRequest(
      venueId: infoVenue.idVenue,
      date: userPickDateSinceEpoch,
    );

    refreshController.requestRefresh();
    hours = await ReservationService.getSchedule(request).then((value) {
      refreshController.refreshCompleted();
      return value;
    });

    if (!isSubmitRequest) {
      temporaryHours.value = [...hours];
      userHours.clear();
    }
  }

  void handleEditReservation() async {
    int picked = 0;
    if (userHours.length == 3) {
      picked = 2;
    }
    if (userHours.length == 2) {
      picked = 1;
    }
    if (userHours.length == 1) {
      picked = 0;
    }
    final DateFormat timeFormat = DateFormat('HH:mm:ss');
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

// Format beginTime and endTime
    final beginTime = timeFormat.format(DateTime.fromMillisecondsSinceEpoch(
        userPickDateSinceEpoch + userHours[0] * millisecondToHour));
    final endTime = timeFormat.format(DateTime.fromMillisecondsSinceEpoch(
        userPickDateSinceEpoch +
            userHours[userHours.length - 1] * millisecondToHour));

    final bookingTime = dateFormat.format(DateTime.now());

    final totalPrice = infoVenue.pricePerHour * userHours.length;
    final request = ReservationResponse(
      transactionId: transactionId,
      totalPrice: totalPrice,
      beginTime: beginTime,
      endTime: endTime,
      hours: userHours[picked],
      venueId: infoVenue.idVenue,
      userId: homeController.dataUser?.idUser,
      bookingTime: bookingTime,
    );

    await ReservationService.updateReservation(request).then(
      (_) {
        CustomSnackbar.successSnackbar(
            title: 'Success', message: 'Reservation update succes');
        refreshSchedule(true);
      },
    );
  }

  void createReservation() async {
    final DateFormat timeFormat = DateFormat('HH:mm:ss');
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

 
// Format bookingTime
    final bookingTime = dateFormat.format(selectedDateTimeFromCalander);

    var totalPrice=0;
    int picked = 0;
    if (userHours.length == 3) {
      picked = 2;
    }
    if (userHours.length == 2) {
      picked = 1;

    }
    if (userHours.length == 1) {
      picked = 0;

    }
    if(userHours[picked]==15){totalPrice = infoVenue.pricePerHour * 1;}
    if(userHours[picked]==30){totalPrice = infoVenue.pricePerHour * 2;}
    if(userHours[picked]==45){totalPrice = infoVenue.pricePerHour * 3;}
    if(userHours[picked]==60){totalPrice = infoVenue.pricePerHour * 4;}
    if(userHours[picked]==75){totalPrice = infoVenue.pricePerHour * 5;}
      final selectedTimeq = selectedTime.value;

  // Calculate end time by adding user selected hours to the selected time
  final endTime2 = timeFormat.format(DateTime(
    0, // Year
    0, // Month
    0, // Day
    selectedTimeq!.hour,
    selectedTimeq.minute + userHours[picked],
  ));
    final request = ReservationResponse(
      totalPrice: totalPrice,
      beginTime: "${selectedTimeq.hour}:${selectedTimeq.minute}",
      endTime: endTime2,
      hours: userHours[picked],
      venueId: infoVenue.idVenue,
      userId: homeController.dataUser?.idUser,
      bookingTime: bookingTime,
    );

    final dialogModel = DialogContentModel(
      venueName: infoVenue.venueName,
      pricePerHour: 'Rp. ${getFormattedPrice(infoVenue.pricePerHour)}',
      totalHour: userHours[picked].toString(),
      totalPrice: 'Rp. ${getFormattedPrice(totalPrice)}',
      onConfirm: () {
        createReservationRequest(request);
        Get.back();
      },
    );

    showOrderDialogSummary(dialogModel);
  }

  void createReservationRequest(ReservationResponse request) async {
    await ReservationService.createReservation(request).then(
      (_) {
        CustomSnackbar.successSnackbar(
            title: 'Success', message: 'Reservation process succes');
        refreshSchedule(true);
      },
    );
  }

  void handleSubmitBookingField() async {
    if (userHours.isEmpty) {
      CustomSnackbar.failedSnackbar(
        title: 'Error',
        message: 'Please select time',
      );
      return;
    }

    userHours.sort();

    if (isEditReservation) {
      handleEditReservation();
      return;
    }

    createReservation();
  }

  void initializeDate() {
    final now = getCurrentDateTime();
    final pureDate = DateTime(now.year, now.month, now.day);
    userPickDateSinceEpoch = pureDate.millisecondsSinceEpoch;
  }

  void initalizeHour() async {
    final request = ScheduleRequest(
      venueId: infoVenue.idVenue,
      date: userPickDateSinceEpoch,
    );
    refreshController.requestRefresh();
    hours = await ReservationService.getSchedule(request).then((value) {
      refreshController.refreshCompleted();
      return value;
    });

    temporaryHours.value = [...hours];
  }

  void initalizeHourEdit() async {
    final request = ScheduleRequest(
      venueId: infoVenue.idVenue,
      date: userPickDateSinceEpoch,
      txId: transactionId,
    );

    refreshController.requestRefresh();
    hours =
        await ReservationService.getScheduleExcludeTxId(request).then((value) {
      refreshController.refreshCompleted();
      return value;
    });

    temporaryHours.value = [...hours];
  }

  void handleUserTimePick(int inputHour) {
    final isUserSelectedHourFromAPI = hours.contains(inputHour);
    if (isUserSelectedHourFromAPI) return;

    userHours.sort();

    final isUserTryToDeleteMiddleNumber =
        userHours.length == 3 && userHours[1] == inputHour;
    if (isUserTryToDeleteMiddleNumber) return;

    final isUserAlreadySelectTime = temporaryHours.contains(inputHour);
    if (isUserAlreadySelectTime) {
      temporaryHours.remove(inputHour);
      userHours.remove(inputHour);
      return;
    }

    if (userHours.isNotEmpty) {
      if (isMoreThanThreeHours()) return;

      if (!isConsecutive(inputHour)) return;
    } else {
      userHours.add(inputHour);
      temporaryHours.add(inputHour);
    }
  }

  bool isConsecutive(int inputHour) {
    final lastPrevNumber = userHours[userHours.length - 1];
    final isConsecutive = lastPrevNumber + 1 == inputHour ||
        lastPrevNumber - 1 == inputHour ||
        lastPrevNumber - 2 == inputHour;

    if (isConsecutive) {
      temporaryHours.add(inputHour);
      userHours.add(inputHour);
      return true;
    }

    CustomSnackbar.failedSnackbar(
      title: 'Error',
      message: 'Please pick consecutive number',
    );
    return false;
  }

  bool isMoreThanThreeHours() {
    final isMoreThanThreeHours = userHours.length >= 3;
    if (isMoreThanThreeHours) {
      CustomSnackbar.failedSnackbar(
        title: 'Error',
        message: 'Booking time max 3 hours',
      );
      return true;
    }

    return false;
  }

  void handleUserDatePick(
      DateRangePickerSelectionChangedArgs selectedDate) async {
    DateTime selectedDateTime = selectedDate.value;
    selectedDateTimeFromCalander= selectedDate.value;
    userPickDateSinceEpoch = selectedDateTime.millisecondsSinceEpoch;

    final request = ScheduleRequest(
        venueId: infoVenue.idVenue, date: userPickDateSinceEpoch);

    refreshController.requestRefresh();
    hours = (isEditReservation)
        ? await ReservationService.getScheduleExcludeTxId(request)
        : await ReservationService.getSchedule(request);

    temporaryHours.value = [...hours];
    refreshController.refreshCompleted();

    userHours.clear();
  }

  DateTime getCurrentDateTime() => DateTime.now();

  DateTime getMaxDateTimeCalendar() => DateTime.now().add(
        const Duration(days: 90),
      );





  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);

  TimeOfDay? getSelectedTime() => selectedTime.value;

// Function to show the time picker and update selectedTime
  void selectTime() {
    showTimePicker(
      context: Get.overlayContext!,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        selectedTime.value = value;
      }
    }).catchError((error) {
      CustomSnackbar.failedSnackbar(
        title: 'Error',
        message: 'Failed to pick time: $error',
      );
    });
  }

  // Getter method to access the selected time
 
}
