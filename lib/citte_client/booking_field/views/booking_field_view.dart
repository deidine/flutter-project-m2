import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapgoog/app/core/themes/font_themes.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Réserver',style: TextStyle(color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,),),
        icon: const Icon(Icons.ads_click_outlined),
        elevation: 60,
        backgroundColor: green,
        onPressed: controller.handleSubmitBookingField,
      ),
        appBar: customWhiteAppBar(controller.infoVenue.venueName),
        body: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: () => controller.refreshSchedule(false),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateRangePickerBuilder(
                    calendarHeight: MediaQuery.of(context).size.height * 0.4,
                    maxDate: controller.getMaxDateTimeCalendar(),
                    minDate: controller.getCurrentDateTime(),
                    onSelectionChanged: controller.handleUserDatePick,
                    initialDate: controller.getCurrentDateTime(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CustomActionButton(
                            backgroundColor: blue,
                            borderColor: Colors.transparent,
                            label: 'Sélectionner le Temps',
                            onTap: () => controller.selectTime(),
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 30,
                        onPressed: controller.selectTime,
                        icon: Icon(Icons.timer),
                      ),
                      Obx(() {
                        final selectedTime = controller.selectedTime.value;
                        return selectedTime != null
                            ? Text(
                                '${selectedTime.hour}:${selectedTime.minute}',
                                style: TextStyle(fontSize: 20),
                              )
                            : Container();
                      }),
                    ],
                  ),
                  const TimeRangePickerBuilder(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.showSchedule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: softGreen,
                      elevation: 20,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    ),
                    child: Text(
                      'Afficher les bookings',
                      style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.black, // Set the text color to white
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                 
                ],
              ),
            ),
          ),
        ));
  }
}
