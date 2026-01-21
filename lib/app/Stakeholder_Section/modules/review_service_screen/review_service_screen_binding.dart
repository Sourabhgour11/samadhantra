// bindings/review_service_binding.dart
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/review_service_screen/review_service_screen_controller.dart';

class ReviewServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReviewServiceController());
  }
}