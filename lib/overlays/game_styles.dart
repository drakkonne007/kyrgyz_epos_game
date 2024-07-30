
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

final mapDialogTextStyle = TextStyle
  (
    fontSize: 16,
    wordSpacing: 2,
    foreground: Paint()..
    style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFFFCF08E)
      // ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3)
);

final hitStateStyle = TextStyle
  (
    fontSize: 15,
    wordSpacing: 3,
    fontWeight:FontWeight.w900,
    foreground: Paint()..
    style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xA0FF0000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 10)
  // ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3)
);

final defaultNoneButtonStyle = ButtonStyle(
  minimumSize: WidgetStateProperty.all<Size>(Size.zero),
  foregroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
  backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
  overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
  shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
  surfaceTintColor: WidgetStateProperty.all<Color>(Colors.transparent),
  elevation: WidgetStateProperty.all<double>(0),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder()),
  padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
);