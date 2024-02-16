
import 'dart:ui';
import 'package:flutter/material.dart';

final TextStyle dialogStyleFont = TextStyle
  (
    fontSize: 50,
    wordSpacing: 2,
    foreground: Paint()..
    style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFFFCF08E)
      ..strokeWidth = 20
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3)
);

final defaultTextStyle = TextStyle
  (
    foreground: Paint()..
    style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFFFCF08E)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3)
);

final defaultNoneButtonStyle = ButtonStyle(
  minimumSize: MaterialStateProperty.all<Size>(Size.zero),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
  shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
  surfaceTintColor: MaterialStateProperty.all<Color>(Colors.transparent),
  elevation: MaterialStateProperty.all<double>(0),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder()),
  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
);