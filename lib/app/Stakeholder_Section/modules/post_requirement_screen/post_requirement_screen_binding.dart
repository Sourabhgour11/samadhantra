import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/post_requirement_screen/post_requirement_screen_controller.dart';

class PostRequirementScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostRequirementController>(
          () => PostRequirementController(),
    );
  }
}