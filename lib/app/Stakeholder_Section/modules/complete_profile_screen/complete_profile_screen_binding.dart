import 'package:get/get.dart';

import 'complete_profile_screen_controller.dart';

class CompleteProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteProfileController>(
          () => CompleteProfileController(),
    );
  }
}