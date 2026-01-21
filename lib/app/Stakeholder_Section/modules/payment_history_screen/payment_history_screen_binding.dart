import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/payment_history_screen/payment_history_screen_controller.dart';

class PaymentHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentHistoryController());
  }
}