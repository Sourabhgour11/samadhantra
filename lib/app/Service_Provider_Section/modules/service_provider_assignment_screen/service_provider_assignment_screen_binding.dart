import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_assignment_screen/service_provider_assignment_screen_controller.dart';

class ServiceProviderAssignmentScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderAssignmentsController>(
          () => ServiceProviderAssignmentsController(),
    );
  }
}