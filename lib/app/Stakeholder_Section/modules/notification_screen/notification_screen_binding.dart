import 'package:get/get.dart';

import 'notification_screen_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
          () => NotificationsController(),
    );
  }
}