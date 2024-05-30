import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomNavBar({required this.currentIndex, required this.onTap});

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: const Color(0xffDFDFDF),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(Icons.grid_view_outlined, Icons.grid_view, 0),
          _buildNavItem(Icons.explore_outlined, Icons.explore, 1),
          _buildNavItem(Icons.favorite_border, Icons.favorite, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData iconOutlined, IconData iconFilled, int index) {
    return IconButton(
      splashRadius: 25,
      icon: Icon(
        size: 25,
        widget.currentIndex == index ? iconFilled : iconOutlined,
        color: widget.currentIndex == index ? Colors.black : Colors.grey,
      ),
      onPressed: () => widget.onTap(index),
    );
  }
}
