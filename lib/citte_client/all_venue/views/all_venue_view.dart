import 'package:mapgoog/app/core/values/colors.dart';
import 'package:mapgoog/app/global/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
      appBar: customWhiteAppBar('Explore'),
      drawer: GlobalDrawer(),
      floatingActionButton: // Add some space between the FABs
          FloatingActionButton.extended(
        label: const Text(
          'location',
          style: TextStyle(color: lightBlue),
        ),
        icon: const Icon(Icons.map_outlined, color: Colors.white),
        backgroundColor: blue,
        onPressed: () => Get.toNamed('/locationmap'),
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        onRefresh: controller.handleRefresh,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: controller.obx(
                (state) {
                  if (controller.venues != null) {
                    return const SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // ContentOfFilteredVenue(),
                          AllVenueContentBuilder(),
                        ],
                      ),
                    );
                  } else {
                    // Handle the case where homeController or dataUser is null
                    // For example, show a loading indicator or an error message
                    return const LoadingSpinkit();
                  }
                },
                onLoading: const LoadingSpinkit(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
