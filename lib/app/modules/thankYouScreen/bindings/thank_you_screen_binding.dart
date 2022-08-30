import 'package:get/get.dart';

import '../controllers/thank_you_screen_controller.dart';

class ThankYouScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThankYouScreenController>(
      () => ThankYouScreenController(),
    );
  }
}
