import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlowingButton extends StatelessWidget {
  final bool isArmed;
  final VoidCallback onTap;

  const GlowingButton({
    super.key,
    required this.isArmed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor = isArmed ? Colors.redAccent : Colors.cyanAccent;
    final List<BoxShadow> glow = [
      BoxShadow(
        color: accentColor.withOpacity(0.5),
        blurRadius: 20,
        spreadRadius: 5,
      ),
      BoxShadow(
        color: accentColor.withOpacity(0.3),
        blurRadius: 40,
        spreadRadius: 10,
      ),
    ];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 400.ms,
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),
          boxShadow: isArmed ? glow : [],
          border: Border.all(
            color: accentColor.withOpacity(0.8),
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isArmed ? Icons.lock : Icons.lock_open,
              color: accentColor,
              size: 50,
            ).animate(target: isArmed ? 1 : 0).shimmer(duration: 1.seconds),
            const SizedBox(height: 10),
            Text(
              isArmed ? 'ARMED' : 'DISARMED',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut);
  }
}
