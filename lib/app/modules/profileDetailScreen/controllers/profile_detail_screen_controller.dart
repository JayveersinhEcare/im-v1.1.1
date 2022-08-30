// ignore_for_file: avoid_single_cascade_in_expression_statements, depend_on_referenced_packages

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../constants/constants.dart';
import '../../../data/woocommerceModels/woo_customer.dart';
import '../../home/controllers/home_controller.dart';

class ProfileDetailScreenController extends GetxController {
  var contro = Get.find<HomeController>();
  final formkey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController dd = TextEditingController();
  final TextEditingController mm = TextEditingController();
  final TextEditingController yyyy = TextEditingController();
  var birth = RxList();
  var editBirthDay = RxBool(false);
  var isProfileSaving = RxBool(false);

  @override
  void onInit() {
    getBirthDay();
    username..text = contro.customer.value?.username ?? "";
    email
      ..text = contro.customer.value?.email ?? contro.gUser.value?.email ?? "";
    mobile..text = contro.customer.value?.billing?.phone ?? "";
    super.onInit();
  }

  editBirth() {
    editBirthDay(true);
  }

  getBirthDay() {
    if (contro.customer.value != null) {
      birth.value = contro.customer.value!.metaData!
          .where((element) => element.key == "birthday_field")
          .toList();
    }
  }

  Future updateUserFromAPI(WooCustomer updateData) async {
    isProfileSaving(true);
    if (contro.customer.value != null) {
      // print("aa id che ${updateData.id}");
      try {
        var data = {
          "email": updateData.email,
          "username": updateData.username,
          "billing": {"phone": updateData.billing?.phone},
          "meta_data": [
            {"key": "birthday_field", "value": updateData.metaData?[0].value}
          ]
        };
        var jsond = json.encode(data);

        // ignore: unused_local_variable
        var response = await http.post(
          Uri.parse(
              "https://www.incredibleman.in/wp-json/wc/v3/customers/${updateData.id}?consumer_key=$ck&consumer_secret=$cs"),
          body: jsond,
          headers: {"Content-Type": "application/json"},
          encoding: Encoding.getByName("utf-8"),
        );
        // print(response.body);
        contro.getUserFromWoo(email: updateData.email);
        // ignore: unused_catch_clause
      } on Exception catch (e) {
        isProfileSaving(false);
        rethrow;
      }
    } else {
      // print("aa update profile nathi create kre che ");

      await contro.getUserFromWoo(email: updateData.email);
      await contro.gUser.value?.updateDisplayName(updateData.email);
      contro.gUser.value = FirebaseAuth.instance.currentUser;
    }

    isProfileSaving(false);
  }
}
