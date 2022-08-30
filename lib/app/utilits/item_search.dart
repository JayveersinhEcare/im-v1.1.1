import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:incredibleman/app/utilits/search_container.dart';

import '../data/woocommerceModels/woo_products.dart';
import '../modules/homeTabscreen/controllers/home_tabscreen_controller.dart';
import '../routes/app_pages.dart';

class ItemSearch extends SearchDelegate<WooProduct?> {
  ItemSearch();
  var cod = Get.find<HomeTabscreenController>();
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(
          headline6: GoogleFonts.poppins(
        color: Colors.white,
      )),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.black,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
            close(context, null);
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
          // Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<WooProduct> mynew = [];
    mynew = cod.productsAll.value!.where((p) {
      var note = p.name!.toLowerCase();
      return note.contains(query);
    }).toList();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          childAspectRatio: 0.51,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: query.isEmpty ? cod.productsAll.value!.length : mynew.length,
        itemBuilder: (context, index) {
          final WooProduct my =
              query.isEmpty ? cod.productsAll.value![index] : mynew[index];
          // final products = widget.product[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routes.PRODUCT_DETAIL, arguments: [
                {"product": my}
              ]);
            },
            child: SearchContainer(
              price: my.price,
              dec: my.name,
              // dec2: products.name,
              image: my.images![0].src,
              // icon: Icon(
              //   Icons.favorite,
              //   size: 20.0,
              //   color: Hive.box(FavList).containsKey(my.id)
              //       ? Colors.red
              //       : bgcontainer,
              // ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<WooProduct> mynew = [];
    mynew = cod.productsAll.value!.where((p) {
      var note = p.name!.toLowerCase();
      return note.contains(query);
    }).toList();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          childAspectRatio: 0.51,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: query.isEmpty ? cod.productsAll.value!.length : mynew.length,
        itemBuilder: (context, index) {
          final WooProduct my =
              query.isEmpty ? cod.productsAll.value![index] : mynew[index];
          // final products = widget.product[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routes.PRODUCT_DETAIL, arguments: [
                {"product": my}
              ]);
            },
            child: SearchContainer(
              price: my.price,
              dec: my.name,
              // dec2: products.name,
              image: my.images![0].src,
              // icon: Icon(
              //   Icons.favorite,
              //   size: 20.0,
              //   color: Hive.box(FavList).containsKey(my.id)
              //       ? Colors.red
              //       : bgcontainer,
              // ),
            ),
          );
        },
      ),
    );
  }
}
