import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';

final regular = TextPaint(
    style: mapDialogTextStyle
);

void createSmallMapDialog({Vector2? position, Vector2? frameSize, required KyrgyzGame gameRef})
{
  String? text = gameRef.gameMap.currentGameWorldData?.getSmallMapDialog();
  if(text == null){
    return;
  }
  createText(position: position, frameSize: frameSize, text: text, gameRef: gameRef);
}

void createText(
    {Vector2? position, Vector2? frameSize,required String text,required KyrgyzGame gameRef})
{
  if(gameRef.gameMap.openSmallDialogs.contains(text)){
    return;
  }
  frameSize ??= Vector2(150,75);
  position ??= gameRef.playerPosition();
  RenderText textComponent = RenderText(position, frameSize, text);
  textComponent.priority = GamePriority.maxPriority;
  gameRef.gameMap.container.add(textComponent);
  gameRef.gameMap.openSmallDialogs.add(text);

  TimerComponent timer1 = TimerComponent(
    period: text.length * 0.05 + 2,
    removeOnFinish: true,
    onTick: () {
      textComponent.removeFromParent();
      gameRef.gameMap.openSmallDialogs.remove(text);
    },
  );
  gameRef.gameMap.add(timer1);
}

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
