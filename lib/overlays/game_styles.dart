
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