import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/role_selection_screen/role_selection_screen_controller.dart';

class RoleSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoleSelectionController>(
          () => RoleSelectionController(),
    );
  }
}