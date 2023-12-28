import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../pages/home_page.dart';
import '../pages/explore_page.dart';
import '../pages/cart_page.dart';
import '../pages/transactions_page.dart';
import '../pages/profile_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyBottomNavBar extends StatelessWidget {
  final PersistentTabController controller;
  final int currentIndex;
  final Function(int) onItemSelected;

  const MyBottomNavBar({
    Key? key,
    required this.controller,
    required this.currentIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: const Color.fromARGB(255, 240, 236, 229),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBar: !showNavBar(),
      hideNavigationBarWhenKeyboardShows: true,
      decoration: const NavBarDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 4.0,
          ),
        ],
      ),
      navBarStyle: NavBarStyle.style3,
      onItemSelected: (index) {
        if (index != controller.index) {
          onItemSelected(index);
        }
      },
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const ExplorePage(),
      const CartPage(),
      const TransactionsPage(),
      const ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.house),
        iconSize: 24,
        title: 'Home',
        activeColorPrimary: const Color.fromARGB(255, 49, 48, 77),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.solidCompass),
        iconSize: 24,
        title: 'Explore',
        activeColorPrimary: const Color.fromARGB(255, 49, 48, 77),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.cartShopping),
        iconSize: 24,
        title: 'Cart',
        activeColorPrimary: const Color.fromARGB(255, 49, 48, 77),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.receipt),
        iconSize: 24,
        title: 'Transactions',
        activeColorPrimary: const Color.fromARGB(255, 49, 48, 77),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.solidCircleUser),
        iconSize: 24,
        title: 'Profile',
        activeColorPrimary: const Color.fromARGB(255, 49, 48, 77),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  bool showNavBar() {
    return currentIndex == 0 ||
        currentIndex == 1 ||
        currentIndex == 2 ||
        currentIndex == 3 ||
        currentIndex == 4;
  }
}
