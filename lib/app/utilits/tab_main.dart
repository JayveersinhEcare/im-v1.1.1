import 'package:flutter/material.dart';

import '../constants/constants.dart';

class TabNavigationItem {
  // final Widget page;
  final String title;
  final Widget icon;
  final Widget activeIcon;

  TabNavigationItem(
      {
      // required this.page,
      required this.title,
      required this.icon,
      required this.activeIcon});

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          // page: const HomeTabscreenView(),
          title: 'Home',
          icon: Image.asset(
            hometab,
            scale: 2.5,
          ),
          activeIcon: Image.asset(
            homeSelected,
            scale: 2.5,
          ),
        ),
        TabNavigationItem(
          // page: const ImCombooScreenView(),
          title: 'IM Combo',
          icon: Image.asset(
            im,
            scale: 5,
          ),
          activeIcon: Image.asset(
            imtabse,
            scale: 5,
          ),
        ),
        TabNavigationItem(
          // page: const OrderScreenView(),
          title: 'Orders',
          icon: Image.asset(
            order,
            scale: 2.5,
          ),
          activeIcon: Image.asset(
            orderSelected,
            scale: 2.5,
          ),
        ),
        TabNavigationItem(
          // page: const ProfileView(),
          title: 'Account',
          icon: Image.asset(
            account,
            scale: 2.5,
          ),
          activeIcon: Image.asset(
            accountSelected,
            scale: 2.5,
          ),
        ),
      ];
}
