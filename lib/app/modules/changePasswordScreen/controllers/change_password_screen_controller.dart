import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/woocommerceModels/woo_customer.dart';
import '../../home/controllers/home_controller.dart';

class ChangePasswordScreenController extends GetxController {
  var contro = Get.find<HomeController>();
  var isloadingPassword = RxBool(false);
  final formkey = GlobalKey<FormState>();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirm = TextEditingController();

  Future changePassword() async {
    isloadingPassword(true);
    WooCustomer customer = WooCustomer(
      id: contro.customer.value?.id,
      email: contro.customer.value?.email,
      lastName: contro.customer.value?.lastName,
      password: confirm.text.trim(),
    );
    await contro.cod.wooCommerce.value
        ?.oldUpdateCustomer(wooCustomer: customer);
    isloadingPassword(false);
  }
}
