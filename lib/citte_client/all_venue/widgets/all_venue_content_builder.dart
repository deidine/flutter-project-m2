import 'package:cached_network_image/cached_network_image.dart';
import 'package:mapgoog/app/data/provider/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/core/themes/font_themes.dart';
import '../../../app/core/values/colors.dart';
import '../../../app/helper/formatted_price.dart';
import '../controllers/all_venue_controller.dart';

class AllVenueContentBuilder extends GetView<AllVenueController> {
  const AllVenueContentBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 15, 0, 8),
          child: Text(
            'All Venue',
            style: smallText.copyWith(color: orange),
          ),
        ),
        ListView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.venues.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => controller.toBookingFieldPage(
              controller.venues[index],
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child:  ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Expanded(
                          child: CachedNetworkImage(
                            width: 150,
                          imageUrl:  "${ApiProvider.imgVenue}${controller.venues![index].idVenue}/",
                            fit: BoxFit.cover,
                          ),
                        )),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.venues[index].venueName,
                          style: smallText,
                        ),
                        Text( "${controller.venues[index].idVenue}",),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.pin_drop_sharp,
                              color: blue,
                              size: 14,
                            ),
                            Text(controller.venues[index].location)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.attach_money,
                              color: blue,
                              size: 14,
                            ),
                            Text(
                              'Rp. ${getFormattedPrice(controller.venues[index].pricePerHour)}',
                              style: textfieldText.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
