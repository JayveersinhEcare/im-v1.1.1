import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:incredibleman/app/data/hiveDB/cartbox.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../main.dart';
import '../../../constants/constants.dart';
import '../../../data/reviews/review_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utilits/review_container.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/product_detail_controller.dart';

// ignore: must_be_immutable
class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contro = Get.find<HomeController>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 8,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                contro.addToCart(
                    controller.data[0]['product'].id,
                    CartBox(
                        1,
                        controller.data[0]['product'].id,
                        controller.data[0]['product'].name,
                        controller.data[0]['product'].onSale
                            ? controller.data[0]['product'].salePrice
                            : controller.data[0]['product'].regularPrice,
                        controller.data[0]['product'].images[0].src ?? "",
                        true));
                Get.snackbar("Add to Cart", "Product has been added to cart",
                    colorText: Colors.white,
                    backgroundColor: Colors.black,
                    mainButton: TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.CART);
                        },
                        child: const Text("Go To Cart")));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                // elevation: 5.0,
                side: const BorderSide(
                  color: Colors.black12,
                ),
                padding: const EdgeInsets.all(8.0),
                minimumSize: Size(width / 2.6, 50),
              ),
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black45,
              ),
              label: const Text(
                "ADD CART",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding: const EdgeInsets.all(8.0),
                minimumSize: Size(width / 2.0, 50),
              ),
              onPressed: () async {
                // print(contro.customer.value?.billing?.address1);
                contro.gUser.value != null &&
                            contro.customer.value?.billing?.address1 == null ||
                        contro.customer.value?.billing?.address1 == ""
                    ? Get.toNamed(Routes.ADDRESS_SCREEN)
                    : contro.gUser.value == null
                        ? contro.openLogin(context)
                        : Get.toNamed(Routes.CHECK_ADDRESS_SCREEN, arguments: [
                            {
                              "product": [
                                CartBox(
                                    1,
                                    controller.data[0]['product'].id,
                                    controller.data[0]['product'].name,
                                    controller.data[0]['product'].onSale
                                        ? controller
                                            .data[0]['product'].salePrice
                                        : controller
                                            .data[0]['product'].regularPrice,
                                    controller
                                            .data[0]['product'].images[0].src ??
                                        "",
                                    true),
                              ]
                            }
                          ]);
              },
              icon: const Icon(
                Icons.shopping_bag,
              ),
              label: const Text("BUY NOW"),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  color: bg,
                  child: CarouselSlider.builder(
                    itemCount: controller.data[0]['product'].images!.length,
                    options: CarouselOptions(
                      aspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.6),
                      // aspectRatio: 12 / 12,
                      viewportFraction: 1,

                      // height: 400,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      scrollDirection: Axis.horizontal,
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      final image =
                          controller.data[0]['product'].images![index].src;
                      // print("${widget.data.description}");
                      return Image.network(
                        image!,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade400,
                            highlightColor: Colors.grey.shade100,
                            period: const Duration(milliseconds: 1200),
                            child: Container(
                              width: 500,
                              color: Colors.white,
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: height / 50.0,
                  left: width / 30.0,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height / 50.0,
                  left: width / 1.16,
                  child: Obx(() => Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Badge(
                          badgeColor: tabColor,
                          padding: const EdgeInsets.all(3.0),
                          position: const BadgePosition(
                            bottom: 18.0,
                            start: 22.0,
                          ),
                          badgeContent: Center(
                            child: Text(
                              "${contro.cartCount.value}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8.0,
                              ),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                            ),
                            onPressed: () {
                              Get.toNamed(Routes.CART);
                            },
                          ),
                        ),
                      )),
                ),
                Positioned(
                  top: height / 50.0,
                  left: width / 1.35,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.share,
                      ),
                      onPressed: () {
                        Share.share(
                            "Discover the great experience of all-natural skincare and grooming products. Shop for the best natural and organic skincare products only at Incredible Man. \n${controller.data[0]['product'].name}  \n${controller.data[0]['product'].permalink}");
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.data[0]['product'].name,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          controller.data[0]['product'].name,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: [
                            controller.data[0]['product'].onSale
                                ? Text(
                                    rupee +
                                        controller
                                            .data[0]['product'].salePrice!,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  )
                                : Text(
                                    rupee +
                                        controller
                                            .data[0]['product'].regularPrice!,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Visibility(
                              visible: controller.data[0]['product'].onSale!,
                              child: Text(
                                rupee +
                                    controller.data[0]['product'].regularPrice!,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                  fontSize: 15.0,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Visibility(
                              visible: controller.data[0]['product'].onSale!,
                              child: Text(
                                "(${controller.off}% OFF)",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: tabColor,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Obx(() {
                    // contro.isSaveCheck(one[0]['product'].id);
                    return contro.isSaveLoading.value
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 18.0,
                              left: 15.0,
                            ),
                            child: Container(
                              height: 45.0,
                              width: 45.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(
                                      5.0,
                                      5.0,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if (Hive.box(FavList).containsKey(
                                      controller.data[0]['product'].id)) {
                                    contro.favRemove(
                                        controller.data[0]['product'].id);
                                  } else {
                                    contro.addFav(
                                        controller.data[0]['product'].id,
                                        controller.data[0]['product'].id);
                                  }
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: Hive.box(FavList).containsKey(
                                          controller.data[0]['product'].id)
                                      ? Colors.red
                                      : bgcontainer,
                                ),
                                iconSize: 30.0,
                              ),
                            ),
                          );
                  }),
                  const SizedBox(
                    width: 40.0,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                thickness: 1.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Product Details",
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      controller.data[0]['product'].shortDescription.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 13.0,
                      ),
                    ),
                  ),

                  //////////////////////////////////html tag //////////////////////////////
                  // Html(
                  //   data: widget.data.shortDescription,
                  // ),
                  /////////////////////////////////html tag////////////////////////////////
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "General",
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            controller.data[0]['product'].metaData!.length,
                        itemBuilder: (context, index) {
                          final customedata =
                              controller.data[0]['product'].metaData![index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  customedata.key!,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black45,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  customedata.value!,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, bottom: 5.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    // height: 90,
                    width: 80,
                    // color: Colors.red,
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Image.asset(
                            noContact,
                            scale: 2.5,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "No Contact",
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Delivery",
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    // height: 90,
                    width: 80,
                    // color: Colors.red,
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Image.asset(
                            deliverd,
                            scale: 2.5,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Timely",
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Delivered",
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    // height: 90,
                    width: 80,
                    // color: Colors.red,
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Image.asset(
                            reture,
                            scale: 2.5,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Easy",
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Return",
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    // height: 90,
                    width: 80,
                    // color: Colors.red,
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Image.asset(
                            pay,
                            scale: 2.5,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Secure",
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Payment",
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Obx(() => contro.gUser.value != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 5.0, right: 15.0),
                        child: Text(
                          "Leave feedback about this",
                          style: GoogleFonts.poppins(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 5.0, right: 15.0),
                        child: RatingBar.builder(
                          initialRating: 5,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemSize: 25,
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: tabColor,
                          ),
                          onRatingUpdate: (rating) {
                            controller.rating.value = rating.toInt();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 5.0, right: 15.0),
                        child: TextField(
                          maxLines: 5,
                          controller: controller.review,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Describe your review",
                            fillColor: Color.fromARGB(255, 235, 234, 234),
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 5.0, right: 15.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            controller.createReview(
                              reviewer: contro.customer.value?.username ??
                                  contro.customer.value?.email ??
                                  "user",
                              reviewerEmail: contro.customer.value?.email ?? "",
                            );
                            controller.review.clear();
                            Get.snackbar(
                              "Review Added",
                              "Your Review has been Added",
                              colorText: Colors.white,
                              backgroundColor: Colors.black,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: tabColor,
                          ),
                          child: const Text(
                            "Submit",
                          ),
                        ),
                      ),
                    ],
                  )
                : Container()),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, bottom: 5.0, right: 15.0),
              child: Text(
                "Reviews",
                style: GoogleFonts.poppins(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            GetBuilder<ProductDetailController>(
              builder: ((controller) => controller.reviews.value == null
                  ? const Center(child: CircularProgressIndicator())
                  : controller.reviews.value!.isEmpty
                      ? const Center(child: Text("No Reviews yet"))
                      : ListView.builder(
                          itemCount: controller.reviews.value!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final Reviews dd = controller.reviews.value![index];
                            var ddd =
                                controller.dateFormat.format(dd.dateCreated!);
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, bottom: 35.0, right: 15.0),
                              child: ReviewContainer(
                                img: dd.reviewerAvatarUrls?.entries.first.value,
                                name: dd.reviewer,
                                reviews: dd.review,
                                rate: dd.rating,
                                date: ddd.toString().substring(0, 10),
                              ),
                            );
                          },
                        )),
            ),
            const SizedBox(
              height: 100.0,
            ),
          ],
        ),
      ),
    ));
  }
}
