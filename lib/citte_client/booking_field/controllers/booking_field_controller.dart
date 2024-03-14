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
 
class BookingFieldController extends GetxController {
  late final VenueResponse infoVenue;
  
  final homeController = Get.find<HomeController>();
  final refreshController = RefreshController();

  late DateTime selectedDateTimeFromCalander = DateTime.now();
    List<int> hours=[];
  var temporaryHours = <int>[].obs;

  List<int> userHours = [];
  final DateFormat timeFormat = DateFormat('HH:mm');
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void onInit() {
    infoVenue = Get.arguments['infoVenue']; 
      initalizeHour();
    super.onInit();
  }
 
  Future<void> refreshSchedule(bool isSubmitRequest) async {
    final request = ScheduleRequest(
      venueId: infoVenue.idVenue,
      date: dateFormat.format(selectedDateTimeFromCalander),
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

  void createReservation() async {
    var totalPrice = 0;
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
    if (userHours[picked] == 15) {
      totalPrice = infoVenue.pricePerHour * 1;
    }
    if (userHours[picked] == 30) {
      totalPrice = infoVenue.pricePerHour * 2;
    }
    if (userHours[picked] == 45) {
      totalPrice = infoVenue.pricePerHour * 3;
    }
    if (userHours[picked] == 60) {
      totalPrice = infoVenue.pricePerHour * 4;
    }
    if (userHours[picked] == 75) {
      totalPrice = infoVenue.pricePerHour * 5;
    }
    final selectedTimeq = selectedTime.value;
    final bookingTime = dateFormat.format(selectedDateTimeFromCalander);

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
            title: 'Success', message: 'Succès du processus de réservation');
        refreshSchedule(true);
      },
    );
  }

  void handleSubmitBookingField() async {
    if (userHours.isEmpty) {
      CustomSnackbar.failedSnackbar(
        title: 'Error',
        message: 'S\'il vous plaît sélectionner l\'heure',
      );
      return;
    }

    userHours.sort();

    createReservation();
  }

  void initalizeHour() async {
    final request = ScheduleRequest(
      venueId: infoVenue.idVenue,
      date: dateFormat.format(selectedDateTimeFromCalander),
    );
    refreshController.requestRefresh();
    hours = await ReservationService.getSchedule(request).then((value) {
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
    selectedDateTimeFromCalander = selectedDate.value;

    final request = ScheduleRequest(
        venueId: infoVenue.idVenue,
        date: dateFormat.format(selectedDateTimeFromCalander));

    refreshController.requestRefresh();
    hours = await ReservationService.getSchedule(request);

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
}
