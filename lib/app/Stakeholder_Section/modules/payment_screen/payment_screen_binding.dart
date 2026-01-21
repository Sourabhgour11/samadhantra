import 'package:get/get.dart';
import 'payment_screen_controller.dart';

class PaymentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentController());
  }
}