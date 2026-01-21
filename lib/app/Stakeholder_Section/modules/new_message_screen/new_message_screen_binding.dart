import 'package:get/get.dart';

import 'new_message_screen_controller.dart';

class NewMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewMessageController>(
          () => NewMessageController(),
      fenix: true,
    );
  }
}