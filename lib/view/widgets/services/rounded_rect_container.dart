import 'package:flutter/material.dart';

class RoundedRectContainer extends StatelessWidget {
  const RoundedRectContainer({super.key, this.child, this.backgroundColor});
  final Widget? child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: child,
      ),
    );
  }
}
