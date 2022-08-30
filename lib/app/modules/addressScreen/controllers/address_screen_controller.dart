// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incredibleman/app/modules/home/controllers/home_controller.dart';

class AddressScreenController extends GetxController {
  var contro = Get.find<HomeController>();
  var isSavingAddress = RxBool(false);
  final formkey = GlobalKey<FormState>();
  final TextEditingController firstname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController postal = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController address1 = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController phone = TextEditingController();
  @override
  void onInit() {
    // print(contro.customer.value);
    super.onInit();
    firstname..text = contro.customer.value?.firstName ?? "";
    email
      ..text = contro.customer.value?.email ?? contro.gUser.value?.email ?? "";
    postal..text = contro.customer.value?.billing?.postcode ?? "";
    state..text = contro.customer.value?.billing?.state ?? "Gujarat";
    address..text = contro.customer.value?.billing?.address1 ?? "";
    address1..text = contro.customer.value?.billing?.address2 ?? "";
    city..text = contro.customer.value?.billing?.city ?? "";
    phone
      ..text = contro.customer.value?.billing?.phone ??
          contro.gUser.value?.phoneNumber ??
          "";
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  Future saveAddressDetails({Map<String, Map<String, String>>? data}) async {
    isSavingAddress(true);
    if (contro.customer.value != null) {
      contro.customer.value = await contro.cod.wooCommerce.value
          ?.updateCustomer(id: contro.customer.value!.id!, data: data!);
      Get.snackbar(
        "Updated Details",
        "Your Details Has Been Updated",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      ).future.then((value) => Future.delayed(const Duration(seconds: 2), () {
            Get.back();
          }));
    } else {
      // print(email.text);
      await contro.getUserFromWoo(email: email.text.trim());
      await contro.gUser.value?.updateDisplayName(email.text.trim());
      contro.gUser.value?.reload();
      // print(contro.customer.value!.id!);
      contro.customer.value = await contro.cod.wooCommerce.value
          ?.updateCustomer(id: contro.customer.value!.id!, data: data!);
      Get.snackbar(
        "Updated Details",
        "Your Details Has Been Updated",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      ).future.then((value) => Future.delayed(const Duration(seconds: 2), () {
            Get.back();
          }));
    }
    isSavingAddress(false);
  }
}
