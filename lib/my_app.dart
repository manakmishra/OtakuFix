import 'package:flutter/material.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/screens/favourites/favourites_screen.dart';
import 'package:otaku_fix/screens/home/home_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// ignore: must_be_immutable
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      navBarHeight: 65.0,
      backgroundColor: kNavBarColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
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
      navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}

List<Widget> _buildScreens() {
  return [
    HomePage(),
    FavouritesScreen()
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: ("Home"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: kAccentColor,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.favorite),
      title: ("Favourites"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: kAccentColor,
    ),
  ];
}
