import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mapgoog/app/core/themes/font_themes.dart';
import 'package:mapgoog/app/core/values/colors.dart';
import 'package:mapgoog/app/helper/formatted_price.dart';
import 'package:mapgoog/citte_client/booking_field/widgets/date_range_picker_builder.dart';
import 'package:mapgoog/citte_owner/all_booking/widgets/user_data.dart';

import '../controllers/all_booking_controller.dart';

class AllBookingContentBuilder extends GetView<AllBookingController> {
  const AllBookingContentBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _searchController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(8, 15, 0, 8),
            child: Column(children: [
              Text(
                'All Booking',
                style: smallText.copyWith(color: orange),
              ),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  controller.searchBooking(_searchController.text);
                },
                onSubmitted: (value) {},
              )
            ])),
        DateRangePickerBuilder(
            calendarHeight: MediaQuery.of(context).size.height * 0.4,
            maxDate: controller.getMaxDateTimeCalendar(),
            minDate: controller.getCurrentDateTime(),
            onSelectionChanged: controller.handleUserDatePick,
            initialDate: DateTime.now()),
        Obx(() => ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.bookingPerdate.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => controller.send(
                    controller.bookingPerdate[index].userId!,
                    controller.bookingPerdate[index]),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4, // Added elevation for a lifted look
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: UserDataBuilder(
                            email: controller
                                .getDetailUser(
                                    controller.bookingPerdate[index].userId!)!
                                .email,
                            phoneNumber: controller
                                .getDetailUser(
                                    controller.bookingPerdate[index].userId!)!
                                .phoneNumber,
                            status: controller.bookingPerdate[index].status!,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                context,
                                icon: Icons.timer,
                                text:
                                    "${controller.getDetailUser(controller.bookingPerdate[index].userId!)!.idUser} id",
                              ),
                              _buildDetailRow(
                                context,
                                icon: Icons.timer,
                                text:
                                    "${controller.bookingPerdate[index].hours.toString()} min",
                              ),
                              _buildDetailRow(
                                context,
                                icon: Icons.date_range,
                                text:
                                    "Date ${controller.bookingPerdate[index].bookingTime}",
                              ),
                              _buildDetailRow(
                                context,
                                icon: Icons.start,
                                text:
                                    "Begin ${controller.bookingPerdate[index].beginTime}",
                              ),
                              _buildDetailRow(
                                context,
                                icon: Icons.fiber_manual_record_sharp,
                                text:
                                    "End ${controller.bookingPerdate[index].endTime}",
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    color: blue,
                                    size: screenWidth * 0.03,
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Text(
                                    'Rp. ${getFormattedPrice(controller.bookingPerdate[index].totalPrice)}',
                                    style: textfieldText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Get.toNamed(Routes.BOOKING_DETAIL, arguments: arguments);
                                  controller.toBookingFieldPage(
                                      controller.bookingPerdate[index].userId!,
                                      controller.bookingPerdate[index]);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30), // Border radius
                                  ),
                                ),
                                child: Text('Voire Payment'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context,
      {required IconData icon, required String text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: blue,
            size: MediaQuery.of(context).size.width * 0.04,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          Text(text,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045)),
        ],
      ),
    );
  }
}
