import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:incredibleman/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';
import '../../../constants/constants.dart';
import '../controllers/thank_you_screen_controller.dart';

class ThankYouScreenView extends GetView<ThankYouScreenController> {
  const ThankYouScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 70.0,
          title: Text(
            "Confirmation",
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SizedBox(
          // color: Colors.amber,
          width: double.infinity,
          child: Center(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LottieBuilder.asset(
                        checkmark,
                        height: 350.0,
                        repeat: false,
                      ),
                      Text(
                        "Order Placed",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Thank you! your order has been placed",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "successfully",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
                LottieBuilder.asset(
                  samplecong,
                  reverse: false,
                  repeat: false,
                ),
                Positioned(
                  bottom: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          textStyle: GoogleFonts.poppins(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          minimumSize: const Size(356, 50)),
                      onPressed: () {
                        Get.offAllNamed(Routes.HOME);
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Continue Shopping"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
