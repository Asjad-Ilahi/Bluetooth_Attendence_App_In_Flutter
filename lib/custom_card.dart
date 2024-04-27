import 'package:flutter/material.dart';

class MyCardButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onPressed;
  final Widget child;
  final Color color;

  MyCardButton({
    required this.width,
    required this.height,
    required this.onPressed,
    required this.child,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: color,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}