import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/payment_details_screen/payment_details_screen_controller.dart';

class PaymentDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentDetailController());
  }
}