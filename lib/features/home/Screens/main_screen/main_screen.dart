import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommerce/features/home/home.dart';
import 'package:ecommerce/features/profile/profile_screens.dart';
import 'package:ecommerce/features/cart/screens/cartscreen.dart';

class MainScreen extends StatefulWidget {
  final String userName;
  const MainScreen({super.key, required this.userName});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(userName: widget.userName),
      const ProfileScreens(),
      const BasketScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Color(0xFF2A9D8F),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        items: <Widget>[
          Icon(Icons.home, size: 30, color: _getIconColor(0)),
          Icon(Icons.person, size: 30, color: _getIconColor(0)),
          Icon(Icons.shopping_basket, size: 30, color: _getIconColor(0)),
        ],
      ),
    );
  }

  Color _getBackgroundColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF2A9D8F);
      case 1:
        return Colors.blueAccent;
      case 2:
        return Colors.redAccent;
      default:
        return const Color(0xFF2A9D8F);
    }
  }

  Color _getIconColor(int index) {
    return _selectedIndex == index ? _getBackgroundColor(index) : Colors.grey;
  }
}
