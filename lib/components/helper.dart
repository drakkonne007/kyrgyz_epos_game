
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/main.dart';

enum PlayerDirectionMove{
  Left,
  Right,
  Up,
  Down,
}

class MoveArrow extends RectangleComponent with Tappable, HasGameRef<KyrgyzGame>
{
  PlayerDirectionMove _direction;
  MoveArrow(this._direction, Vector2 pos, Vector2 size){
    position = pos;
    this.size = size;
    positionType = PositionType.widget;
  }

  @override
  Future<void> onLoad() async{
    setColor(BasicPalette.red.color);
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

class CustomJoystick extends CircleComponent with Tappable, HasGameRef<KyrgyzGame>
{
  CustomJoystick(Vector2 pos, Vector2 size){
    position = pos;
    this.size = size;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if(atan2(info.raw.localPosition.dx - center.x, info.raw.localPosition.dy - center.y) > 10){

    }
    print('Hohoho222');
    // gameRef.tappableEvent(_direction,true);
    return true;
  }

  @override
  bool onLongTapDown(TapDownInfo info) {
    print('Hohoho');
    // gameRef.tappableEvent(_direction,true);
    return true;
  }

  @override
  bool onTapCancel() {
    // gameRef.tappableEvent(_direction,false);
    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    // gameRef.tappableEvent(_direction,false);
    return true;
  }
}

class OrthoJoystick extends StatelessWidget
{
  KyrgyzGame _game;
  Vector2 _size,_pos;
  OrthoJoystick(this._game, this._size, this._pos);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child:Container(
        width: _size.x,
        height: _size.y,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(_size.x)),color: Colors.green),
        child: GestureDetector(
          onTap: (){
            print('Wohoo');
            _game.tappableEvent(PlayerDirectionMove.Right,true);
          },
        ),
      ),
    );
  }
}
