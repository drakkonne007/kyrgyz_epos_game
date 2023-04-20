import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class HitOverlay extends StatelessWidget
{
  static const id = "HitOverlay";
  @override
  Widget build(BuildContext context) {
    return Positioned(
        width: MediaQueryData.fromWindow(ui.window).size.width,
        height: MediaQueryData.fromWindow(ui.window).size.height,
        top:0,
        right: 0,
        child: GestureDetector(

        ));
  }

}