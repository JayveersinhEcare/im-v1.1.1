// ignore_for_file: constant_identifier_names

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/data/LocalNotificationService/local_notification_service.dart';
import 'app/data/hiveDB/cartbox.dart';
import 'app/routes/app_pages.dart';

const String Cart_Items = "cart";
const String FavList = "fav";
const String CartBoxDB = "CartBox";

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // print("this is from backGround ${message.data.toString()}");

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // var tk = await FirebaseMessaging.instance.getToken();
  // print("this is token for notification : $tk");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartBoxAdapter());
  await Hive.openBox(Cart_Items);
  await Hive.openBox(FavList);
  await Hive.openBox(CartBoxDB);
  LocalNotificationService.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(
    GetMaterialApp(
      title: "Incredible man ",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0.0,
          // systemOverlayStyle:
          //     SystemUiOverlayStyle(statusBarColor: Colors.white),
          // centerTitle: true,
          color: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
