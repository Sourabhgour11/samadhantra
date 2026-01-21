import 'package:get/get.dart';

import 'assignment_screen_controller.dart';

class AssignmentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AssignmentController());
  }
}