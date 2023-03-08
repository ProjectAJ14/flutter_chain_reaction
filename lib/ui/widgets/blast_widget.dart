import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BlastWidget extends StatelessWidget {
  final int index;
  final Size size;

  const BlastWidget({
    super.key,
    required this.index,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/blast$index.json',
      fit: BoxFit.fill,
      width: size.width,
      height: size.height,
    );
  }
}
