import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton(
      {super.key,
      this.icon = Icons.phone,
      this.color = Colors.black,
      this.onTap});
  final VoidCallback? onTap;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
          border: Border.all(color: color, width: 2.0), shape: BoxShape.circle),
      child: IconButton(
        iconSize: 25,
        icon: Icon(
          icon,
          color: color,
        ),
        onPressed: onTap,
      ),
    );
  }
}
