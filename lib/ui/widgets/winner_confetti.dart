import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WinnerConfetti {
  static Widget show(BuildContext context, {bool isStacked = true}) => isStacked
      ? Positioned.fill(
          child: returnLoader(context),
        )
      : returnLoader(context);

  static Widget returnLoader(BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
        child: Center(
          child: Lottie.asset(
            'assets/confetti.json',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.9,
            fit: BoxFit.fitWidth,
          ),
        ),
      );
}
