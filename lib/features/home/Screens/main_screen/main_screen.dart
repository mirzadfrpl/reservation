import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/features/home/home.dart';
import 'package:ecommerce/features/profile/profile_screens.dart';
import 'package:ecommerce/features/favorite/favorites_screen.dart';
import 'package:ecommerce/providers/home_provider.dart';

class MainScreen extends StatelessWidget {
  final String userName;

  const MainScreen({super.key, required this.userName});

  List<Widget> _screens(String userName) => [
    HomeScreen(userName: userName),
    const ProfileScreens(),
    const FavoritesScreen(),
  ];

  Color _getIconColor(int index, int selectedIndex, BuildContext context) {
    return selectedIndex == index
        ? Theme.of(context).primaryColor
        : Theme.of(context).unselectedWidgetColor;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Scaffold(
          extendBody: true,
          body: _screens(userName)[homeProvider.selectedIndex],
          bottomNavigationBar: CurvedNavigationBar(
            index: homeProvider.selectedIndex,
            onTap: (index) {
              homeProvider.setSelectedIndex(index);
            },
            backgroundColor: Colors.transparent,
            color: Theme.of(context).colorScheme.surface,
            buttonBackgroundColor: Theme.of(context).colorScheme.surface,
            height: 60,
            animationDuration: const Duration(milliseconds: 300),
            items: <Widget>[
              Icon(
                Icons.home,
                size: 28,
                color: _getIconColor(0, homeProvider.selectedIndex, context),
              ),
              Icon(
                Icons.person,
                size: 28,
                color: _getIconColor(1, homeProvider.selectedIndex, context),
              ),
              Icon(
                Icons.favorite,
                size: 28,
                color: _getIconColor(2, homeProvider.selectedIndex, context),
              ),
            ],
          ),
        );
      },
    );
  }
}
