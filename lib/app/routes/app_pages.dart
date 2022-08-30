import 'package:get/get.dart';

import '../modules/addressScreen/bindings/address_screen_binding.dart';
import '../modules/addressScreen/views/address_screen_view.dart';
import '../modules/allProductScreen/bindings/all_product_screen_binding.dart';
import '../modules/allProductScreen/views/all_product_screen_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_view.dart';
import '../modules/changePasswordScreen/bindings/change_password_screen_binding.dart';
import '../modules/changePasswordScreen/views/change_password_screen_view.dart';
import '../modules/checkAddressScreen/bindings/check_address_screen_binding.dart';
import '../modules/checkAddressScreen/views/check_address_screen_view.dart';
import '../modules/drawerScreen/bindings/drawer_screen_binding.dart';
import '../modules/drawerScreen/views/drawer_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/homeTabscreen/bindings/home_tabscreen_binding.dart';
import '../modules/homeTabscreen/views/home_tabscreen_view.dart';
import '../modules/imCombooScreen/bindings/im_comboo_screen_binding.dart';
import '../modules/imCombooScreen/views/im_comboo_screen_view.dart';
import '../modules/orderScreen/bindings/order_screen_binding.dart';
import '../modules/orderScreen/views/order_screen_view.dart';
import '../modules/productDetail/bindings/product_detail_binding.dart';
import '../modules/productDetail/views/product_detail_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profileDetailScreen/bindings/profile_detail_screen_binding.dart';
import '../modules/profileDetailScreen/views/profile_detail_screen_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/summaryScreen/bindings/summary_screen_binding.dart';
import '../modules/summaryScreen/views/summary_screen_view.dart';
import '../modules/thankYouScreen/bindings/thank_you_screen_binding.dart';
import '../modules/thankYouScreen/views/thank_you_screen_view.dart';
import '../modules/timeLineScreen/bindings/time_line_screen_binding.dart';
import '../modules/timeLineScreen/views/time_line_screen_view.dart';
import '../modules/wishlist/bindings/wishlist_binding.dart';
import '../modules/wishlist/views/wishlist_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.WISHLIST,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.TIME_LINE_SCREEN,
      page: () => const TimeLineScreenView(),
      binding: TimeLineScreenBinding(),
    ),
    GetPage(
      name: _Paths.THANK_YOU_SCREEN,
      page: () => const ThankYouScreenView(),
      binding: ThankYouScreenBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESS_SCREEN,
      page: () => const AddressScreenView(),
      binding: AddressScreenBinding(),
    ),
    GetPage(
      name: _Paths.DRAWER_SCREEN,
      page: () => const DrawerScreenView(),
      binding: DrawerScreenBinding(),
    ),
    GetPage(
      name: _Paths.IM_COMBOO_SCREEN,
      page: () => const ImCombooScreenView(),
      binding: ImCombooScreenBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_SCREEN,
      page: () => const OrderScreenView(),
      binding: OrderScreenBinding(),
    ),
    GetPage(
      name: _Paths.HOME_TABSCREEN,
      page: () => const HomeTabscreenView(),
      binding: HomeTabscreenBinding(),
    ),
    GetPage(
      name: _Paths.SUMMARY_SCREEN,
      page: () => const SummaryScreenView(),
      binding: SummaryScreenBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRODUCT_SCREEN,
      page: () => const AllProductScreenView(),
      binding: AllProductScreenBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_DETAIL_SCREEN,
      page: () => const ProfileDetailScreenView(),
      binding: ProfileDetailScreenBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD_SCREEN,
      page: () => const ChangePasswordScreenView(),
      binding: ChangePasswordScreenBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_ADDRESS_SCREEN,
      page: () => const CheckAddressScreenView(),
      binding: CheckAddressScreenBinding(),
    ),
  ];
}
