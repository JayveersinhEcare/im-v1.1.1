import 'package:get/get.dart';
import 'package:incredibleman/app/modules/orderScreen/controllers/order_screen_controller.dart';

import '../../cart/controllers/cart_controller.dart';
import '../../drawerScreen/controllers/drawer_screen_controller.dart';
import '../../homeTabscreen/controllers/home_tabscreen_controller.dart';
import '../../imCombooScreen/controllers/im_comboo_screen_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(HomeTabscreenController);
    Get.put(
      HomeController(),
    );
    Get.put(HomeTabscreenController());
    Get.put(ImCombooScreenController());
    Get.put(DrawerScreenController());
    Get.put(
      CartController(),
    );

    Get.put(
      OrderScreenController(),
    );
  }
}
