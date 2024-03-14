import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapgoog/app/data/provider/api_provider.dart';

import '../../../app/core/themes/font_themes.dart';
import '../../../app/core/values/colors.dart';

class DialogContentMapVenueModel {
  int id;
  String venueName;
  String pricePerHour;
  String adress;
  VoidCallback onConfirm;

  DialogContentMapVenueModel({
    required this.id,
    required this.venueName,
    required this.pricePerHour,
    required this.adress,
    required this.onConfirm,
  });
}

void showOrderDialogSummary(DialogContentMapVenueModel model) {
  Get.defaultDialog(
    title: ' information du cite',
    titleStyle: smallText.copyWith(color: orange),
    content: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            model.venueName,
            style: textfieldText.copyWith(fontSize: 15),
          ),
          ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child:  ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Expanded(
                          child: CachedNetworkImage(
                            width: 150,
                          imageUrl:  "${ApiProvider.imgVenue}${model.id}/",
                            fit: BoxFit.cover,
                          ),
                        )),
                    ),
          const SizedBox(
            height: 10,
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'prix par 15 Min: ',
                style: textfieldText.copyWith(fontSize: 15),
              ),
              Text(
                '${model.pricePerHour} RMU',
                style: smallText,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Adress/Location: ',
                style: textfieldText.copyWith(fontSize: 15),
              ),
              Text(
                model.adress,
                style: smallText,
              ),
            ],
          ),
        ],
      ),
    ),
    onConfirm: model.onConfirm,
    textConfirm: 'Reserver',
    textCancel: 'Annuller',
    confirmTextColor: Colors.white,
  );
}
