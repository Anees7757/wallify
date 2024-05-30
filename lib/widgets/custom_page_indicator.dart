import 'package:flutter/material.dart';

class CustomPageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const CustomPageIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: currentIndex == index ? 24.0 : 8.0,
          decoration: BoxDecoration(
            color:
                currentIndex == index ? Colors.black : const Color(0xffDFDFDF),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }
}
