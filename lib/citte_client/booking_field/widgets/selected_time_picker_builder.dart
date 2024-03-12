import 'package:flutter/material.dart';
import 'package:mapgoog/citte_client/booking_field/widgets/single_time_picker_builder.dart';

import '../../../app/core/values/colors.dart';

class SelectedTime extends StatelessWidget {
  const SelectedTime({
    Key? key,
    required this.hour,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;
  final String hour;

  @override
  Widget build(BuildContext context) {
    return SingleTimePickerBuilder(
      onTap: onTap,
      backgroundColor: blue,
      borderColor: Colors.transparent,
      hour: hour,
      hourColor: const Color.fromARGB(255, 31, 31, 31),
    );
  }
}
