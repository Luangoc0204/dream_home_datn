import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/CartViewModel.dart';
import 'package:dreamhome/viewmodels/CommentViewModel.dart';
import 'package:dreamhome/viewmodels/PostViewModel.dart';
import 'package:dreamhome/viewmodels/ShopViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/home/Home.dart';
import 'package:dreamhome/views/notification/NotificationPage.dart';
import 'package:dreamhome/views/shop/Shopping.dart';
import 'package:dreamhome/views/user/UserPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as Firebase;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
class BottomNavigationDirectional extends StatefulWidget {
  const BottomNavigationDirectional({super.key});

  @override
  State<BottomNavigationDirectional> createState() => _BottomNavigationDirectionalState();
}

class _BottomNavigationDirectionalState extends State<BottomNavigationDirectional> {
  late PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    getCurrentUser();

  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      ShoppingPage(),
      NotificationPage(),
      UserPage()
    ];
  }
  Future<void> getCurrentUser() async {
    String? email = Firebase.FirebaseAuth.instance.currentUser!.email;
    if (email != null){
      await context.read<UserViewModel>().getCurrentUser(email);
    }
    User? currentUser = await  context.read<UserViewModel>().currentUser;
    if (currentUser != null){
      await context.read<CartViewModel>().getCart(currentUser.id);
      await context.read<ShopViewModel>().getCurrentShop(currentUser.id);
      await context.read<PostViewModel>().getAllPost(currentUser.id);
    }
    print("Current User: " + currentUser.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: "Home",
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.storefront),
        title: "Shopping",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notifications_none),
        title: "Notification",
        activeColorPrimary: CupertinoColors.activeGreen,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_outline),
        title: "User",
        activeColorPrimary: CupertinoColors.systemPink,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: false, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style9, // Choose the nav bar style with this property.
      );
    }
}
