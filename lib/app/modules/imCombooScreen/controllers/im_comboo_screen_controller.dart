import 'package:get/get.dart';

import '../../../data/woocommerceModels/woo_products.dart';
import '../../homeTabscreen/controllers/home_tabscreen_controller.dart';

class ImCombooScreenController extends GetxController {
  var homeTabController = Get.find<HomeTabscreenController>();

  Rx<List<WooProduct>?> imComboo = Rx<List<WooProduct>?>(null);
  var imloading = RxBool(true);

  @override
  void onInit() {
    getByCategory();
    super.onInit();
  }

  getByCategory() async {
    imComboo.value = await homeTabController.wooCommerce.value
        ?.getProducts(category: "73", minPrice: "1");
    imloading(false);
  }
}
