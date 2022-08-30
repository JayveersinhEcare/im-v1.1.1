// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../constants/constants.dart';
import '../../../data/reviews/review_model.dart';

class ProductDetailController extends GetxController {
  Rx<List<Reviews>?> reviews = Rx<List<Reviews>?>(null);
  var id;
  final TextEditingController review = TextEditingController();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd – HH:mm:ss");
  var rating = 5.obs;
  var off;
  var data;
  var reviewloading = RxBool(false);

  @override
  void onInit() {
    data = Get.arguments;
    id = data[0]['product'].id;
    if (data[0]['product'].onSale!) {
      var go = double.parse(data[0]['product'].salePrice!) /
          double.parse(data[0]['product'].regularPrice!);

      var tt = go * 100;
      off = 100 - tt.round();
    }
    getReviews();
    super.onInit();
  }

  getReviews() async {
    try {
      var response = await http.get(Uri.parse(
          "https://www.incredibleman.in/wp-json/wc/v3/products/reviews?consumer_key=$ck&consumer_secret=$cs&product=$id"));

      reviews.value = reviewsFromJson(response.body);
      update();

      // ignore: unused_catch_clause
    } on Exception catch (e) {
      rethrow;
    }
  }

  void createReview({
    String? reviewer,
    String? reviewerEmail,
  }) async {
    reviewloading(true);
    var data = {
      'product_id': id,
      'review': review.text,
      'reviewer': reviewer,
      'reviewer_email': reviewerEmail,
      'rating': rating.value,
    };
    var jsone = json.encode(data);

    await http.post(
      Uri.parse(
          "https://www.incredibleman.in/wp-json/wc/v3/products/reviews?consumer_key=ck_e9df4b7d747d2ccc30946837db4d3ef80b215535&consumer_secret=cs_e0d2efcba59453a6883a91b0bbf241d699898151"),
      body: jsone,
      headers: {"Content-Type": "application/json"},
      encoding: Encoding.getByName("utf-8"),
    );

    reviewloading(false);
  }
}
