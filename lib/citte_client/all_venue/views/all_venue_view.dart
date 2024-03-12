import 'package:mapgoog/app/core/values/colors.dart';
import 'package:mapgoog/app/global/drawer_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mapgoog/app/global_widgets/custom_white_appbar.dart';
import 'package:mapgoog/app/global_widgets/loading_spinkit.dart';

import '../controllers/all_venue_controller.dart';
import '../widgets/all_venue_content_builder.dart';
import '../widgets/content_category_filter.dart';
import '../widgets/header_category_filter.dart';

class AllVenueView extends GetView<AllVenueController> {
  const AllVenueView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   floatingActionButton:// Add some space between the FABs
          FloatingActionButton.extended(
            label: const Text(
              'location',
              style: TextStyle(color: lightBlue),
            ),
            icon: const Icon(Icons.map_outlined, color: Colors.white),
            backgroundColor: blue,
            onPressed:()=>   Get.toNamed('/locationmap' ),
          ),
     
      appBar: customWhiteAppBar('Explore'),
      drawer: GlobalDrawer(),
      body: controller.obx(
        (state) => SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              HeaderCategoryVenueBuilder(),
              ContentOfFilteredVenue(),
              AllVenueContentBuilder(),
            ],
          ),
        ),
        onLoading: const LoadingSpinkit(),
      ),
    );
  }
}
