import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incredibleman/app/data/woocommerceModels/woo_products.dart';
import 'package:incredibleman/app/routes/app_pages.dart';

import '../../../constants/constants.dart';
import '../../../data/woocommerceModels/wooMain/woo_main.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    await getxfetchData();
    Future.delayed(const Duration(seconds: 6), () {
      Get.offAllNamed(Routes.HOME);
    });
    super.onInit();
  }

  Rx<List<WooProduct>?> newProducts = Rx<List<WooProduct>?>(null);
  Rx<WooCommerce> wooCommerce = WooCommerce(
    baseUrl: baseUrl,
    consumerKey: ck,
    consumerSecret: cs,
    isDebug: true,
  ).obs;
  var mainloding = true.obs;

  Future getxfetchData() async {
    try {
      mainloding(true);

      newProducts.value = await wooCommerce.value.getProducts(
        perPage: 50,
        minPrice: "1",
      );
      // print(newProducts);
      update();
      mainloding(false);
    } catch (e) {
      Get.defaultDialog(
          title: "Opps... ",
          content: const Text("something Went Wrong Please Try Again"));
    }
  }
}
