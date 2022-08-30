import 'package:get/get.dart';

import '../controllers/home_tabscreen_controller.dart';

class HomeTabscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeTabscreenController());
  }
}
