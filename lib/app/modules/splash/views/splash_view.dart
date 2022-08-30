import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:incredibleman/app/modules/home/views/home_view.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedSplashScreen(
          splashIconSize: 800.00,
          curve: Curves.bounceInOut,
          animationDuration: const Duration(seconds: 5),
          splashTransition: SplashTransition.scaleTransition,
          splash: Center(
            child: Image.asset(
              "assets/images/splashscreen.png",
              fit: BoxFit.fitWidth,
              width: 250,
              // height: 300,
            ),
          ),
          disableNavigation: true,
          backgroundColor: Colors.black,
          nextScreen: const HomeView(),
        ),
      ),
    );
  }
}
