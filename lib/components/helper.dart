
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/main.dart';

enum PlayerDirectionMove{
  Left,
  Right,
  Up,
}

class MoveArrow extends RectangleComponent with Tappable, HasGameRef<CustomGame>
{
  PlayerDirectionMove _direction;
  MoveArrow(this._direction, Vector2 pos, Vector2 size){
    position = pos;
    this.size = size;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    gameRef.tappableEvent(_direction,true);
    return true;
  }

  @override
  bool onLongTapDown(TapDownInfo info) {
    gameRef.tappableEvent(_direction,true);
    return true;
  }

  @override
  bool onTapCancel() {
    gameRef.tappableEvent(_direction,false);
    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    gameRef.tappableEvent(_direction,false);
    return true;
  }

}