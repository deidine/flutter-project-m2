import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/core/themes/font_themes.dart';
import '../../../app/core/values/colors.dart';

class DialogContentModel {
  String venueName;
  String pricePerHour;
  String totalHour;
  String totalPrice;
  VoidCallback onConfirm;

  DialogContentModel({
    required this.venueName,
    required this.pricePerHour,
    required this.totalHour,
    required this.totalPrice,
    required this.onConfirm,
  });
}

void showOrderDialogSummary(DialogContentModel model) {
  Get.defaultDialog(
    title: 'Résumé de la réservation',
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
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prix : ',
                style: textfieldText.copyWith(fontSize: 15),
              ),
              Text(
                model.pricePerHour,
                style: smallText,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Durée totale : ',
                style: textfieldText.copyWith(fontSize: 15),
              ),
              Text(
                '${model.totalHour} min',
                style: smallText,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prix total : ',
                style: textfieldText.copyWith(fontSize: 15),
              ),
              Text(
                model.totalPrice,
                style: smallText,
              ),
            ],
          ),
        ],
      ),
    ),
    onConfirm: model.onConfirm,
    textConfirm: 'Réserver',
    textCancel: 'Annuler',
    confirmTextColor: Colors.white,
  );
}
