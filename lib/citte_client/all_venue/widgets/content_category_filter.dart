import 'package:cached_network_image/cached_network_image.dart';
import 'package:mapgoog/app/data/provider/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/core/themes/font_themes.dart';
import '../../../app/core/values/colors.dart';
import '../../../app/helper/formatted_price.dart';
import '../controllers/all_venue_controller.dart';

class ContentOfFilteredVenue extends GetView<AllVenueController> {
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
              onTap: () => controller.toBookingFieldPage(
                controller.filteredVenues[index],
              ),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Expanded(
                          child: Image.network(
                            width: 150,
                            "${ApiProvider.imgVenue}${ controller.filteredVenues[index].idVenue}/",
                            fit: BoxFit.cover,
                          ),
                        )) 
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
