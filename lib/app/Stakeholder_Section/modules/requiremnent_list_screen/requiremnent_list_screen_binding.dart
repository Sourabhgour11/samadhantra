import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/requiremnent_list_screen/requiremnent_list_screen_controller.dart';

class RequiremnentListScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequirementsController>(
          () => RequirementsController(),
    );
  }
}