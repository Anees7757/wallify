import 'package:flutter/material.dart';
import 'package:wallify/screens/home_screen.dart';
import 'categories_screen.dart';
import '../widgets/custom_nav_bar.dart';

class RouteScreen extends StatefulWidget {
  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  int _currentIndex = 1;

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = [
    CategoriesScreen(),
    HomeScreen(),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_currentIndex),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavBarTap,
          ),
        ],
      ),
    );
  }
}
