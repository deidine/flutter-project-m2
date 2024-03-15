import 'package:mapgoog/app/global/drawer_widget.dart';
import 'package:mapgoog/citte_owner/global/drawer_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mapgoog/app/global_widgets/custom_white_appbar.dart';
import 'package:mapgoog/app/global_widgets/loading_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/all_payment_controller.dart';
import '../widgets/all_payment_content_builder.dart';
import '../widgets/content_category_filter.dart';

class AllOwnerpayment extends GetView<AllpaymentOwnerController> {
  const AllOwnerpayment({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customWhiteAppBar('Payments'),
        drawer: GlobalDrawerOwner(),
        body: SmartRefresher(
            controller: controller.refreshController,
            onRefresh: controller.handleRefresh,
            child: ListView(physics: const BouncingScrollPhysics(), children: [
              Center(
                child: controller.obx(
                  (state) {
                    if (controller.payments!.isEmpty) {
                      return Center(
                        child: Text('No payment available'),
                      );
                    } else {
                      return const SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            AllVenueContentBuilder(),
                            ContentOfFilteredVenue(),
                          ],
                        ),
                      );
                    }
                  },
                  onLoading: const LoadingSpinkit(),
                ),
              )
            ])));
  }
}
