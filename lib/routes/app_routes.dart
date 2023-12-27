import 'package:flutter/material.dart';
import 'package:ryan_dedi_pratama_s_application1/presentation/wishlist_screen/wishlist_screen.dart';
import 'package:ryan_dedi_pratama_s_application1/presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String wishlistScreen = '/wishlist_screen';

  static const String productListPage = '/product_list_page';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    wishlistScreen: (context) => WishlistScreen(),
    appNavigationScreen: (context) => AppNavigationScreen()
  };
}
