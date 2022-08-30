// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:incredibleman/app/modules/home/controllers/home_controller.dart';
import 'package:incredibleman/app/routes/app_pages.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../main.dart';
import '../../../data/couponModel/coupon_model.dart';
import '../../../data/hiveDB/cartbox.dart';
import '../../../data/woocommerceModels/woo_order_payload.dart';

class SummaryScreenController extends GetxController {
  var isLoading = RxBool(true);
  var igst = 18;
  var exitGst;
  var guj = false;
  var cgst;
  var sgst;
  var gstadd;
  var gstvalue;
  var finalprice;
  var shipvalue;
  var shippingid;
  var shippingTitle;
  var state = "GUJARAT";
  var couponvalue = 0.0;
  var coupencode;
  var coupenid;
  var contro = Get.find<HomeController>();
  final TextEditingController coupon = TextEditingController();
  final formkey = GlobalKey<FormState>();
  Razorpay razorpay = Razorpay();
  var arg;
  List<CartBox>? items;
  var totalValue;
  var itemcount;
  var quti = 0;
  var xitemDiscount = 0.0;
  var disxItem = 5;
  @override
  void onInit() {
    state = contro.customer.value?.billing?.state ?? "";
    arg = Get.arguments;
    // print("aa che arg $arg");
    // print(arg[0]['product'][0].id);
    if (arg == null) {
      items = contro.cartItems.value;
      totalValue = contro.cartTotals.value;
      itemcount = contro.cartCount.value;
    } else {
      items = [arg[0]['product'][0]];
      totalValue = arg[0]['product'][0].price;
      itemcount = 1;
      print(arg[0]['product'][0].id);
    }
    var getfinaldis = items
        ?.where((element) => element.quntity > 1 && element.price != "0")
        .toList();
    print(getfinaldis?.length);

    for (var i = 0; i < items!.length; i++) {
      if (items![i].price != "0") {
        quti += items![i].quntity;
      }
    }

    print("qunti $quti");
    print("final discount price $xitemDiscount");

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    check();
    super.onInit();
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    orderDone(response.paymentId!);

    Get.snackbar(
      "Payment",
      "Payment Success: ${response.paymentId}",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.toNamed(Routes.THANK_YOU_SCREEN);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      "Payment",
      "Payment Faild: Please try agian",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar(
      "walletName",
      "Payment wallet: ${response.walletName}",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void openCheckOut() async {
    var price = double.parse(finalprice.toString());

    var options = {
      'key': "rzp_live_gGSvf9bRFy4JYi",
      'amount': price * 100, //in the smallest currency sub-unit.
      'name': 'Incredible Man',
      // 'order_id': 'newtest', // Generate order_id using Orders API
      // 'description': ,
      // 'timeout': 60, // in seconds
      'prefill': {
        'contact': contro.customer.value?.billing?.phone,
        'email': contro.customer.value?.billing?.email
      },
      'external': {
        'wallets': ['paytm', 'gpay']
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      // print("aa razor ni error che $e");
    }
  }

  void orderDone(String id) async {
    WooOrderPayload orderPayload = WooOrderPayload(
      customerId: contro.customer.value?.id,
      paymentMethod: "razorpay",
      setPaid: true,
      metaData: [
        WooOrderPayloadMetaData(
          key: "_transaction_id",
          value: id,
        ),
      ],
      lineItems: items!
          .map(
            (e) => LineItems(
              productId: e.id,
              quantity: e.quntity,
              name: e.name,
            ),
          )
          .toList(),
      billing: WooOrderPayloadBilling(
        address1: contro.customer.value?.billing!.address1,
        address2: contro.customer.value?.billing!.address2,
        firstName: contro.customer.value?.firstName,
        city: contro.customer.value?.billing!.city,
        postcode: contro.customer.value?.billing!.postcode,
        state: contro.customer.value?.billing!.state,
        phone: contro.customer.value?.billing!.phone,
        email: contro.customer.value?.billing!.email,
      ),
      shipping: WooOrderPayloadShipping(
        address1: contro.customer.value?.billing!.address1,
        address2: contro.customer.value?.billing!.address2,
        firstName: contro.customer.value?.firstName,
        city: contro.customer.value?.billing!.city,
        postcode: contro.customer.value?.billing!.postcode,
        state: contro.customer.value?.billing!.state,
      ),
      couponLines: couponvalue == 0.0
          ? []
          : [
              WooOrderPayloadCouponLines(
                code: coupencode,
              )
            ],
      shippingLines: [
        ShippingLines(
          methodId: shippingid,
          methodTitle: shippingTitle,
          total: shipvalue.toString(),
        ),
      ],
    );

    await contro.cod.wooCommerce.value?.createOrder(orderPayload);
    Hive.box(CartBoxDB).clear();
  }

  void check() {
    // Future.delayed(const Duration(seconds: 10), () {
    //   isLoading(false);
    // });
    getAddre(price: totalValue);
    // getGSTCalculation();
  }

  void getGSTCalculation({price}) {
    var ty = igst / 100;
    var hh = ty + 1;
    print(ty);
    print(hh);

    exitGst = (double.parse(price) / hh).roundToDouble();
    print(exitGst);
    if (guj) {
      cgst = (exitGst * 9) / 100;
      print(cgst);
      sgst = (exitGst * 9) / 100;
      print(sgst);
      gstadd = (exitGst * igst) / 100;
      print(gstadd);
      gstvalue = (exitGst + gstadd).roundToDouble();
      print("aa jo to value $gstvalue");
      print("aa shiping value jo to $shipvalue");
      finalprice = gstvalue + shipvalue;
      print(
          " aa guju che and final price che gst and shipping sathe $finalprice");
    } else {
      gstadd = (exitGst * igst) / 100;
      print(gstadd);
      gstvalue = (exitGst + gstadd).roundToDouble();
      print(gstvalue);
      finalprice = gstvalue + shipvalue;
      print(
          " aa guju che and final price che gst and shipping sathe $finalprice");
    }
  }

  getAddre({price}) async {
    print("aa first $price");
    var ty = igst / 100;
    var hh = ty + 1;
    print(ty);
    print(hh);

    exitGst = (double.parse(price) / hh).roundToDouble();
    // // exitGst = double.parse(widget.price);
    // print(exitGst);

    if (state == "GUJARAT" ||
        state == "GUJRAT" ||
        state == "Gujarat" ||
        state == "gujarat" ||
        state == "GJ" ||
        state == "gj") {
      cgst = (exitGst * 9) / 100;
      print(cgst);
      sgst = (exitGst * 9) / 100;
      print(sgst);
      gstadd = (exitGst * igst) / 100;
      print(gstadd);
      gstvalue = (exitGst + gstadd).roundToDouble();
      print(gstvalue);

      guj = true;
      getShipping(isgujju: guj);
      print("gujju che uper");
      return;
    }
    gstadd = (exitGst * igst) / 100;
    print(gstadd);
    gstvalue = (exitGst + gstadd).roundToDouble();
    print(gstvalue);
    getShipping(isgujju: guj);
    print("guuju nathi uper");
  }

  getShipping({required bool isgujju}) async {
    if (isgujju) {
      try {
        var ch = await contro.shippingDatat(id: 2);
        shipvalue = int.parse(ch[0].settings?.cost?.value ?? "75");
        shippingid = ch[0].methodId!;
        shippingTitle = ch[0].methodTitle!;
        finalprice = gstvalue + shipvalue;
        print("gujju che niche");
        isLoading(false);
      } catch (e) {
        isLoading(false);
        Get.defaultDialog(
            title: "Ooops...",
            content: const Text("Somthing went wrong please try again"));
      }
    } else {
      try {
        var ch = await contro.shippingDatat(id: 1);
        shipvalue = int.parse(ch[0].settings?.cost?.value ?? "75");
        shippingid = ch[0].methodId!;
        shippingTitle = ch[0].methodTitle!;
        finalprice = gstvalue + shipvalue;
        print("guuju nathi niche ");
        isLoading(false);
      } catch (e) {
        isLoading(false);
        Get.defaultDialog(
            title: "Ooops...",
            content: const Text("Somthing went wrong please try again"));
      }
    }
  }

  couponcheck({required String code}) async {
    isLoading(true);
    print(code);
    try {
      var cop = await contro.couponCheck(code: code);
      if (cop.isNotEmpty) {
        var disType = cop[0].discountType;

        var usageLimit = cop[0].usageLimit;
        var emailcheck = cop[0].emailRestrictions;

        // var limitperuser = cop[0].usageLimitPerUser;

        var usedby = cop[0].usedBy;
        // var usedby = [
        //   'jayveersinh.ecareinfoway@gmail.com',
        // ];
        var usagecount = cop[0].usageCount;

        // ignore: unused_local_variable
        List<int>? productid = cop[0].productIds;

        print(disType);

        if (cop[0].dateExpires != null) {
          var now = DateTime.now();
          var check = now.isBefore(DateTime.parse(cop[0].dateExpires));

          if (cop.isEmpty || !check) {
            isLoading(false);
            Get.snackbar(
              "Expired Coupon",
              "This coupon has expired. ",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          } else if (disType == "percent") {
            couponCheckPer(
              cop: cop,
              usageLimit: usageLimit,
              usagecount: usagecount,
              emailcheck: emailcheck,
              usedby: usedby,
              // productsId: productid,
            );
            ///////////////////
          } else {
            print("fixed cart");
            couponCheckFlat(
              cop: cop,
              usageLimit: usageLimit,
              usagecount: usagecount,
              emailcheck: emailcheck,
              usedby: usedby,
            );
          }
        } else {
          print("expired vagar nu che");
          if (disType == "percent") {
            print("percentage vadu che ");
            couponCheckPer(
              cop: cop,
              usageLimit: usageLimit,
              usagecount: usagecount,
              emailcheck: emailcheck,
              usedby: usedby,
            );
          } else {
            print("flat amount   che ");
            couponCheckFlat(
              cop: cop,
              usageLimit: usageLimit,
              usagecount: usagecount,
              emailcheck: emailcheck,
              usedby: usedby,
            );
          }
        }
      } else {
        couponError();
      }
    } on Exception {
      // print("aa error vado block che $e");
      couponError();
      rethrow;

      // print("aa error che $e");
      // couponError();
    }
  }

  couponCheckPer({
    required List<CouponModel> cop,
    int? usageLimit,
    int? usagecount,
    List<String>? emailcheck,
    List<String>? usedby,
    List<int>? productsId,
  }) {
    if (_checkUsageLimit(cop[0].usageLimit) &&
        _checkEmailRestrictions(cop[0].emailRestrictions) &&
        _checkUsageLimitPerUser(cop[0].usageLimitPerUser)) {
      print("badhu j che ");
      if (_checkAllowedLimit(
          usageCount: usagecount!, usageLimit: cop[0].usageLimit!)) {
        print(" exp nthi and vapri sakai che hji");
        print(emailcheck);
        if (_checkEmailAllowed(
            emails: emailcheck!, userEmail: contro.customer.value!.email!)) {
          print(" exp nthi and email contain kre che");
          if (_checkUsedBy(usedby)) {
            if (_checkUsedByAllowed(
                usedBy: usedby!,
                userEmail: contro.customer.value!.email!,
                usageLimitPerUser: cop[0].usageLimitPerUser)) {
              print("vapri sake che");
              couponPer(cop: cop);
              return;
            } else {
              print("used kri lithu che ");

              couponError();
              return;
            }
          } else {
            print("used j nai thayu hji");
            couponPer(cop: cop);
            return;
          }
        } else {
          print("email contain krti nathi");
          couponError();
          return;
        }
      } else {
        print("count limit pati gai che na vaprai");
        couponError();
        return;
      }
    } else if (_checkUsageLimit(usageLimit)) {
      print("aa limit check kre che ");
      if (_checkAllowedLimit(
          usageCount: usagecount!, usageLimit: cop[0].usageLimit!)) {
        print("hji vapri sake che ");
        if (_checkEmailRestrictions(emailcheck) &&
            _checkEmailAllowed(
                emails: emailcheck!,
                userEmail: contro.customer.value!.email!)) {
          print("email contain kre che ");
          if (_checkUsedBy(usedby)) {
            if (_checkUsedByAllowed(
                usedBy: usedby!,
                userEmail: contro.customer.value!.email!,
                usageLimitPerUser: cop[0].usageLimitPerUser)) {
              print("vapri sake che");
              couponPer(cop: cop);
              return;
            } else {
              print("used kri lithu che ");
              couponError();
              return;
            }
          } else {
            print("used j nai thayu hji");
            couponPer(cop: cop);
            return;
          }
        } else if (_checkEmailRestrictions(emailcheck) &&
            _checkEmailAllowed(
                emails: emailcheck!,
                userEmail: contro.customer.value!.email!)) {
          print("email che j pn match nathi thati flat ");
          couponError();
          return;
        } else {
          print("email res  ema nathi flat");
          couponPer(cop: cop);
          return;
        }
      } else {
        print("na chale flat");
        couponError();
      }
    } else if (_checkEmailRestrictions(emailcheck) &&
        _checkEmailAllowed(
            emails: emailcheck!, userEmail: contro.customer.value!.email!)) {
      print("usagelimit nthi pn email res che ");
      if (_checkUsedBy(usedby)) {
        print("usedby che per ");
        if (_checkUsageLimitPerUser(cop[0].usageLimitPerUser)) {
          print("user per limit j nthi ");
          couponPer(cop: cop);
          return;
        } else if (_checkUsedByAllowed(
            usedBy: usedby!,
            userEmail: contro.customer.value!.email!,
            usageLimitPerUser: cop[0].usageLimitPerUser)) {
          print("vapri sake che");
          couponPer(cop: cop);
          return;
        } else {
          print("used kri lithu che ");

          couponError();
          return;
        }
      } else {
        print("used j nai thayu hji");
        couponPer(cop: cop);
        return;
      }
    } else if (_checkUsageLimitPerUser(cop[0].usageLimitPerUser)) {
      print("aama user pr used krvani limit api che ");
      if (_checkUsedBy(usedby)) {
        print("usedby che  ");
        if (_checkUsedByAllowed(
            usedBy: usedby!,
            userEmail: contro.customer.value!.email!,
            usageLimitPerUser: cop[0].usageLimitPerUser)) {
          print("vapri sake che");
          couponPer(cop: cop);
          return;
        } else {
          print("used kri lithu che ");

          couponError();
          return;
        }
      } else {
        print("used j nai thayu hji khli limit che used per user ");
        couponPer(cop: cop);
        return;
      }
    } else if (_checkEmailRestrictions(emailcheck)) {
      print("khli aa emails mate j used thse");
      if (_checkEmailAllowed(
          emails: emailcheck!, userEmail: contro.customer.value!.email!)) {
        couponPer(cop: cop);
        return;
      } else {
        couponError();
        return;
      }
    } else {
      print("badhu j khli che");
      couponPer(cop: cop);
    }
  }

  couponCheckFlat({
    required List<CouponModel> cop,
    int? usageLimit,
    int? usagecount,
    List<String>? emailcheck,
    List<String>? usedby,
  }) {
    if (_checkUsageLimit(cop[0].usageLimit) &&
        _checkEmailRestrictions(cop[0].emailRestrictions) &&
        _checkUsageLimitPerUser(cop[0].usageLimitPerUser)) {
      print("badhu j che ");
      if (_checkAllowedLimit(
          usageCount: usagecount!, usageLimit: cop[0].usageLimit!)) {
        print(" exp nthi and vapri sakai che hji");
        if (_checkEmailAllowed(
            emails: emailcheck!, userEmail: contro.customer.value!.email!)) {
          print(" exp nthi and email contain kre che");
          if (_checkUsedBy(usedby)) {
            if (_checkUsedByAllowed(
                usedBy: usedby!,
                userEmail: contro.customer.value!.email!,
                usageLimitPerUser: cop[0].usageLimitPerUser)) {
              print("vapri sake che");
              couponFlat(cop: cop);
              return;
            } else {
              print("used kri lithu che ");

              couponError();
              return;
            }
          } else {
            print("used j nai thayu hji");
            couponFlat(cop: cop);
            return;
          }
        } else {
          print("email contain krti nathi");
          couponError();
          return;
        }
      } else {
        print("count limit pati gai che na vaprai");
        couponError();
        return;
      }
    } else if (_checkUsageLimit(usageLimit)) {
      print("aa limit check kre che ");
      if (_checkAllowedLimit(
          usageCount: usagecount!, usageLimit: cop[0].usageLimit!)) {
        print("hji vapri sake che ");
        if (_checkEmailRestrictions(emailcheck) &&
            _checkEmailAllowed(
                emails: emailcheck!,
                userEmail: contro.customer.value!.email!)) {
          print("email contain kre che ");
          if (_checkUsedBy(usedby)) {
            if (_checkUsedByAllowed(
                usedBy: usedby!,
                userEmail: contro.customer.value!.email!,
                usageLimitPerUser: cop[0].usageLimitPerUser)) {
              print("vapri sake che");
              couponFlat(cop: cop);
              return;
            } else {
              print("used kri lithu che ");
              couponError();
              return;
            }
          } else {
            print("used j nai thayu hji");
            couponFlat(cop: cop);
            return;
          }
        } else if (_checkEmailRestrictions(emailcheck) &&
            _checkEmailAllowed(
                emails: emailcheck!,
                userEmail: contro.customer.value!.email!)) {
          print("email che j pn match nathi thati flat ");
          couponError();
          return;
        } else {
          print("email res  ema nathi flat");
          couponFlat(cop: cop);
          return;
        }
      } else {
        print("na chale flat");
        couponError();
      }
    } else if (_checkEmailRestrictions(emailcheck) &&
        _checkEmailAllowed(
            emails: emailcheck!, userEmail: contro.customer.value!.email!)) {
      print("usagelimit nthi pn email res che ");
      if (_checkUsedBy(usedby)) {
        print("usedby che per ");
        if (_checkUsageLimitPerUser(cop[0].usageLimitPerUser)) {
          print("user per limit j nthi ");
          couponFlat(cop: cop);
          return;
        } else if (_checkUsedByAllowed(
            usedBy: usedby!,
            userEmail: contro.customer.value!.email!,
            usageLimitPerUser: cop[0].usageLimitPerUser)) {
          print("vapri sake che");
          couponFlat(cop: cop);
          return;
        } else {
          print("used kri lithu che ");

          couponError();
          return;
        }
      } else {
        print("used j nai thayu hji");
        couponFlat(cop: cop);
        return;
      }
    } else if (_checkUsageLimitPerUser(cop[0].usageLimitPerUser)) {
      print("aama user pr used krvani limit api che ");
      if (_checkUsedBy(usedby)) {
        print("usedby che  ");
        if (_checkUsedByAllowed(
            usedBy: usedby!,
            userEmail: contro.customer.value!.email!,
            usageLimitPerUser: cop[0].usageLimitPerUser)) {
          print("vapri sake che");
          couponFlat(cop: cop);
          return;
        } else {
          print("used kri lithu che ");

          couponError();
          return;
        }
      } else {
        print("used j nai thayu hji khli limit che used per user ");
        couponFlat(cop: cop);
        return;
      }
    } else if (_checkEmailRestrictions(emailcheck)) {
      print("khli aa emails mate j used thse");
      if (_checkEmailAllowed(
          emails: emailcheck!, userEmail: contro.customer.value!.email!)) {
        couponFlat(cop: cop);
        return;
      } else {
        couponError();
        return;
      }
    } else {
      print("badhu j khli che");
      couponFlat(cop: cop);
    }
  }

  couponFlat({required List<CouponModel> cop}) {
    if (_checkUsedForXitem(cop[0].limitUsageToXItems)) {
      if (_checkItemRestrict(cop[0].productIds)) {
        List<CartBox>? id = _getXitem(cop[0].productIds);
        if (id != null && id.isNotEmpty) {
          var couponvalue1 = double.parse(cop[0].amount!);
          print("aaa che coupon real $couponvalue1");
          var coup = double.parse(id[0].price);
          print("aaa che 1 product value $coup");
          // couponvalue = coup - couponvalue1;
          couponvalue = couponvalue1;
          print("aaa che coupon final value $couponvalue");
          finalprice = finalprice - shipvalue;

          finalprice = finalprice - couponvalue;
          // gstCal(price: finalprice.toString());

          if (finalprice < 0 || finalprice == 0) {
            print("aa to minius ma che flat");
            couponvalue = coup - couponvalue1;
            finalprice = shipvalue;
          } else {
            getGSTCalculation(price: finalprice.toString());
          }

          coupencode = cop[0].code;
          coupenid = cop[0].id;
          print("aaa che final  vado price $finalprice");

          isLoading(false);
          return;
        } else {
          print("this is ids: null che");
          couponError();
          return;
        }
      } else {
        var u = cop[0].limitUsageToXItems!;
        print("aa full quntity $quti");
        if (disxItem <= quti) {
          for (var i = 0; i < items!.length; i++) {
            if (items![i].price != "0") {
              var qud = items![i].quntity;
              print("aa qudi $u");
              print("aa price $xitemDiscount");
              if (qud > u) {
                xitemDiscount += double.parse(items![i].price) * u;
                print("greater");
                print(items![i].name);
                u = 0;
                if (u == 0) {
                  break;
                }
              } else {
                if (u != 0) {
                  xitemDiscount +=
                      double.parse(items![i].price) * items![i].quntity;
                  print("smaller");
                  print(items![i].name);
                  u = u - items![i].quntity;
                }
                if (u == 0) {
                  break;
                }
              }
            }
          }
          var couponvalue1 = double.parse(cop[0].amount!);
          print("aaa che coupon real $couponvalue1");
          couponvalue = couponvalue1;
          print("aaa che coupon final value $couponvalue");
          finalprice = finalprice - shipvalue;

          finalprice = finalprice - couponvalue;

          if (finalprice < 0 || finalprice == 0) {
            print("aa to minius ma che flat");
            couponvalue = double.parse(totalValue);
            finalprice = shipvalue;
          } else {
            getGSTCalculation(price: finalprice.toString());
          }

          coupencode = cop[0].code;
          coupenid = cop[0].id;
          print("aaa che final  vado price $finalprice");

          isLoading(false);
          return;
        } else {
          couponError();
          return;
        }
      }
    } else {
      var couponvalue1 = double.parse(cop[0].amount!);
      couponvalue = couponvalue1;
      finalprice = finalprice - shipvalue;

      finalprice = finalprice - couponvalue1;
      print("aaa che final  vado price coupon pachi $finalprice");

      if (finalprice < 0 || finalprice == 0) {
        print("aa to minius ma che flat");
        couponvalue = double.parse(totalValue);
        finalprice = shipvalue;
      } else {
        getGSTCalculation(price: finalprice.toString());
      }

      coupencode = cop[0].code;
      coupenid = cop[0].id;
      print("aaa che final  vado price $finalprice");

      isLoading(false);
    }
  }

  couponPer({required List<CouponModel> cop}) {
    print(cop[0].limitUsageToXItems);
    if (_checkUsedForXitem(cop[0].limitUsageToXItems)) {
      if (_checkItemRestrict(cop[0].productIds)) {
        List<CartBox>? id = _getXitem(cop[0].productIds);

        if (id != null && id.isNotEmpty) {
          var couponvalue1 = double.parse(cop[0].amount!);
          var dd = couponvalue1 / 100;
          finalprice = finalprice - shipvalue;
          var coup = double.parse(id[0].price);

          couponvalue = (coup * dd).roundToDouble();
          print("this is ids: ${id[0].price}");
          print("this is couponValue: $couponvalue");

          finalprice = (finalprice - couponvalue as double).roundToDouble();

          if (finalprice < 0 || finalprice == 0) {
            print("aa to minius ma che");
            couponvalue = couponvalue;
            finalprice = shipvalue;
          } else {
            getGSTCalculation(price: finalprice.toString());
          }

          coupencode = cop[0].code;
          coupenid = cop[0].id;

          isLoading(false);
          return;
        } else {
          print("this is ids: null che");
          couponError();
          return;
        }
      } else {
        var couponvalue1 = double.parse(cop[0].amount!);
        var dd = couponvalue1 / 100;
        print("couponV1 che $couponvalue1");
        print("dd che $dd");

        var u = cop[0].limitUsageToXItems!;
        print("aa full quntity $quti");
        if (disxItem <= quti) {
          for (var i = 0; i < items!.length; i++) {
            if (items![i].price != "0") {
              var qud = items![i].quntity;
              print("aa qudi $u");
              print("aa price $xitemDiscount");
              if (qud > u) {
                xitemDiscount += double.parse(items![i].price) * u;
                print("greater");
                print(items![i].name);
                u = 0;
                if (u == 0) {
                  break;
                }
              } else {
                if (u != 0) {
                  xitemDiscount +=
                      double.parse(items![i].price) * items![i].quntity;
                  print("smaller");
                  print(items![i].name);
                  u = u - items![i].quntity;
                }
                if (u == 0) {
                  break;
                }
              }
            }
          }
          couponvalue = (xitemDiscount * dd).roundToDouble();

          finalprice = finalprice - shipvalue;
          finalprice = (finalprice - couponvalue as double).roundToDouble();
          if (finalprice < 0 || finalprice == 0) {
            print("aa to minius ma che per  xitem");
            couponvalue = double.parse(totalValue);
            finalprice = shipvalue;
          } else {
            getGSTCalculation(price: finalprice.toString());
          }

          coupencode = cop[0].code;
          coupenid = cop[0].id;

          isLoading(false);
        } else {
          couponError();
          return;
        }
      }
    } else {
      var couponvalue1 = double.parse(cop[0].amount!);

      var dd = couponvalue1 / 100;
      finalprice = finalprice - shipvalue;
      couponvalue = (finalprice * dd as double).roundToDouble();
      // print(" aa cart 1 product ${contro.cartItems.value![0].price}");

      finalprice = (finalprice - couponvalue as double).roundToDouble();

      if (finalprice < 0 || finalprice == 0) {
        print("aa to minius ma che per");
        couponvalue = double.parse(totalValue);
        finalprice = shipvalue;
      } else {
        getGSTCalculation(price: finalprice.toString());
      }

      coupencode = cop[0].code;
      coupenid = cop[0].id;

      isLoading(false);
    }
  }

  couponError() {
    isLoading(false);
    Get.snackbar(
      "Invalid Coupon",
      "This Coupon is Invalid",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  bool _checkUsageLimit(int? usageLimit) {
    print("checking Limit Usage allowed");
    if (usageLimit != null) {
      return true;
    }
    return false;
  }

  bool _checkEmailRestrictions(List<String>? emailList) {
    if (emailList != null && emailList.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool _checkUsageLimitPerUser(int? limitPerUser) {
    if (limitPerUser != null) {
      return true;
    }
    return false;
  }

  bool _checkAllowedLimit({required int usageCount, required int usageLimit}) {
    if (usageCount < usageLimit) {
      return true;
    }
    return false;
  }

  bool _checkEmailAllowed(
      {required List<String> emails, required String userEmail}) {
    if (emails.contains(userEmail)) {
      return true;
    }
    return false;
  }

  bool _checkUsedBy(List<String>? usedBy) {
    if (usedBy != null || usedBy!.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool _checkUsedByAllowed(
      {required List<String> usedBy,
      required String userEmail,
      int? usageLimitPerUser}) {
    if (usageLimitPerUser != null) {
      var i = 0;
      for (var item in usedBy) {
        if (item == userEmail.toString()) {
          i = i + 1;
        }
      }
      print("aa check kre che $i");
      if (usageLimitPerUser > i) {
        return true;
      }
      return false;
    } else {
      return true;
    }
  }

  bool _checkUsedForXitem(int? xItem) {
    if (xItem != null) {
      return true;
    }
    return false;
  }

  bool _checkItemRestrict(List<int>? items) {
    if (items == null || items.isEmpty) {
      return false;
    }
    return true;
  }

  List<CartBox>? _getXitem(List<int>? productsids) {
    print("aa ids check kare che ");
    return items!
        .where((element) => productsids!.contains(element.id))
        .toList();
  }
}
