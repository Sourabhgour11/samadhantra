import 'package:get/get.dart';
import 'dart:async';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onReady() {
    super.onReady();

    Future.delayed(const Duration(seconds: 2), () {
      Get.toNamed(AppRoutes.login);
    });
  }
}
