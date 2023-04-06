import 'package:flame/collisions.dart';
import 'package:flame/palette.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;


class CustomCircle extends SpriteAnimationComponent{

  double _speedX = 350;
  late double _screenWidth;

  CustomCircle(Vector2 pos, double screenWidth) {
    position = pos;
    _screenWidth = screenWidth;
  }

  @override
  Future<void> onLoad() async{
    size = Vector2(50,50);
    CircleHitbox hitBox = CircleHitbox();
    hitBox.size = size;
    hitBox.paint.color = BasicPalette.red.color;
    hitBox.renderShape = true;
    add(hitBox);
  }

  @override
  void update(double dt) {
    if(position.x < 0){
      position.x = 0;
      _speedX *= -1;
    }
    if(position.x + width > _screenWidth){
      position.x = _screenWidth - width;
      _speedX *= -1;
    }
    position.x += _speedX * dt;
    super.update(dt);
  }
}
