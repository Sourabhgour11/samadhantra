import 'package:get/get.dart';
import 'support_screen_controller.dart';

class SupportBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupportController());
  }
}