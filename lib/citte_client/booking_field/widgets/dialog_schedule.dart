import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogScheduleModel {
  String venueName;
  String end;
  String begin;
  String date;

  DialogScheduleModel({
    required this.venueName,
    required this.end,
    required this.begin,
    required this.date,
  });
}
class OrderDialogScheduleSummary extends StatelessWidget {
  final List<DialogScheduleModel> model;

  const OrderDialogScheduleSummary({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Résumé de l\'emploi du temps'), // Titre traduit
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: model.length,
          itemBuilder: (context, index) {
            DialogScheduleModel item = model[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nom du lieu : ${item.venueName}', // Traduction des labels
                    style: TextStyle(fontSize: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Début : ${item.begin} min', // Traduction
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            'Fin : ${item.end}', // Traduction
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            'Date : ${item.date}', // Traduction
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Fermer le dialogue
          },
          child: Text('Retour'), // Bouton traduit
        ),
      ],
    );
  }
}
