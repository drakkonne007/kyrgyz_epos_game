
import 'dart:math' as math;

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
    if(math.atan2(info.raw.localPosition.dx - center.x, info.raw.localPosition.dy - center.y) > 10){

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
  double _size;
  OrthoJoystick(this._game, this._size);

  @override
  State<OrthoJoystick> createState() => _OrthoJoystickState(_size);
}

class _OrthoJoystickState extends State<OrthoJoystick> {
  double _size;
  late double _left,_top;
  _OrthoJoystickState(this._size){
    _left = _size/2 - _size/8;
    _top = _size/2 - _size/8;
  }

  void doMove(double dx, double dy){
    setState(() {
      if(math.sqrt(math.pow(dx-_size / 2,2) + math.pow(dy-_size / 2, 2)) > _size / 2){
        var ugol = math.atan2(dx - _size/2,dy - _size / 2);
        _left = math.sin(ugol) * _size / 2 - _size/8 + _size/2;
        _top = math.cos(ugol) * _size / 2 - _size/8 + _size/2;
      }else {
        _left = dx - _size/8;
        _top = dy - _size/8;
      }
    });
  }

  void stopMove(){
    setState(() {
      _left = _size/2 - _size/8;
      _top = _size/2 - _size/8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: _size,
        height: _size,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(_size)),color: Colors.blue.withAlpha(100)),
        child:  Stack(
            fit: StackFit.passthrough,
            children:<Widget>[
              GestureDetector(
                onTapUp: (details){
                  stopMove();
                },
                onPanStart: (details){
                  doMove(details.localPosition.dx, details.localPosition.dy);
                },
                onPanUpdate: (details){
                  doMove(details.localPosition.dx, details.localPosition.dy);
                },
                onPanCancel: (){
                  stopMove();
                },
              ),
              Positioned(
                  width: _size/4,
                  height: _size/4,
                  left: _left,
                  top: _top,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(_size)),color: Colors.red.withAlpha(220)),
                  ))]
        ),
      ),
    );
  }
}
