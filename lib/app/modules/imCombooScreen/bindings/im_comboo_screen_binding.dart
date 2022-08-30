import 'package:get/get.dart';

import '../controllers/im_comboo_screen_controller.dart';

class ImCombooScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ImCombooScreenController());
  }
}
