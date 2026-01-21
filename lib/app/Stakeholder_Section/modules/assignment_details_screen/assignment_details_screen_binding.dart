import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/assignment_screen/assignment_screen_controller.dart';

class AssignmentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AssignmentController());
  }
}