import 'package:get/get.dart';

import 'message_details_screen_controller.dart';

class MessageThreadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageThreadController>(
          () => MessageThreadController(),
      fenix: true,
    );
  }
}