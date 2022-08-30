import 'package:get/get.dart';

import '../../../data/woocommerceModels/woo_products.dart';
import '../../homeTabscreen/controllers/home_tabscreen_controller.dart';

class CartController extends GetxController {
  var cod = Get.find<HomeTabscreenController>();
  Rx<List<WooProduct>?> sampleItem = Rx<List<WooProduct>?>(null);
  var isLoading = RxBool(false);
  @override
  void onInit() {
    getSampleProduct();
    super.onInit();
  }

  getSampleProduct() async {
    isLoading(true);
    sampleItem.value = await cod.wooCommerce.value!.getProducts(
      category: "15",
      status: "publish",
    );
    isLoading(false);
  }
}
