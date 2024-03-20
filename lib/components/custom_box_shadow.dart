import 'package:flutter/material.dart';

class CustomBoxShadow extends BoxShadow {
  const CustomBoxShadow({
    Color color = Colors.black,
    Offset offset = Offset.zero,
    double blurRadius = 5,
    BlurStyle blurStyle = BlurStyle.outer,
  }) : super(
          color: color,
          offset: offset,
          blurRadius: blurRadius,
          blurStyle: blurStyle,
        );

  @override
  Paint toPaint() {
    final result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) {
        result.maskFilter = null;
      }
      return true;
    }());
    return result;
  }
}
