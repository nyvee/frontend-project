import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../pages/home.dart';
import '../pages/explore.dart';
import '../pages/cart.dart';
import '../pages/transactions.dart';
import '../pages/profile.dart';

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
    return shouldShowNavBar()
        ? PersistentTabView(
            context,
            controller: controller, // Use the provided controller directly
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: Color.fromARGB(255, 240, 236, 229),
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
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
            onItemSelected: onItemSelected,
          )
        : SizedBox.shrink();
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      ExplorePage(),
      CartPage(),
      TransactionsPage(),
      ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: currentIndex == 0
            ? const Icon(Icons.home)
            : const Icon(Icons.home_outlined),
        title: 'Home',
        activeColorPrimary: Color.fromARGB(255, 49, 48, 77),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: currentIndex == 1
            ? const Icon(Icons.explore_rounded)
            : const Icon(Icons.explore_outlined),
        title: 'Explore',
        activeColorPrimary: Color.fromARGB(255, 49, 48, 77),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: currentIndex == 2
            ? const Icon(Icons.shopping_cart)
            : const Icon(Icons.shopping_cart_outlined),
        title: 'Cart',
        activeColorPrimary: Color.fromARGB(255, 49, 48, 77),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: currentIndex == 3
            ? const Icon(Icons.receipt_long)
            : const Icon(Icons.receipt_long_rounded),
        title: 'Transactions',
        activeColorPrimary: Color.fromARGB(255, 49, 48, 77),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: currentIndex == 4
            ? const Icon(Icons.person)
            : const Icon(Icons.person_outline),
        title: 'Profile',
        activeColorPrimary: Color.fromARGB(255, 49, 48, 77),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  // should show navbar only on 5 pages
  bool shouldShowNavBar() {
    final int currentIndex = controller.index;
    return currentIndex == 0 ||
        currentIndex == 1 ||
        currentIndex == 2 ||
        currentIndex == 3 ||
        currentIndex == 4;
  }
}
