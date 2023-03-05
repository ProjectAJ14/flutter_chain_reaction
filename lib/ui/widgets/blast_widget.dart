import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BlastWidget extends StatelessWidget {
  final double size;
  final Color color;

  const BlastWidget({
    super.key,
    this.size = 100,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.modulate,
      ),
      child: Lottie.asset(
        'assets/blast.json',
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
