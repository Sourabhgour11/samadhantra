// lib/app/modules/service_provider/bindings/service_provider_add_service_binding.dart
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_add_service_screen/service-provider_add-service_screen_controller.dart';

class ServiceProviderAddServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderAddServiceController>(
          () => ServiceProviderAddServiceController(),
    );
  }
}