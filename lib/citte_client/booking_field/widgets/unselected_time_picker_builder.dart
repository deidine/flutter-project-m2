import 'package:flutter/material.dart';
import 'package:mapgoog/citte_client/booking_field/widgets/single_time_picker_builder.dart';

import '../../../app/core/values/colors.dart';

class UnselectedTime extends StatelessWidget {
  const UnselectedTime({
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
      backgroundColor: Colors.white,
      borderColor: blue,
      hour: hour,
      hourColor: Colors.black,
    );
  }
}
