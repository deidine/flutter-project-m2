import 'package:mapgoog/citte_client/payment/controller/payment_controller.dart'; 
import 'package:get/get.dart';


class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(
      () => PaymentController(),
    );
  }
}
