import 'package:get/get.dart';

import '../controllers/drawer_screen_controller.dart';

class DrawerScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      DrawerScreenController(),
    );
  }
}
