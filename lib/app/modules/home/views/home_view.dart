import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/constants.dart';
import '../../../routes/app_pages.dart';
import '../../../utilits/item_search.dart';
import '../../../utilits/tab_main.dart';
import '../../drawerScreen/views/drawer_screen_view.dart';
import '../../homeTabscreen/views/home_tabscreen_view.dart';
import '../../imCombooScreen/views/im_comboo_screen_view.dart';
import '../../orderScreen/views/order_screen_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print(controller.gUser.value);
    return SafeArea(
      child: Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 80.0,
          title: Image.asset(
            mainLogo,
            scale: 2.5,
            // width: 60,
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: IconButton(
                icon: Image.asset(
                  search,
                  scale: 2,
                ),
                onPressed: () async {
                  showSearch(
                    context: context,
                    delegate: ItemSearch(),
                  );
                },
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(7.0),
                child: Badge(
                  badgeColor: tabColor,
                  padding: const EdgeInsets.all(5.0),
                  position: const BadgePosition(
                    bottom: 35.0,
                    start: 25.0,
                  ),
                  badgeContent: Center(
                    child: Text(
                      "${controller.cartCount.value}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.CART);
                    },
                  ),
                ),
              ),
            ),
          ],
          leading: IconButton(
            icon: Image.asset(
              drawer,
              scale: 2.0,
            ),
            onPressed: () {
              controller.openDrawer();
            },
          ),
        ),
        drawer: const DrawerScreenView(),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedItemColor: tabColor,
            selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
            unselectedItemColor: Colors.black45,
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
            onTap: (value) {
              controller.changeTabIndex(value);
            },
            currentIndex: controller.tabIndex.value,
            items: <BottomNavigationBarItem>[
              for (var tabItem in TabNavigationItem.items)
                BottomNavigationBarItem(
                  icon: tabItem.icon,
                  label: tabItem.title.toString(),
                  activeIcon: tabItem.activeIcon,
                )
            ],
          ),
        ),
        body: Obx(() => IndexedStack(
              index: controller.tabIndex.value,
              children: const [
                HomeTabscreenView(),
                ImCombooScreenView(),
                OrderScreenView(),
                ProfileView(),
              ],
            )),
      ),
    );
  }
}
