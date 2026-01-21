// requirement_detail_binding.dart
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/requirement_details_screen/requirement_details_screen_controller.dart';

class RequirementDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequirementDetailController>(
          () => RequirementDetailController(),
    );
  }
}