
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

class OrthoJoystick extends StatefulWidget
{
  KyrgyzGame _game;
  Vector2 _size;
  OrthoJoystick(this._game, this._size);

  @override
  State<OrthoJoystick> createState() => _OrthoJoystickState(_size);
}

class _OrthoJoystickState extends State<OrthoJoystick> {
  Vector2 _size;
  late double _left,_top;
  _OrthoJoystickState(this._size){
    _left = _size.x/2 - _size.x/8;
    _top = _size.y/2 - _size.y/8;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: _size.x,
        height: _size.y,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(_size.x)),color: Colors.blue.withAlpha(100)),
        child:  Stack(
            fit: StackFit.passthrough,
            children:<Widget>[GestureDetector(
              // onTap: (){
              //   setState(() {
              //     _left = details.localPosition.dx - _size.x/8;
              //     _top = details.localPosition.dy - _size.y/8;
              //   });
              //   print('Wohoo');
              //   widget._game.tappableEvent(PlayerDirectionMove.Right,true);
              //
              // },
              onTapUp: (details){
                setState(() {
                  _left = _size.x/2 - _size.x/8;
                  _top = _size.y/2 - _size.y/8;
                });
              },
              onPanStart: (details){
                setState(() {
                  _left = details.localPosition.dx - _size.x/8;
                  _top = details.localPosition.dy - _size.y/8;
                });
              },
              onPanUpdate: (details){
                setState(() {
                  _left = details.localPosition.dx - _size.x/8;
                  _top = details.localPosition.dy - _size.y/8;
                });
              },
              onPanCancel: (){
                setState(() {
                  _left = _size.x/2 - _size.x/8;
                  _top = _size.y/2 - _size.y/8;
                });
              },
            ),
              Positioned(
                  width: _size.x/4,
                  height: _size.y/4,
                  left: _left,
                  top: _top,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(_size.x)),color: Colors.red.withAlpha(220)),
                  ))]
        ),
      ),
    );
  }
}
