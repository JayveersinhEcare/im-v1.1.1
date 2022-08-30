import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/constants.dart';

import '../../../utilits/price_loading.dart';
import '../controllers/summary_screen_controller.dart';

class SummaryScreenView extends GetView<SummaryScreenController> {
  const SummaryScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // var controller.isLoading = false;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Shopping details"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Obx(
          () => Container(
            height: 80.0,
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    width: 0.8,
                    color: Colors.black54,
                  ),
                )),
            width: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Total:",
                        style: GoogleFonts.poppins(
                          fontSize: 18.0,
                          color: tabColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller.isLoading.value
                          ? const PriceLoading()
                          : controller.finalprice == 0
                              ? Text(
                                  "$rupee ${controller.contro.cartTotals.value}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  "$rupee ${controller.finalprice}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                    ],
                  ),
                  controller.isLoading.value
                      ? const PriceLoading()
                      : ElevatedButton(
                          onPressed: () {
                            controller.openCheckOut();
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              textStyle: GoogleFonts.poppins(
                                fontSize: 17.0,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              minimumSize: Size(width / 1.8, 60)),
                          child: Text(
                            "PAY NOW",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "PRICE DETAILS",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "(${controller.itemcount} ITEMS)",
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 35,
                    thickness: 0.8,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total MRP",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          controller.isLoading.value
                              ? const PriceLoading()
                              : Text(
                                  "$rupee ${controller.exitGst}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      controller.guj
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "CGST",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    controller.isLoading.value
                                        ? const PriceLoading()
                                        : Text(
                                            "+ $rupee${controller.cgst}",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "SGST",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    controller.isLoading.value
                                        ? const PriceLoading()
                                        : Text(
                                            "+ $rupee${controller.sgst}",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    controller.isLoading.value
                                        ? const PriceLoading()
                                        : Text(
                                            "IGST",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                    controller.isLoading.value
                                        ? const PriceLoading()
                                        : Text(
                                            "+ $rupee${controller.gstadd}",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      controller.isLoading.value
                          ? const PriceLoading()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                controller.shipvalue == 0
                                    ? Text(
                                        "Shipping FEE",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : Text(
                                        "Shipping ${controller.shippingTitle}",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                controller.shipvalue == 0
                                    ? Text(
                                        "FREE",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                        ),
                                      )
                                    : Text(
                                        "+ $rupee ${controller.shipvalue}",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ],
                            ),
                      const SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                  controller.couponvalue == 0.0
                      ? Form(
                          key: controller.formkey,
                          child: TextFormField(
                            controller: controller.coupon,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "No Coupon";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: TextButton(
                                onPressed: () {
                                  if (controller.formkey.currentState!
                                      .validate()) {
                                    controller.couponcheck(
                                        code: controller.coupon.text.trim());
                                  }
                                },
                                child: Text("Check",
                                    style: GoogleFonts.poppins(
                                      color: tabColor,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              border: const OutlineInputBorder(),
                              labelText: 'Coupon Code',
                              hintText: 'Enter secure password',
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Coupon Discount",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "- $rupee ${controller.couponvalue}",
                              style: GoogleFonts.poppins(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Divider(
                    height: 35,
                    thickness: 0.8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      controller.isLoading.value
                          ? const PriceLoading()
                          : controller.finalprice == 0
                              ? Text(
                                  "$rupee ${controller.finalprice}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                )
                              : Text(
                                  "$rupee ${controller.finalprice}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                    ],
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, bottom: 5.0, right: 15.0),
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
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
