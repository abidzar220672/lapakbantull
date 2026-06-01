import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final bool darkBackground;

  const LogoWidget({
    super.key,
    this.size = 80,
    this.darkBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: darkBackground ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
            color: darkBackground
                ? AppColors.accentGold.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: size * 0.3,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Shield body
          Container(
            width: size * 0.65,
            height: size * 0.72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A2F5A), Color(0xFF0D1B3E)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size * 0.1),
                topRight: Radius.circular(size * 0.1),
                bottomLeft: Radius.circular(size * 0.05),
                bottomRight: Radius.circular(size * 0.05),
              ),
            ),
            child: Center(
              child: Text(
                'LB',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          // Gold stripe top
          Positioned(
            top: size * 0.13,
            child: Container(
              width: size * 0.65,
              height: size * 0.06,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          // Red stripe
          Positioned(
            top: size * 0.21,
            child: Container(
              width: size * 0.65,
              height: size * 0.04,
              color: const Color(0xFFCC0000),
            ),
          ),
        ],
      ),
    );
  }
}
