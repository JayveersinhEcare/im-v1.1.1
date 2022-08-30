// ignore_for_file: constant_identifier_names, unnecessary_null_comparison, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:incredibleman/app/data/hiveDB/cartbox.dart';
import 'package:incredibleman/app/data/woocommerceModels/woo_create_order.dart';
import 'package:incredibleman/app/data/woocommerceModels/woo_customer.dart';
import 'package:incredibleman/app/modules/splash/controllers/splash_controller.dart';
import 'package:incredibleman/app/routes/app_pages.dart';
import 'package:new_version/new_version.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../../constants/constants.dart';
import '../../../data/couponModel/coupon_model.dart';
import '../../../data/shippingModel/shipping_model.dart';
import '../../../data/woocommerceModels/woo_products.dart';
import '../../homeTabscreen/controllers/home_tabscreen_controller.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class HomeController extends GetxController {
  var cod = Get.put(HomeTabscreenController());
  var controSplash = Get.put(SplashController());
  var favCount = RxInt(0);
  var cartCount = RxInt(0);
  var isSave = RxBool(false);
  var isSaveLoading = RxBool(false);
  var isOTPLoading = RxBool(false);
  var isOrderLoading = RxBool(false);
  var verificationIdOk = RxString("");
  // ignore: non_constant_identifier_names
  var OTPcode = RxString("");
  var enable = RxBool(false);
  var resend = RxInt(60);
  Rx<List<CartBox>?> cartItems = Rx<List<CartBox>?>(null);
  Rx<List<WooProduct>?> favItems = Rx<List<WooProduct>?>(null);
  Rx<WooCustomer?> customer = Rx<WooCustomer?>(null);
  Rx<List<WooOrder>?> orders = Rx<List<WooOrder>?>([]);
  final _googleSignin = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);
  Rx<User?> gUser = Rx<User?>(null);
  // var opd = FirebaseAuth.instance.authStateChanges();
  Rx<MobileVerificationState> mobileVerificationState =
      Rx<MobileVerificationState>(
          MobileVerificationState.SHOW_MOBILE_FORM_STATE);
  Rx<int?> uid = Rx<int?>(null);

  TextEditingController numbertext = TextEditingController();

  var cartTotals = RxString("0");

  late Timer timer;
  @override
  void onInit() async {
    FirebaseAuth.instance.currentUser?.reload();
    gUser.value = FirebaseAuth.instance.currentUser;
    gUser.bindStream(FirebaseAuth.instance.authStateChanges());
    getCount();
    getCartCount();
    getCartTotal();
    getFavItems();
    // print(gUser.value?.displayName);
    // print(" aa email ${gUser.value?.email}");

    await getOrders();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final data = message.data['id'];
        final name = message.data['name'];
        // print("aa getinitial che  background che");
        Get.toNamed(Routes.CATEGORY, arguments: [
          {"id": data},
          {"name": name}
        ]);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      final data = event.data['id'];
      final name = event.data['name'];
      // print("aa on message listen che foreground  che $data and $name");
      // var tk = await FirebaseMessaging.instance.getToken();
      // print("this is token for notification : $tk");
      Get.toNamed(Routes.CATEGORY, arguments: [
        {"id": data},
        {"name": name}
      ]);
    });
    super.onInit();
    final newVersion = NewVersion(
      iOSAppStoreCountry: "IN",
      iOSId: "com.incredibleman.incredibleman",
    );
    // print(newVersion.androidId);
    // newVersion.showAlertIfNecessary(context: Get.context!);
    final status = await newVersion.getVersionStatus();
    // print(" aa store version che ${status!.storeVersion}");
    // print(" aa local version che ${status.localVersion}");
    // print(" aa canupdate che ${status.canUpdate}");
    // // print(status!.appStoreLink);
    if (status != null && status.canUpdate) {
      newVersion.showUpdateDialog(
        context: Get.context!,
        versionStatus: status,
        dialogText: "please update the app for latest features",
        dialogTitle: "Update Available",
        allowDismissal: false,
      );
    }
  }

  @override
  void onReady() async {
    // print("i am ready for all");
    if (gUser.value?.email == null || gUser.value!.email!.isEmpty) {
      // print("email null");
      await getUserFromWoo(email: gUser.value?.displayName);
    } else {
      // print("email not null");
      await getUserFromWoo(email: gUser.value?.email);
    }
    super.onReady();
  }

  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  isSaveCheck(key) {
    isSaveLoading(true);
    if (Hive.box(FavList).containsKey(key).obs.value) {
      isSave(true);
      isSaveLoading(false);
      // print("issave");
    } else {
      isSave(false);
      isSaveLoading(false);
      // print("isnotsave");
    }
  }

  void addFav(key, value) async {
    Hive.box(FavList).put(key, value);
    // print("add fav");
    isSaveCheck(key);
    getCount();
    getFavItems();
  }

  void favRemove(product) {
    Hive.box(FavList).delete(product);
    isSaveCheck(product);
    // print("remove fav");
    getCount();
    getFavItems();
  }

  void getCount() {
    favCount.value = Hive.box(FavList).values.length;
    // print("count fav");
  }

  void addToCart(key, value) {
    isSaveLoading(true);
    Hive.box(CartBoxDB).put(key, value);
    getCartCount();
    // print(" adding Item to Cart");
    getCartTotal();
    isSaveLoading(false);
  }

  void removeCartItem(product) {
    isSaveLoading(true);
    Hive.box(CartBoxDB).delete(product);
    getCartCount();
    // print(" Deleting Item to Cart");
    getCartTotal();
    isSaveLoading(false);
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        // print("timer chalu che");
        if (resend.value == 0) {
          timer.cancel();
          enable(true);
          resend(60);
        } else {
          enable(false);
          resend.value--;
        }
      },
    );
  }

  void getCartCount() {
    cartCount.value = Hive.box(CartBoxDB).values.length;
    // print("count of Cart is ${cartCount.value}");
  }

  void getCartTotal() {
    isSaveLoading(true);
    cartItems.value = Hive.box(CartBoxDB).values.toList().cast<CartBox>();
    var calculator = cartItems.value
        ?.map((element) => double.parse(element.price) * element.quntity)
        .fold(0, (p, element) => double.parse(p.toString()) + element);
    cartTotals.value = calculator.toString();
    // print("Calculating Total ${cartTotals.value}");
    isSaveLoading(false);
  }

  void getFavItems() {
    isSaveLoading(true);
    var favdata = Hive.box(FavList).values.toList().obs;
    favItems.value = cod.productsAll.value
        ?.where((element) => favdata.contains(element.id))
        .toList();
    getCount();
    isSaveLoading(false);
  }

  void sampleDatacheck() {
    isSaveLoading(true);
    var del =
        cartItems.value?.where((element) => element.sample == false).toList();

    if (del!.isNotEmpty) {
      if (double.parse(cartTotals.value) <= 700.0 && del.length != null) {
        if (del != null) {
          for (var i = 0; i < del.length; i++) {
            removeCartItem(del[i].id);
            getCartCount();
          }
        }
      } else if (double.parse(cartTotals.value) <= 1200.0 &&
          del.length >= 2 &&
          double.parse(cartTotals.value) >= 700.0) {
        if (del != null) {
          removeCartItem(del[0].id);
          getCartCount();
        }
      }
    }

    isSaveLoading(false);
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    isOTPLoading.value = true;
    try {
      final authCredential =
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        gUser.value = authCredential.user;
        isOTPLoading.value = false;
        await getUserFromWoo(email: gUser.value?.displayName);
        Get.back();
      }
    } on FirebaseAuthException catch (e) {
      isOTPLoading.value = false;
      // print(e.message);
      Get.snackbar(
        "Error",
        e.message ?? "please try Again",
        colorText: Colors.white,
        backgroundColor: Colors.black,
      );
    }
  }

  openLogin(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        builder: (context) {
          return Obx(
            () => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: 550,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        color: Colors.black,
                        child: Image.asset(
                          loginlogo,
                          scale: 3.5,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      mobileVerificationState.value ==
                              MobileVerificationState.SHOW_MOBILE_FORM_STATE
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, top: 10.0, bottom: 1.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Mobile No.",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30.0,
                                    right: 30.0,
                                    top: 5,
                                    bottom: 10.0,
                                  ),
                                  // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                                  child: TextFormField(
                                    maxLength: 10,
                                    keyboardType: TextInputType.phone,
                                    controller: numbertext,

                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "please Enter Valid Number";
                                      }
                                      return null;
                                    },
                                    // controller: _username,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefix: Text("+91"),
                                      labelText: '+91 |',
                                      counterText: "",

                                      // hintText: '+91 | ',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                isOTPLoading.value
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.black54),
                                      )
                                    : ElevatedButton(
                                        onPressed: () async {
                                          isOTPLoading.value = true;
                                          await FirebaseAuth.instance
                                              .verifyPhoneNumber(
                                            phoneNumber:
                                                "+91${numbertext.text.trim()}",
                                            verificationCompleted:
                                                (phoneAuthCredential) async {
                                              // print("we are verified");
                                            },
                                            verificationFailed:
                                                (verificationFailed) async {
                                              isOTPLoading.value = false;
                                              Get.snackbar(
                                                "Failed",
                                                verificationFailed.message ??
                                                    "Failed To verified",
                                                colorText: Colors.white,
                                                backgroundColor: Colors.black,
                                              );
                                              // print(verificationFailed.message);
                                            },
                                            codeSent: (verificationId,
                                                resendingToken) async {
                                              verificationIdOk.value =
                                                  verificationId;
                                              isOTPLoading.value = false;
                                              mobileVerificationState.value =
                                                  MobileVerificationState
                                                      .SHOW_OTP_FORM_STATE;
                                            },
                                            codeAutoRetrievalTimeout:
                                                (verificationId) async {},
                                          );
                                          startTimer();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: tabColor,
                                          textStyle: GoogleFonts.poppins(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.20,
                                              50),
                                        ),
                                        child: const Text("Generate OTP"),
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Center(
                                  child: Text("OR"),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                isSaveLoading.value
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.black54),
                                      )
                                    : ElevatedButton.icon(
                                        onPressed: () {
                                          loginwithGoogle();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          textStyle: GoogleFonts.poppins(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.20,
                                              50),
                                        ),
                                        label: const Text(
                                          "  Sign in with Google",
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        icon: const Image(
                                          image: AssetImage(
                                              "assets/images/google_logo.png"),
                                          height: 25.0,
                                        ),
                                      ),
                              ],
                            )
                          : Column(
                              children: [
                                const SizedBox(
                                  height: 45,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, top: 20.0, bottom: 10.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "OTP Verification",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    top: 10.0,
                                    bottom: 1.0,
                                    right: 30,
                                  ),
                                  child: PinCodeTextField(
                                    length: 6,
                                    obscureText: false,
                                    keyboardType: TextInputType.number,
                                    validator: (v) {
                                      if (v!.length < 6) {
                                        return "Invalid OTP ";
                                      } else {
                                        return null;
                                      }
                                    },
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      activeColor: tabColor,
                                      activeFillColor: Colors.yellow,
                                      selectedColor: tabColor,
                                      inactiveColor: Colors.black45,
                                    ),
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    onCompleted: (v) {
                                      debugPrint("Completed");
                                    },
                                    onChanged: (value) {
                                      debugPrint(value);
                                      OTPcode(value);
                                    },
                                    beforeTextPaste: (text) {
                                      return true;
                                    },
                                    appContext: context,
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                isOTPLoading.value
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.black54),
                                      )
                                    : ElevatedButton(
                                        onPressed: () async {
                                          if (OTPcode.value.length >= 6) {
                                            PhoneAuthCredential
                                                phoneAuthCredential =
                                                PhoneAuthProvider.credential(
                                              verificationId:
                                                  verificationIdOk.value,
                                              smsCode: OTPcode.value,
                                            );
                                            signInWithPhoneAuthCredential(
                                                phoneAuthCredential);
                                            gUser.value = FirebaseAuth
                                                .instance.currentUser;
                                            await getUserFromWoo(
                                                email: gUser.value?.displayName
                                                    ?.trim());
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: tabColor,
                                          textStyle: GoogleFonts.poppins(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.20,
                                              50),
                                        ),
                                        child: const Text("Verify & Continue"),
                                      ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                  onPressed: enable.value
                                      ? () async {
                                          await FirebaseAuth.instance
                                              .verifyPhoneNumber(
                                            phoneNumber:
                                                "+91${numbertext.text.trim()}",
                                            verificationCompleted:
                                                (phoneAuthCredential) async {
                                              // print("hello");
                                            },
                                            verificationFailed:
                                                (verificationFailed) async {
                                              isOTPLoading.value = false;
                                              Get.snackbar(
                                                "Failed",
                                                verificationFailed.message ??
                                                    "Failed To verified",
                                                colorText: Colors.white,
                                                backgroundColor: Colors.black,
                                              );
                                              // print(verificationFailed.message);
                                            },
                                            codeSent: (verificationId,
                                                resendingToken) async {
                                              verificationIdOk.value =
                                                  verificationId;
                                            },
                                            codeAutoRetrievalTimeout:
                                                (verificationId) async {},
                                          );
                                          startTimer();
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    primary: tabColor,
                                    textStyle: GoogleFonts.poppins(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width /
                                            1.20,
                                        50),
                                  ),
                                  child: Text(
                                      "Resend Code ${resend.value == 60 ? "" : resend.value} "),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        context: context);
  }

  loginwithGoogle() async {
    isSaveLoading(true);
    googleAccount.value = await _googleSignin.signIn();

    if (googleAccount.value == null) {
      isSaveLoading(false);
      Get.back();
      return;
    }
    final googleAuth = await googleAccount.value?.authentication;
    final credentail = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential p =
        await FirebaseAuth.instance.signInWithCredential(credentail);
    gUser.value = FirebaseAuth.instance.currentUser;
    // print(" aa google auth che  ${p.user?.displayName}");
    await getUserFromWoo(email: googleAccount.value?.email);
    // if (customer.value == null) {
    //   print("aa new customer banave che");
    //   WooCustomer customerk = WooCustomer(
    //     firstName: p.user?.displayName,
    //     lastName: p.user?.email,
    //     username: p.user?.email,
    //     email: p.user?.email,
    //     password: getRandomString(8),
    //   );
    //   await cod.cod.wooCommerce.value.createCustomer(customerk);
    // }
    isSaveLoading(false);
    Get.back();
  }

  logoutGoogle() async {
    googleAccount.value = await _googleSignin.signOut();

    await FirebaseAuth.instance.signOut();
    // print(googleAccount.value?.displayName);
    gUser.value = null;
    customer.value = null;
    mobileVerificationState.value =
        MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  }

  Future getUserFromWoo({String? email}) async {
    if (email != null) {
      var newemail = email.trim();

      // print("aa user new email che : ${newemail}hh");
      List<WooCustomer> customers = [];
      var response = await http.get(Uri.parse(
          "https://www.incredibleman.in/wp-json/wc/v3/customers?consumer_key=$ck&consumer_secret=$cs&email=$newemail"));
      // print("a che respone : ${response.body}");
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        for (var c in data) {
          var customer = WooCustomer.fromJson(c);
          customers.add(customer);
        }
        if (customers.isNotEmpty) {
          uid.value = customers[0].id;
          customer.value = customers[0];
          // print("okk che");
        } else {
          // print("aa new customer banave che");
          WooCustomer customerk = WooCustomer(
            firstName: gUser.value?.email ?? email,
            lastName: gUser.value?.email ?? "",
            username: gUser.value?.email ?? email,
            email: gUser.value?.email ?? email,
            password: getRandomString(8),
          );
          await cod.cod.wooCommerce.value.createCustomer(customerk);
          await getUserFromWoo(email: email.trim());
        }
      } else {
        // print("response null");
      }
    }
    // print("get user");
  }

  final chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => chars.codeUnitAt(
            _rnd.nextInt(chars.length),
          ),
        ),
      );

  Future<List<ShippingModel>> shippingDatat({required int id}) async {
    try {
      var response = await http.get(Uri.parse(
          "https://www.incredibleman.in/wp-json/wc/v3/shipping/zones/$id/methods?consumer_secret=cs_e0d2efcba59453a6883a91b0bbf241d699898151&consumer_key=ck_e9df4b7d747d2ccc30946837db4d3ef80b215535"));

      final shippingModel = shippingModelFromJson(response.body);
      return shippingModel;
    } on Exception {
      rethrow;
    }
  }

  Future<List<CouponModel>> couponCheck({required String code}) async {
    try {
      var response = await http.get(
        Uri.parse(
            "https://www.incredibleman.in/wp-json/wc/v3/coupons?consumer_secret=$cs&consumer_key=$ck&code=$code"),
      );

      final coup = couponModelFromJson(response.body);

      return coup;
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      rethrow;
    }
  }

  getOrders() async {
    if (customer.value != null) {
      isOrderLoading(true);
      // print("aa order lave che");
      var response = await http.get(Uri.parse(
          'https://www.incredibleman.in/wp-json/wc/v3/orders?consumer_key=$ck&consumer_secret=$cs&customer=${customer.value?.id}'));

      List<dynamic> data = json.decode(response.body);
      // print(data);
      for (var o in data) {
        orders.value!.add(
          WooOrder(
            id: o['id'],
            status: o['status'],
            parentId: o['parentId'],
            number: o['number'],
            total: o['total'],
            lineItems: List<LineItems>.from(
                o["line_items"].map((x) => LineItems.fromJson(x))).toList(),
            totalTax: o['total_tax'],
            customerId: o['customer_id'],
            cartTax: o['cart_tax'],
            shippingTotal: o['shipping_total'],
            transactionId: o['transaction_id'],
            taxLines: List<TaxLines>.from(
                o['tax_lines'].map((x) => TaxLines.fromJson(x))).toList(),
            shippingLines: List<ShippingLines>.from(
                    o['shipping_lines'].map((x) => ShippingLines.fromJson(x)))
                .toList(),
            // couponLines: o['coupon_lines'],
          ),
        );
      }
      isOrderLoading(false);
    }
  }
}
