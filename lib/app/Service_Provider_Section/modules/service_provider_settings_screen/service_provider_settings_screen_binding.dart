import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_settings_screen/service_provider_settings_screen_controller.dart';

class ServiceProviderSettingsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderSettingsController>(
          () => ServiceProviderSettingsController(),
    );
  }
}