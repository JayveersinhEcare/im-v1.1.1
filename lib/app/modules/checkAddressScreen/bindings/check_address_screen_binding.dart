import 'package:get/get.dart';

import '../controllers/check_address_screen_controller.dart';

class CheckAddressScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckAddressScreenController>(
      () => CheckAddressScreenController(),
    );
  }
}
