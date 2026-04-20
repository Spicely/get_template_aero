import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD6E0),
            Color(0xFFD4F0F0),
            Color(0xFFE0E7FF),
            Color(0xFFEEDCFF),
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: child,
    );
  }
}
