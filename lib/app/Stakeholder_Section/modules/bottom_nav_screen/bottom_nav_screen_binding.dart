import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/bottom_nav_screen/bottom_nav_screen_controller.dart';

class BottomNavScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(
          () => BottomNavController(),
    );
  }
}