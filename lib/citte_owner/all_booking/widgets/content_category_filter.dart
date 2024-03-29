import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
 import 'package:mapgoog/app/core/themes/font_themes.dart';
import 'package:mapgoog/app/core/values/colors.dart';
import 'package:mapgoog/app/helper/formatted_price.dart';
 
import '../controllers/all_booking_controller.dart';

class ContentOfFilteredVenue extends GetView<AllBookingController> {
  const ContentOfFilteredVenue({
    Key? key,
  }) : super(key: key);

  static final containerHeight = Get.height * 0.47;
  static final maxWidth = Get.width * 0.6;
  static final maxHeight = Get.height * 0.35;
  static final maxImageWidht = Get.height * 0.3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: containerHeight,
      child: Obx(
        () => ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: controller.filteredVenues.length,
          itemBuilder: (context, index) => ConstrainedBox(
            constraints:
                BoxConstraints.expand(height: maxHeight, width: maxWidth),
            child: GestureDetector(
              // onTap: () => controller.toBookingFieldPage(
              //   // controller.filteredVenues[index],
              // ),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            height: maxImageWidht,
                            fit: BoxFit.cover,
                            imageUrl: controller.filteredVenues[index].image,
                            placeholder: (context, url) => SizedBox(
                              height: maxImageWidht,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '⭐ ${controller.filteredVenues[index].rating}',
                              style: smallText.copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        controller.filteredVenues[index].venueName,
                        style: mediumText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.pin_drop_sharp,
                            color: blue,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            controller.filteredVenues[index].location,
                            style: textfieldText.copyWith(
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            color: blue,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Rp. ${getFormattedPrice(controller.filteredVenues[index].pricePerHour)}',
                            style: textfieldText.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
