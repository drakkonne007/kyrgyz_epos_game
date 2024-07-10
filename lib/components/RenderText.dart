import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/overlays/game_styles.dart';

final regular = TextPaint(
    style: mapDialogTextStyle
);

class RenderText extends ScrollTextBoxComponent
{
  final bgPaint = Paint()..color = const Color(0xA5000000);
  final borderPaint = Paint()..color = const Color(0xFFFFFF00)..style = PaintingStyle.stroke;

  RenderText(Vector2 position, Vector2 frameSize, String text) : super(
    size: frameSize,
    text: text,
    textRenderer: regular,
    position: position,
    boxConfig: const TextBoxConfig(timePerChar: 0.05),
  );

  @override
  void render(Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(rect, bgPaint);
    canvas.drawRect(rect.deflate(2), borderPaint);
    super.render(canvas);
  }
}
