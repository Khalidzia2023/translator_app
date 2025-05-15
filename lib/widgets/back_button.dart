import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double iconSize;
  final IconData icon;
  final Color btnColor;
  const CustomBackButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.btnColor,
    required this.iconSize
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),  // Icon passed as parameter
      onPressed: onPressed,  // onPressed action passed as parameter
      color: btnColor,
      iconSize: iconSize,
    );
  }
}
