import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/home_screen/home_screen_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeScreenController>(
          () => HomeScreenController(),
    );
  }
}