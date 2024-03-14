import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mapgoog/app/core/values/colors.dart';
import 'package:mapgoog/app/global_widgets/custom_white_appbar.dart';
import '../../active_booking/widgets/custom_action_button.dart';
import '../controllers/booking_field_controller.dart';
import '../widgets/date_range_picker_builder.dart';
import '../widgets/time_range_picker_builder.dart';

class BookingFieldView extends GetView<BookingFieldController> {
  const BookingFieldView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customWhiteAppBar(controller.infoVenue.idVenue.toString()),
      body: SmartRefresher(
        controller: controller.refreshController,
        onRefresh: () => controller.refreshSchedule(false),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateRangePickerBuilder(
              calendarHeight: Get.height * 0.44,
              maxDate: controller.getMaxDateTimeCalendar(),
              minDate: controller.getCurrentDateTime(),
              onSelectionChanged: controller.handleUserDatePick,
              initialDate: controller.getCurrentDateTime(),
            ),
            Row(
              children: [
                CustomActionButton(
                  backgroundColor: blue,
                  borderColor: Colors.transparent,
                  label: 'Sélectionner le Temps',
                  onTap: () => controller.selectTime(), // Call function to show time picker
                  textColor: pink,
                ),
                const SizedBox(
                  width: 10,
                ), 
                Obx(() {
                  // Use Obx widget to listen to changes in selected time
                  final selectedTime = controller.selectedTime.value;
                  return selectedTime != null 
                    ? Text(
                        'Selected Time: ${selectedTime['start'].hour}:${selectedTime['start'].minute} - ${selectedTime['end'].hour}:${selectedTime['end'].minute}',
                      )
                    : Container();
                }),
              ],
            ),
            const TimeRangePickerBuilder(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Champ de réservation',style: TextStyle(color: lightBlue),),
        icon: const Icon(Icons.ads_click_outlined),
        backgroundColor: green,
        onPressed: () {
          // Call function to handle booking field
          final selectedTime = controller.selectedTime.value;
          if (selectedTime != null &&
              controller.isTimeSlotAvailable(selectedTime['start'], selectedTime['end'])) {
            controller.handleSubmitBookingField();
          } else {
            // Show error message indicating that the time slot is already booked
            Get.snackbar(
              'Error',
              'The selected time slot is already booked. Please choose another time slot.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
      ),
    );
  }
}










import 'package:get/get.dart';

class BookingFieldController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<Map<String, DateTime>?> selectedTime = Rx<Map<String, DateTime>?>(null);

    // Function to handle user date pick
  void handleUserDatePick(DateTime pickedDate) {
    selectedDate.value = pickedDate;
  }

  // Function to handle time selection
  void selectTime() {
    // Implementation to show time picker and set selectedTime
    // This depends on your specific implementation
  }

  // Function to check if the given time slot is available
  bool isTimeSlotAvailable(DateTime startTime, DateTime endTime) {
    // Here you should implement your logic to check if the time slot is available
    // This might involve querying a database or checking against existing bookings
    // For this example, let's assume there's a list of bookedTimeSlots
    // where each item is a map with 'start' and 'end' keys representing start and end times

    final bookedTimeSlots = [
      {'start': DateTime.now().add(Duration(hours: 1)), 'end': DateTime.now().add(Duration(hours: 2))},
      {'start': DateTime.now().add(Duration(hours: 3)), 'end': DateTime.now().add(Duration(hours: 4))},
      // Add more booked time slots here
    ];

    // Check if the provided time slot overlaps with any booked time slots
    for (final slot in bookedTimeSlots) {
      final bookedStartTime = slot['start'] as DateTime;
      final bookedEndTime = slot['end'] as DateTime;

      if ((startTime.isAfter(bookedStartTime) && startTime.isBefore(bookedEndTime)) ||
          (endTime.isAfter(bookedStartTime) && endTime.isBefore(bookedEndTime)) ||
          (startTime.isBefore(bookedStartTime) && endTime.isAfter(bookedEndTime))) {
        // There's an overlap, so the time slot is not available
        return false;
      }
    }

    // No overlap found, so the time slot is available
    return true;
  }

  // Function to handle submission of booking field
  void handleSubmitBookingField() {
    // Implementation to handle the submission of booking field
  }

  DateTime getMaxDateTimeCalendar() {
    // Implementation to get the maximum date allowed for selection
    return DateTime.now().add(Duration(days: 30));
  }

  DateTime getCurrentDateTime() {
    // Implementation to get the current date and time
    return DateTime.now();
  }

  void refreshSchedule(bool value) {
    // Implementation to refresh the schedule
  }
}
